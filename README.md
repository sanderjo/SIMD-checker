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

# On X86

```
gcc -O3 -march=native -ftree-vectorize -o simd_example simd_example.c
```
