[bits 16]
%include "./programs/libsus.inc"
[org 16384]

start:
    call os_vga_enable
    
    mov al, 0x09
    call os_vga_background

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

    mov cx, 100
    mov dx, 190
    mov al, 4
    call os_vga_pixel

    mov cx, 0
    mov dx, 150
    mov al, 0
.loop:
    call os_vga_pixel

    inc cx
    inc al

    cmp cx, 255
    jge .end

    jmp .loop

.end:

    call os_wait_for_key
    call os_vga_disable

    ret