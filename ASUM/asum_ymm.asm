section .data
absmask dq 0x7FFFFFFFFFFFFFFF

section .text
default rel
global asum_ymm

asum_ymm:
    vxorps ymm0, ymm0, ymm0
    vbroadcastsd ymm2, [absmask]
    sub ecx, 4
    jl reduce

vector_loop:
    vandpd ymm1, ymm2, [rdx]
    vaddpd ymm0, ymm0, ymm1
    add rdx, 32
    sub ecx, 4
    jge vector_loop

reduce:
    vextractf128 xmm1, ymm0, 1
    vaddpd xmm0, xmm0, xmm1
    vhaddpd xmm0, xmm0, xmm0
    and ecx, 3
    jz done

scalar_loop:
    vmovsd xmm1, [rdx]
    vandpd xmm1, xmm1, xmm2
    vaddsd xmm0, xmm0, xmm1
    add rdx, 8
    dec ecx
    jnz scalar_loop

done:
    ret
