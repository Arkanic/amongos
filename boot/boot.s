[org 0x7c00]
KERNEL_OFFSET equ 0x1000

    mov [BOOT_DRIVE], dl
    mov bp, 0x9000
    mov sp, bp

    mov bx, MSG_REAL_MODE
    call print
    call print_nl

    call load_kernel
    call switch_to_pm
    jmp $

%include "boot/print.s"
%include "boot/print_hex.s"
%include "boot/disk.s"
%include "boot/gdt.s"
%include "boot/32b_print.s"
%include "boot/switch_pm.s"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print
    call print_nl

    mov bx, KERNEL_OFFSET
    mov dh, 32
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET
    jmp $


BOOT_DRIVE db 0
MSG_REAL_MODE db "Started 16bit real mode", 0
MSG_PROT_MODE db "Started 32bit protected mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory...", 0

times 510 - ($ - $$) db 0
dw 0xaa55