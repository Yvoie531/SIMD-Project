# SIMD-Project
The kernels are now NASM, following the course slides, and use only SIMD instructions that appear in them. All three still give the exact C answer at every size tested.
Testing
Visual Studio could not be run where this was built. Instead, the unmodified main.c was compiled into a real Windows program, linked with the nasm -f win64 object files, and run under Wine (a Windows compatibility layer on Linux).
• Sizes 1003, 2^20, 2^26 and 2^28 were all correct in both unoptimized and optimized builds.
• At 2^30, the 7 GB test machine printed "Not enough memory" as intended, so that size was not tested.
• The 42,012-check stress test passed again. It covers every n from 0 to 3000, arrays placed right against protected memory, garbage in the upper half of RCX, and random data.
What changed
• MASM → NASM. The setup slides use NASM: section .text, bits 64, default rel, global, and a Custom Build Tool in Visual Studio. The project setup changes accordingly (see New setup).
• Absolute value now uses only slide instructions. vpcmpeqd/vpsrlq and btr are gone. Each file now declares absmask dq 0x7FFFFFFFFFFFFFFF in section .data. That constant has every bit set except the sign bit, and it is loaded with slide instructions:
    ◦ vmovsd in the x86-64 kernel
    ◦ vmovdqu (two copies of the value) in the XMM kernel
    ◦ vbroadcastsd in the YMM kernel
  vandpd with the mask then clears the sign. The x86-64 kernel no longer needs RAX, so it uses one fewer register.
• One compromise in the x86-64 kernel: the slides have no scalar absolute-value instruction. It uses vandpd on a single loaded value, the same way MSVC compiles fabs, and still processes one element at a time.
• Zeroing now uses vxorps, the idiom from the slides.
• Timing is back to QueryPerformanceFrequency, and <time.h> is gone. The four remaining includes are all needed: stdio.h for printf, stdlib.h for malloc/free, math.h for fabs, and windows.h for the timer.
Kind
Instructions used
SIMD
vmovdqu, vmovsd, vbroadcastsd, vandpd, vaddpd, vaddsd, vhaddpd, vextractf128, vxorps
Ordinary x86
test, jz, add, sub, and, dec, jnz, jl, jge, ret
New setup (NASM, as in the slides)
1. Install NASM and copy nasm.exe into C:\nasm.
2. Create a new project → Empty Project, then add the four files under Source Files.
3. Set the platform to x64.
4. For each .asm file, open Properties with Configuration: All Configurations and Platform: x64:
    ◦ General: Excluded From Build = No, Item Type = Custom Build Tool, then Apply.
    ◦ Custom Build Tool → General: Command Line = C:\nasm\nasm -f win64 asum_x64.asm, Outputs = asum_x64.obj. Do the same for the asum_xmm and asum_ymm files.
5. Run in Debug and in Release (Ctrl+F5).
Use All Configurations in step 4. The slide's screenshot only sets Release, so Debug would not assemble the files otherwise. legacy_stdio_definitions.lib is not needed, because the assembly never calls printf.
The full code and deliverables checklist are in ASUM SIMD Project — Setup, Code & Deliverables.
