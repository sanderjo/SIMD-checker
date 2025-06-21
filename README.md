# C code generated with ChatGPT

Prompt: 'an example pure-C program that results in SIMD code"



# On RISC-V

```
gcc -O3 -march=rv64gcv -ftree-vectorize -o simd_example simd_example.c
objdump -d simd_example | awk '{ print $3 }'  | sort -u | grep -E "^v"
```

which shows the RISC-V Vector commands:

```
vadd.vv
vfadd.vv
vfcvt.f.x.v
vid.v
vle32.v
vmv.v.x
vse32.v
vsetvli
vsll.vi
```

Or extra info during compiling:

```
$ gcc -O3 -march=rv64gcv -ftree-vectorize -fopt-info-vec-optimized -o simd_example simd_example.c

simd_example.c:7:23: optimized: loop vectorized using variable length vectors
simd_example.c:7:23: optimized:  loop versioned for vectorization because of possible aliasing
simd_example.c:7:23: optimized: loop vectorized using variable length vectors
simd_example.c:17:23: optimized: loop vectorized using variable length vectors
```

# On X86

```
gcc -O3 -march=native -ftree-vectorize -o simd_example simd_example.c
```
or
```
$ gcc -O3 -march=native -ftree-vectorize -fopt-info-vec-optimized simd_example.c
simd_example.c:7:23: optimized: loop vectorized using 32 byte vectors
simd_example.c:7:23: optimized:  loop versioned for vectorization because of possible aliasing
simd_example.c:7:23: optimized: loop vectorized using 32 byte vectors
simd_example.c:17:23: optimized: loop vectorized using 32 byte vectors
```

