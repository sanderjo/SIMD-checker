#!/bin/sh

arch=$(uname -m)

if echo "$arch" | grep -qi '^riscv'; then
    # riscv
    gcc -O3 -march=rv64gcv -ftree-vectorize -fopt-info-vec-optimized -o simd_example simd_example.c
else
    # x86, arm
    gcc -O3 -march=native  -ftree-vectorize -fopt-info-vec-optimized -o simd_example simd_example.c
fi
