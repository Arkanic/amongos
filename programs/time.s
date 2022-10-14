[bits 16]
%include "./programs/libsus.inc"
[org 16384]


start:
    pusha

    call os_clear_screen

    mov ax, title
    mov bx, footer
    mov cx, 00100000b
    call os_draw_background

    call os_get_date_string
    mov ax, bx

    call os_get_time_string
    
    mov cx, 0
    mov dx, 0

    call os_dialog_box

    popa
    ret

title: db "Time", 0
footer: db " ", 0