.option norvc
.section .data

.section .text
.global _start
_start:
   csrr t0, mhartid
   bnez t0, p_harts
   # satp = 0
   csrw satp, zero

.option push
.option norelax
   la gp, global_pointer
.option pop
   la a0, _bss_start
   la a1, _bss_end
   # Using function/return value registers because c function `Kmain`
   bgeu a0, a1, set_control
bss_clear:
   sd zero, (a0)
   addi a0, a0, 8
   bltu a0, a1, bss_clear
set_control:
   la sp, _stack
   
   # Machine Status Register, mstatus
   # 3 << 11 previous mode
   # 1 << 7 Machine mode entry
   # 1 << 3 Machine interrupt
   li t0, (3 << 11) | (1 << 7) | (1 << 3)
   csrw mstatus, t0
   # PC Interruptions to kmain
   la t1, kmain
   csrw mepc, t1
   # in future when enable traps using base address
   la t2, h_trap
   csrw mtvec, t2

   # Re enable interrupts
   # 1 << 3 Enable software interrupt
   # 1 << 7 Machine time
   # 1 << 11 << External interrupt
   li t3, (1 << 3) | (1 << 7) | (1 << 11)
   csrw mie, t3
   
   # infinite loop waiting for interrupts
   la ra, interrupts
   
   # Update mret
   mret

p_harts:

interrupts:
   wfi
   j  end
