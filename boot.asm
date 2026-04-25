[bits 16]
[org 0x7c00]

start:
    mov [BOOT_DRIVE], dl
    mov bp, 0x9000
    mov sp, bp

    ; Load the C Kernel from disk
    mov bx, 0x1000     ; Destination address
    mov dh, 30         ; Number of sectors to read (C kernels are big)
    mov dl, [BOOT_DRIVE]
    call disk_load

    ; Switch to 32-bit Protected Mode (Required for C)
    cli                ; Clear interrupts
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp 0x08:init_pm   ; Far jump to flush pipeline

[bits 32]
init_pm:
    mov ax, 0x10
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    call 0x1000        ; JUMP TO YOUR C KERNEL
    jmp $

; --- GDT Setup ---
gdt_start:
    dq 0x0
gdt_code:
    dw 0xffff, 0x0
    db 0x0, 10011010b, 11001111b, 0x0
gdt_data:
    dw 0xffff, 0x0
    db 0x0, 10010010b, 11001111b, 0x0
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

disk_load:
    mov ah, 0x02
    mov al, dh
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    int 0x13
    ret

BOOT_DRIVE db 0
times 510-($-$$) db 0
dw 0xaa55
