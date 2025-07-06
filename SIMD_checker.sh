#!/bin/bash

# Check if there are SIMD commands in a binary (ELF) file.
# works on 64-bit x86, RISCV-V and ARM

BINARY="$1"

if [ ! -f "$BINARY" ]; then
    echo "Usage: $0 <binary>"
    exit 1
fi

echo -n $1 " "

ARCH_INFO=$(file "$BINARY")
#echo -n "$ARCH_INFO"

if echo -n "$ARCH_INFO" | grep -q "ELF"; then
    echo -n "ELF binary. "
else
        echo "No ELF. Exiting."
        exit 1
fi

if echo -n "$ARCH_INFO" | grep -q "x86-64"; then
    echo -n "Detected x86_64 "
    #./run_x86.sh "$BINARY"
    if objdump -d $1 | grep -q -E 'xmm|ymm|zmm'; then
        echo -n "Match found: SIMD "
        #exit 0
    else
        echo "No match found: no SIMD "
        exit 1
    fi

elif echo -n "$ARCH_INFO" | grep -qi "AArch64"; then
    echo -n "Detected ARM64 (AArch64) "
    #./run_arm.sh "$BINARY"
    if objdump -d $1 | grep -q -E 'v[0-9]+|q[0-9]+'; then
        echo -n "Match found: SIMD "
        #exit 0
    else
        echo "No match found: no SIMD "
        exit 1
    fi

elif echo -n "$ARCH_INFO" | grep -qi "RISC-V "; then
    echo -n "Detected RISC-V "
    #./run_riscv.sh "$BINARY"
    if objdump -d $1 | grep -q -E 'v[0-9]+'; then
        echo -n "Match found: SIMD "
        #exit 0
    else
        echo "No match found: no SIMD "
        exit 1
    fi

# Older ISA's

# are these still around?
elif echo -n "$ARCH_INFO" | grep -q "Intel 80386"; then
    echo -n "Detected x86 (32-bit) "
    ./run_x86.sh "$BINARY"

# check on old Raspi?
elif echo -n "$ARCH_INFO" | grep -qi "ARM"; then
    echo -n "Detected ARM "
    ./run_arm.sh "$BINARY"



else
    echo -n "Unknown architecture:"
    echo "$ARCH_INFO"
    exit 2
fi

echo " "
