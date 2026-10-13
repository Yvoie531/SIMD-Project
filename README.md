# SIMD-Project
1. Install NASM and copy nasm.exe into C:\nasm.
2. Create a new project → Empty Project, then add the four files under Source Files.
3. Set the platform to x64.
4. For each .asm file, open Properties with Configuration: All Configurations and Platform: x64:
    ◦ General: Excluded From Build = No, Item Type = Custom Build Tool, then Apply.
    ◦ Custom Build Tool → General: Command Line = C:\nasm\nasm -f win64 asum_x64.asm, Outputs = asum_x64.obj. Do the same for the asum_xmm and asum_ymm files.
5. Run in Debug and in Release (Ctrl+F5).
Use All Configurations in step 4. The slide's screenshot only sets Release, so Debug would not assemble the files otherwise. legacy_stdio_definitions.lib is not needed, because the assembly never calls printf.
The full code and deliverables checklist are in ASUM SIMD Project — Setup, Code & Deliverables.
