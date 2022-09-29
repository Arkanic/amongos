[bits 16]

%include "./programs/libsus.inc"

[org 32768]

start:
    call os_clear_screen

    mov bl, WHITE_ON_GREEN
    mov dl, 0
    mov dh, 0
    mov si, 80
    mov di, 25
    call os_draw_block


    call os_wait_for_key

    ret