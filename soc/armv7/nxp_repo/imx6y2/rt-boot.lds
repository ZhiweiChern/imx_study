
/* Memory region from [0x80000000-0x80001FFF] is reserved for ROM code */

/* Entry Point */
ENTRY(Reset_Handler)


RSTACK_SIZE = DEFINED(__resume_stack_size__)   ? __resume_stack_size__  : 0x0400;

/* Specify the memory areas */
MEMORY
{
    m_ocram     (RWX)  : ORIGIN = 0x00900000, LENGTH = 0x00020000
    m_ddr       (RWX)  : ORIGIN = 0x80000000, LENGTH = 0x20000000
}

SECTIONS{
    . = 0X87800000;
    _TEXT_START = .;

    /* The program code and other data goes into DDR RAM */
    .text (_TEXT_START): AT(_TEXT_START)
    {
        . = ALIGN(4);
        __VECTOR_TABLE = .;
        CPUDIR/start.o
        *(.text)                 /* .text sections (code) */
        *(.text*)                /* .text* sections (code) */
        *(.rodata)               /* .rodata sections (constants, strings, etc.) */
        *(.rodata*)              /* .rodata* sections (constants, strings, etc.) */
        *(.glue_7)               /* glue arm to thumb code */
        *(.glue_7t)              /* glue thumb to arm code */
        *(.eh_frame)
        KEEP (*(.init))
        KEEP (*(.fini))
        . = ALIGN(4);
    } > m_ddr

    .ARM.extab :
    {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } > m_ddr

    .ARM :
    {
        __exidx_start = .;
        *(.ARM.exidx*)
        __exidx_end = .;
    } > m_ddr
    _TEXT_END = .;    /* define a global symbol at end of code */

    .data :
    {
        . = ALIGN(4);
        __data_start__ = .;           /* create a global symbol at data start */
        *(.data)                      /* .data sections */
        *(.data*)                     /* .data* sections */
        __data_end__ = .;             /* define a global symbol at data end */
        . = ALIGN(4);
    } > m_ddr

    /* Uninitialized data section */
    .bss :
    {
        /* This is used by the startup in order to initialize the .bss section */
        . = ALIGN(4);
        __bss_start__ = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end__ = .;
    } > m_ddr

    .ocram_data :
    {
        . = ALIGN(4);
        __ocram_data_start__ = .;
        *(.ocram_data)
        *(.ocram_text)
        . = ALIGN(4);
        __ocram_data_end__ = .;
    } > m_ocram

    /* Initializes stack on the end of block */
    __RStackTop         = ORIGIN(m_ocram) + LENGTH(m_ocram);
    __RStackLimit       = __RStackTop - RSTACK_SIZE;

}
