CC = i686-elf-gcc
ASSEMBLER = nasm
SOURCE_DIR= src
STD_FLAG = -std=gnu11
CFLAGS= -ffreestanding -O2 -Wall -Wextra
LINKER_FLAGS = -ffreestanding -O2 -nostdlib
BUILD_DIR= bin

all: build.os

build.os: $(BUILD_DIR) build.boot build.kernel linker.ld
	$(CC) -T linker.ld -o $(BUILD_DIR)/os.bin $(LINKER_FLAGS) $(BUILD_DIR)/boot.o $(BUILD_DIR)/kernel.o -lgcc

build.boot: $(BUILD_DIR)/ $(SOURCE_DIR)/boot.asm
	$(ASSEMBLER) -felf32 $(SOURCE_DIR)/boot.asm -o $(BUILD_DIR)/boot.o

build.kernel: $(BUILD_DIR)/ $(SOURCE_DIR)/kernel.c
	$(CC) -c $(SOURCE_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o $(STD_FLAG) $(CFLAGS)

bin:
	mkdir $(BUILD_DIR)

run: all
	qemu-system-i386 -kernel bin/os.bin

.PHONY: clean
clean:
	rm -rf bin
