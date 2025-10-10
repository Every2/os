ENTRY(_start)
SECTIONS
{
	/* The Kernel live at 3GB + 1MB in the virtual address space */
	/* Wiil be mapped to 1MB in the physical address space*/
	base_address = 0xC0000000;
	. = 1M + base_address;

 	kernel_virt_start = .;
 	kernel_phys_start = kernel_virt_start - base_address;

	.text ALIGN(4K) : AT(ADDR(.text) - base_address)
	{
		*(.multiboot)
		*(.text)
	}

	/* align read-only data */
	.rodata ALIGN(4K) : AT(ADDR(.rodata) - base_address)
	{
		*(.rodata)
	}
	
	.data ALIGN(4K) : AT(ADDR(.data) - base_address)
	{
		*(.data)
	}

	.bss ALIGN(4K) : AT(ADDR(.bss) - base_address)
	{
		*(COMMON)
		*(.bss)
	}

	/* Add symbols that indicate the end*/
	kernel_virt_end = .;
	kernel_phys_end = kernel_virt_end - base_address;
}
