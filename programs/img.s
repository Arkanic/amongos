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
    mov dx, 0
    mov al, 0
.loop:
    call os_vga_pixel

    cmp cx, 16
    jne .loop_incx
    ; inc y
    mov cx, 0
    inc dx

.loop_incx:
    inc cx
    jmp .loop_cont

.loop_cont:
    inc al

    cmp dx, 16
    jge .end

    jmp .loop

.end:

    call os_wait_for_key
    call os_vga_disable

    ret