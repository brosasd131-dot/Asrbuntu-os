ENTRY(_start)                /* The symbol defined in your assembly entry */

SECTIONS
{
    . = 1M;                  /* GRUB loads kernels at the 1MB mark */

    .text : ALIGN(4K)
    {
        *(.multiboot)        /* Ensure header goes FIRST */
        *(.text)
    }

    .rodata : ALIGN(4K) { *(.rodata) }
    .data   : ALIGN(4K) { *(.data)   }
    .bss    : ALIGN(4K) { *(COMMON) *(.bss) }
}
