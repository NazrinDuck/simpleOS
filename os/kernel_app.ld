OUTPUT_ARCH(riscv)
ENTRY(_entry)
BASE_ADDRESS = 0x80200000;

SECTIONS
{
    . = BASE_ADDRESS;
    skernel = .;

    s_text = .;
    .text : {
        *(.text.entry)
        *(.text .text.*)
        . = ALIGN(0x1000);
        *(trampsec)
        . = ALIGN(0x1000);
    }

    . = ALIGN(4K);
    e_text = .;
    s_rodata = .;
    .rodata : {
        *(.rodata .rodata.*)
    }

    . = ALIGN(4K);
    e_rodata = .;
    s_data = .;
    .data : {
        *(.data)
        . = ALIGN(0x1000);
        *(.data.app0)
        . = ALIGN(0x1000);
        *(.data.app1)
        . = ALIGN(0x1000);
        *(.data.app2)
        . = ALIGN(0x1000);
        *(.data.app3)
        . = ALIGN(0x1000);
        *(.data.app4)
        . = ALIGN(0x1000);
        *(.data.app5)
        . = ALIGN(0x1000);
        *(.data.app6)
        . = ALIGN(0x1000);
        *(.data.app7)
        . = ALIGN(0x1000);
        *(.data.app8)
        . = ALIGN(0x1000);
        *(.data.app9)
        . = ALIGN(0x1000);
        *(.data.app10)
        . = ALIGN(0x1000);
        *(.data.app11)
        . = ALIGN(0x1000);
        *(.data.app12)
        . = ALIGN(0x1000);
        *(.data.app13)
        . = ALIGN(0x1000);
        *(.data.app14)
        . = ALIGN(0x1000);
        *(.data.app15)
        . = ALIGN(0x1000);
        *(.data.app16)
        . = ALIGN(0x1000);
        *(.data.app17)
        . = ALIGN(0x1000);
        *(.data.app18)
        . = ALIGN(0x1000);
        *(.data.app19)
        . = ALIGN(0x1000);
        *(.data.app20)
        . = ALIGN(0x1000);
        *(.data.app21)
        . = ALIGN(0x1000);
        *(.data.app22)
        . = ALIGN(0x1000);
        *(.data.app23)
        . = ALIGN(0x1000);
        *(.data.app24)
        . = ALIGN(0x1000);
        *(.data.app25)
        . = ALIGN(0x1000);
        *(.data.app26)
        . = ALIGN(0x1000);
        *(.data.app27)
        . = ALIGN(0x1000);
        *(.data.app28)
        . = ALIGN(0x1000);
        *(.data.app29)
        . = ALIGN(0x1000);
        *(.data.app30)
        . = ALIGN(0x1000);
        *(.data.app31)
        . = ALIGN(0x1000);
        *(.data.app32)
        . = ALIGN(0x1000);
        *(.data.app33)
        . = ALIGN(0x1000);
        *(.data.app34)
        . = ALIGN(0x1000);
        *(.data.app35)
        . = ALIGN(0x1000);
        *(.data.app36)
        . = ALIGN(0x1000);
        *(.data.app37)
        . = ALIGN(0x1000);
        *(.data.app38)

        . = ALIGN(0x1000);
        *(.data.*)
        *(.sdata .sdata.*)
    }
    
    . = ALIGN(4K);
    e_data = .;
    .bss : {
        *(.bss.stack)
        s_bss = .;
        *(.bss .bss.*)
        *(.sbss .sbss.*)
    }

    . = ALIGN(4K);
    e_bss = .;
    ekernel = .;

    /DISCARD/ : {
        *(.eh_frame)
    }
}
