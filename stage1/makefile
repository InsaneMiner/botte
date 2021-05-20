

all: build-bootloader-stage1


main.asm-assemble:
	nasm -f elf32 main.asm -o main.asm.o

build-bootloader-stage1: main.asm-assemble
	gcc main.c main.asm.o -o bootloader.bin -Wall -O -pedantic -g -m32 -ffreestanding -fno-pie -fno-pic -fno-builtin -nostdlib -Wno-multichar -nostartfiles -T linker.ld
