#!/bin/bash

# Check if there are SIMD commands in a binary (ELF) file.
# works on 64-bit x86, RISCV-V and ARM

BINARY="$1"

if [ ! -f "$BINARY" ]; then
    echo "Usage: $0 <binary>"
    exit 1
fi

echo -n $1 " "


# Use 'file' command to get architecture information of the file given as argument
ARCH_INFO=$(file "$BINARY")
#echo -n "$ARCH_INFO"



# First check if the file is an ELF binary
if echo "$ARCH_INFO" | grep -q "ELF"; then
    echo -n "ELF binary. "
else
    echo "No ELF. Exiting."
    exit 1
fi

# check if 'objdump' is not available
if ! command -v objdump &> /dev/null; then
    echo "objdump could not be found"
    exit 1
fi 

OBJDUMP_RESULT=$(objdump --no-show-raw-insn --no-addresses  -d "$BINARY")

# Check for architecture and SIMD support
if echo "$ARCH_INFO" | grep -q "x86-64"; then
    echo -n "Detected x86_64 "
    if echo "$OBJDUMP_RESULT" | grep -q -E 'xmm|ymm|zmm'; then
        echo -n "SIMD "
    else
        echo "no SIMD "
        exit 1
    fi

elif echo "$ARCH_INFO" | grep -qi "AArch64"; then
    echo -n "Detected ARM64 (AArch64) "
    if echo "$OBJDUMP_RESULT" | grep -q -E 'v[0-9]+|q[0-9]+'; then
        echo -n "SIMD "
    else
        echo "no SIMD "
        exit 1
    fi

elif echo "$ARCH_INFO" | grep -qi "RISC-V "; then
    echo -n "Detected RISC-V "
    if echo "$OBJDUMP_RESULT" | grep -q -P '^[ \t]v'; then
        echo -n "SIMD "
    else
        echo "no SIMD "
        exit 1
    fi

# Older ISA's ... are these still around?
elif echo "$ARCH_INFO" | grep -q "Intel 80386"; then
    echo -n "Detected x86 (32-bit) "
    ./run_x86.sh "$BINARY"

# check on old Raspi?
elif echo "$ARCH_INFO" | grep -qi "ARM"; then
    echo -n "Detected ARM "
    ./run_arm.sh "$BINARY"

else
    echo -n "Unknown architecture:"
    echo "$ARCH_INFO"
    exit 2
fi

echo " "
