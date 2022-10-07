[bits 16]
%include "./programs/libsus.inc"
[org 32768]

start:
    call os_vga_enable

    mov ax, 100
    mov bx, 50
    mov dl, 6
    call os_vga_pixel

    call os_wait_for_key
    call os_vga_disable

    ret