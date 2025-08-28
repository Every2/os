ENTRY(_start);
. = 0x80000000;

SECTIONS {
    .text : ALIGN(4K) {
    	  *(.text);
    }
    .bss  : ALIGN(4K) {
    	  PROVIDE(bss_start = .);
	  *(.bss);
	  PROVIDE(_global_pointer = .);
	  PROVIDE(bss_end = .);
    }
    .rodata : ALIGN(4K) {
    	    *(.rodata);
    }
    .data : ALIGN(4K) {
    	  *(.data);
    }
}
