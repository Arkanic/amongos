[bits 16]

%include "./programs/libsus.inc"

[org 32768]

start:
    call os_clear_screen

    mov si, msg
    call os_print_string

    call os_wait_for_key

    ret

msg: db "impostor detected!", 13, 10, 0