#!/bin/bash

# of a binary file, check if there are SIMD commands

BINARY="$1"

if [ ! -f "$BINARY" ]; then
    echo "Usage: $0 <binary>"
    exit 1
fi

ARCH_INFO=$(file "$BINARY")
#echo "$ARCH_INFO"


if echo "$ARCH_INFO" | grep -q "x86-64"; then
    echo "Detected x86_64"
    #./run_x86.sh "$BINARY"
    if objdump -d $1 | grep -q -E 'xmm|ymm|zmm'; then
        echo "Match found: SIMD"
        exit 0
    else
        echo "No match found: no SIMD"
        exit 1
    fi

elif echo "$ARCH_INFO" | grep -qi "AArch64"; then
    echo "Detected ARM64 (AArch64)"
    #./run_arm.sh "$BINARY"
    if objdump -d $1 | grep -q -E 'v[0-9]+|q[0-9]+'; then
        echo "Match found: SIMD"
        exit 0
    else
        echo "No match found: no SIMD"
        exit 1
    fi

elif echo "$ARCH_INFO" | grep -qi "RISC-V"; then
    echo "Detected RISC-V"
    #./run_riscv.sh "$BINARY"
    if objdump -d $1 | grep -q -E 'v[0-9]+'; then
        echo "Match found: SIMD"
        exit 0
    else
        echo "No match found: no SIMD"
        exit 1
    fi

# Older ISA's

# are these still around?
elif echo "$ARCH_INFO" | grep -q "Intel 80386"; then
    echo "Detected x86 (32-bit)"
    ./run_x86.sh "$BINARY"

# check on old Raspi?
elif echo "$ARCH_INFO" | grep -qi "ARM"; then
    echo "Detected ARM"
    ./run_arm.sh "$BINARY"



else
    echo "Unknown architecture:"
    echo "$ARCH_INFO"
    exit 2
fi
