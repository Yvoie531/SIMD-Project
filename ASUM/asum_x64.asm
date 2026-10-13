section .data
absmask dq 0x7FFFFFFFFFFFFFFF

section .text
default rel
global asum_x64

asum_x64:
    vxorps xmm0, xmm0, xmm0
    vmovsd xmm2, [absmask]
    test ecx, ecx
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
