#!/bin/bash
set -e

echo "==> Compilando boot.asm..."
nasm -f elf32 src/boot.asm -o dist/boot.o

echo "==> Compilando kernel.c..."
gcc -m32 -c src/kernel.c -o dist/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

echo "==> Enlazando..."
ld -m elf_i386 -T src/linker.ld -o dist/my_kernel.bin dist/boot.o dist/kernel.o

echo "==> Preparando ISO..."
cp dist/my_kernel.bin isofiles/boot/
grub-mkrescue -o dist/kernel.iso isofiles

echo "==> Listo: dist/kernel.iso"
