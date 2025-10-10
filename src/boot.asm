; Base Address to Higher Half Kernel
%define BASE_ADDRESS 0xC0000000        

; Consts for the multiboot header
%define MAGIC 0x1BADB002
MBALIGN  equ  1 << 0            
MEMINFO  equ  1 << 1            
MBFLAGS  equ  MBALIGN | MEMINFO 
CHECKSUM equ -(MAGIC + MBFLAGS) 
                                
section .multiboot
align 4
	dd MAGIC
	dd MBFLAGS
	dd CHECKSUM

section .bss
align 16

stack_bottom:
	resb 16384 ; 16 kib stack

stack_top:

section .text
global _start

_start:
	; Insert initial page_directory address for these registers
	mov esi, (page_directory - BASE_ADDRESS)
	mov ecx, esi
	mov edx, esi

	; Set page directory to page_directory + 4092
	or ecx, 0x3
	mov [edx + 0xFFC], ecx
	mov cr3, esi

	; Allow 4MB pages
	mov ecx, cr4
	or ecx, 0x10
	mov cr4, ecx

	; Enable paging
	mov ecx, cr0
	or ecx, 0x80000000
	mov cr0, ecx

	call to_higher_half

to_higher_half:
	; Set Protected Mode Enable bit (1)
	mov ecx, cr0
	or cl, 1
	mov ecx, cr0

	; Setup stack and push multiboot things
	mov esp, stack_top
	push ebx
	push eax
	xor ebp, ebp

	extern kernel_main
	call kernel_main
	cli

.hang: 
	hlt
	jmp .hang


section .data
align 4096

global page_directory
page_directory:
	; First 3GB of Virtual Memory
	%assign i 0x83
	%rep 0x300
	dd i
	%assign i i + 0x00400000
	%endrep

	; Map first 4MB Page to Higher Half
	dd 0x83
	%assign i 0xC0400083
	%rep 0xFF
	dd i
	%assign i i + 0x00400000
	%endrep
