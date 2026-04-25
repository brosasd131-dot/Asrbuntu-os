#!/bin/bash

echo "[1/6] Assembling Entry..."
nasm -f elf32 kernel_entry.asm -o entry.o

echo "[2/6] Compiling C Kernel..."
clang -target i386-pc-none-elf -ffreestanding -m32 -c kernel.c -o kernel.o

echo "[3/6] Linking Binaries..."
ld.lld -m elf_i386 -o kernel.bin -Ttext 0x1000 --image-base 0x1000 entry.o kernel.o --oformat binary

echo "[4/6] Assembling Bootloader..."
nasm -f bin boot.asm -o boot.bin

echo "[5/6] Fusing into Image..."
cat boot.bin kernel.bin > asrbuntu.img

echo "[6/6] Padding to 1.44MB..."
truncate -s 1440k asrbuntu.img

echo "Done! Load asrbuntu.img into Limbo."

