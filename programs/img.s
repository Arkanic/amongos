[bits 16]
%include "./programs/libsus.inc"
[org 32768]

start:
    call os_vga_enable

    mov cx, 10
    mov dx, 5
    mov al, 4
    call os_vga_pixel

    mov bx, 100
    mov cx, 150
    mov dx, 50
    mov al, 4
    call os_vga_horiz_line

    mov cx, 200
    mov bh, 0
    mov dx, 300
    mov bl, 180
    mov al, 4
    call os_vga_rectangle

    call os_wait_for_key
    call os_vga_disable

    ret