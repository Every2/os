NAME = boot
START = start
TRAP = trap

boot.bin: bootloader/$(START).asm bootloader/$(TRAP).asm
	riscv64-unknown-elf-as bootloader/$(START).asm bootloader/$(TRAP).asm -o bin/$(START)
	riscv64-unknown-elf-ld -T$(bin/start) -o bin/boot

bin/:
	mkdir bin

run: 	bin/$(name)
	qemu-system-riscv64 -machine virt -cpu rv64 -smp 1 -nographic

.PHONY: clean
clean:
	rm -rf bin
