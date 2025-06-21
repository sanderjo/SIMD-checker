# C code generated with ChatGPT

Prompt: 'an example pure-C program that results in SIMD code"



# On RISC-V

```
gcc -O3 -march=rv64gcv -ftree-vectorize -o simd_example simd_example.c
```

Or extra info during compiling:

```
$ gcc -O3 -march=rv64gcv -ftree-vectorize -fopt-info-vec-optimized -o simd_example simd_example.c

simd_example.c:7:23: optimized: loop vectorized using variable length vectors
simd_example.c:7:23: optimized:  loop versioned for vectorization because of possible aliasing
simd_example.c:7:23: optimized: loop vectorized using variable length vectors
simd_example.c:17:23: optimized: loop vectorized using variable length vectors
```
Check there are SIMD commands:
```
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
or
```
$ objdump -d simd_example | grep -E 'v[0-9]+'
   1053a:	5208a1d7          	vid.v	v3
   1054c:	4a3190d7          	vfcvt.f.x.v	v1,v3
   10550:	9630b157          	vsll.vi	v2,v3,1
   10556:	0206e0a7          	vse32.v	v1,(a3)
   1055a:	4a219157          	vfcvt.f.x.v	v2,v2
   10562:	5e07c0d7          	vmv.v.x	v1,a5
   1056c:	02066127          	vse32.v	v2,(a2)
   10574:	023081d7          	vadd.vv	v3,v3,v1
   1058c:	0205e107          	vle32.v	v2,(a1)
   10590:	02086087          	vle32.v	v1,(a6)
   1059e:	021110d7          	vfadd.vv	v1,v1,v2
   105a2:	0206e0a7          	vse32.v	v1,(a3)
   106e0:	02056087          	vle32.v	v1,(a0)
   106e4:	0205e107          	vle32.v	v2,(a1)
   106f2:	021110d7          	vfadd.vv	v1,v1,v2
   106f6:	020660a7          	vse32.v	v1,(a2)
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

Check x86 binary for SIMD:

```
$ objdump -d simd_example | grep -E 'xmm|ymm|zmm'
    1118:	c5 fd 6f 0d 00 0f 00 	vmovdqa 0xf00(%rip),%ymm1        # 2020 <_IO_stdin_used+0x20>
    1123:	62 f2 7d 28 7c da    	vpbroadcastd %edx,%ymm3
    1140:	c5 fd 6f c1          	vmovdqa %ymm1,%ymm0
    1144:	c5 f5 fe cb          	vpaddd %ymm3,%ymm1,%ymm1
    1148:	c5 fc 5b d0          	vcvtdq2ps %ymm0,%ymm2
    114c:	c5 fd 72 f0 01       	vpslld $0x1,%ymm0,%ymm0
    1151:	c4 c1 7c 11 14 04    	vmovups %ymm2,(%r12,%rax,1)
    1157:	c5 fc 5b c0          	vcvtdq2ps %ymm0,%ymm0
    115b:	c5 fc 11 04 03       	vmovups %ymm0,(%rbx,%rax,1)
    1180:	c4 c1 7c 10 04 04    	vmovups (%r12,%rax,1),%ymm0
    1186:	c5 fc 58 04 03       	vaddps (%rbx,%rax,1),%ymm0,%ymm0
    118b:	c4 c1 7c 11 44 05 00 	vmovups %ymm0,0x0(%r13,%rax,1)
    11aa:	c5 f8 57 c0          	vxorps %xmm0,%xmm0,%xmm0
    11b3:	c4 c1 7a 5a 85 90 01 	vcvtss2sd 0x190(%r13),%xmm0,%xmm0
    1340:	c5 fc 10 04 06       	vmovups (%rsi,%rax,1),%ymm0
    1345:	c5 fc 58 04 07       	vaddps (%rdi,%rax,1),%ymm0,%ymm0
    134a:	c5 fc 11 04 02       	vmovups %ymm0,(%rdx,%rax,1)
    1380:	c5 fa 10 04 07       	vmovss (%rdi,%rax,1),%xmm0
    1385:	c5 fa 58 04 06       	vaddss (%rsi,%rax,1),%xmm0,%xmm0
    138a:	c5 fa 11 04 02       	vmovss %xmm0,(%rdx,%rax,1)
```

# On ARM64 aka Aarch64
```
gcc -O3 -march=native -ftree-vectorize -o simd_example simd_example.c
```
Check:
```
$ objdump -d simd_example | grep -E 'v[0-9]+|q[0-9]+'
 73c:	4f000483 	movi	v3.4s, #0x4
 744:	3dc27422 	ldr	q2, [x1, #2512]
 750:	4ea21c40 	mov	v0.16b, v2.16b
 754:	4ea38442 	add	v2.4s, v2.4s, v3.4s
 758:	4f215401 	shl	v1.4s, v0.4s, #1
 75c:	4e21d800 	scvtf	v0.4s, v0.4s
 760:	4e21d821 	scvtf	v1.4s, v1.4s
 764:	3ca16a80 	str	q0, [x20, x1]
 768:	3ca16a61 	str	q1, [x19, x1]
 780:	3ce16a60 	ldr	q0, [x19, x1]
 784:	3ce16a81 	ldr	q1, [x20, x1]
 788:	4e21d400 	fadd	v0.4s, v0.4s, v1.4s
 78c:	3ca16aa0 	str	q0, [x21, x1]
 940:	3ce36800 	ldr	q0, [x0, x3]
 944:	3ce36821 	ldr	q1, [x1, x3]
 948:	4e21d400 	fadd	v0.4s, v0.4s, v1.4s
 94c:	3ca36840 	str	q0, [x2, x3]
```
So SIMD, because v0–v31 → NEON/SIMD registers (AArch64)
