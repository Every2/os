BITS 16
ORG 0x7C00

%define CODE_SEG 1
%define SEG_DATA 2
start:
  cli ; Disable interrupts

  ; Set segments to 0
  xor ax, ax
  mov ds, ax 
  mov ss, ax
  mov es, ax

  ; start to enable a20 and use more memory
  .enable_a20:
    ; Start using keyboard interrupt to check if is possible enable a20
    ; Check: https://wiki.osdev.org/A20_Line#Keyboard_Controller 
    in   al, 0x64 ; Check if keyboard port is not busy
    test al, 0x2
    jnz .enable_a20

    mov al, 0xd1
    out 0x64, al

  ; In order to understand why use 0x60, check: https://stackoverflow.com/questions/21078932/why-test-port-0x64-in-a-bootloader-before-switching-into-protected-mode
  .enable_a20_data:
    in al, 0x64
    test al, 0x2
    jnz .enable_a20_data
    
    mov al, 0xdf
    out 0x60, al

   ; Switch from real mode to protected. Use a boostrap of GDT as xv6 (change in future, maybe)
   lgdt [gdt.pointer]
   mov eax, cr0
   or eax, 0x1
   jmp (CODE_SEG << 3):.enter_proc_mode

  BITS 32
  .enter_proc_mode:
    mov ax, (SEG_DATA << 3)
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov ax, 0
    mov fs, ax
    mov gs, ax
    mov esp, start
    call kmain

gdt:
  .NULL:
    dq 0x0
  .code:
  align 2
    dq 0x209A << (10 * 4)
    dq 0x92 << (10 * 4)
    dw 0
  .pointer:
    dw $ - gdt - 1
    dd gdt
