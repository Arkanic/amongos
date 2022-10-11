[bits 16]
%include "./programs/libsus.inc"
[org 16384]

start:
    call os_clear_screen

    mov dh, 0
    mov dl, 0
    call os_move_cursor

    mov si, msg1
    call os_print_string

    mov dh, 0
    mov dl, 1

    mov si, msg2
    call os_print_string

    call os_wait_for_key

    ret

msg1: db "HI!!!!", 0
msg2: db "among us in real life confirmed????", 0