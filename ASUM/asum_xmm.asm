section .data
absmask dq 0x7FFFFFFFFFFFFFFF, 0x7FFFFFFFFFFFFFFF

section .text
default rel
global asum_xmm

asum_xmm:
    vxorps xmm0, xmm0, xmm0
    vmovdqu xmm2, [absmask]
    sub ecx, 2
    jl reduce

vector_loop:
    vandpd xmm1, xmm2, [rdx]
    vaddpd xmm0, xmm0, xmm1
    add rdx, 16
    sub ecx, 2
    jge vector_loop

reduce:
    vhaddpd xmm0, xmm0, xmm0
    test ecx, 1
    jz done
    vmovsd xmm1, [rdx]
    vandpd xmm1, xmm1, xmm2
    vaddsd xmm0, xmm0, xmm1

done:
    ret
