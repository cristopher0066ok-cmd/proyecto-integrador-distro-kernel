# Part 2 — Build a 64-bit Kernel from Scratch

> **Integrative Project — UIDE · March–July 2026**
> Instructor: Ing. Jonathan E. Tito O., MSc.

## Overview

This part demonstrates building a minimal bootable kernel from scratch using Assembly and C, compiled in a reproducible environment and tested with QEMU. The kernel writes directly to video memory (`0xB8000`) without relying on any operating system.

## Project Structure## Build Instructions

Install dependencies:

```bash
sudo apt install nasm gcc gcc-multilib grub-pc-bin grub-common xorriso qemu-system-x86 -y
```

One-line build:

```bash
./build.sh
```

## Running in QEMU

```bash
qemu-system-i386 -cdrom dist/kernel.iso -m 512 -boot d -net none -no-reboot
```

## Expected Output

Upon boot, QEMU displays:No operating system. No libraries. Just bare metal code talking directly to the hardware.

## How It Works

### boot.asm — Multiboot Header
Tells GRUB this binary is a valid kernel, sets up the stack and calls `kernel_main` in C.

### kernel.c — Writing to Video Memory
Writes directly to VGA text buffer at `0xB8000`. Each character = 2 bytes (ASCII + color attribute).

### linker.ld — Memory Layout
Places the kernel at physical address `0x100000` (1 MB), safely above the BIOS region.

## Criteria Checklist

| Criterion | Status |
|---|---|
| Reproducible build environment (NASM/GRUB/GCC) | ✅ |
| Multiboot header + boot prints message in QEMU | ✅ |
| Kernel written in C printing custom group text | ✅ |
| Bootable `kernel.iso` generated with `grub-mkrescue` | ✅ |
| Boot demonstrated in QEMU | ✅ |

## Team

| Member | Role |
|---|---|
| Cristopher Quisilema | Kernel development, build system, QEMU testing |

## References

- [Write Your Own 64-bit OS Kernel #1](https://www.youtube.com/watch?v=FkrpUaGThTQ)
- [Write Your Own 64-bit OS Kernel #2](https://www.youtube.com/watch?v=wz9CZBeXR6U)
- [OSDev Wiki — Bare Bones](https://wiki.osdev.org/Bare_Bones)
