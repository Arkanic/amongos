[bits 16]

%include "./programs/libsus.inc"

[org 32768]

start:
    call os_clear_screen
    
    mov dh, 1
    mov dl, 1
    call os_move_cursor

    mov si, msg
    call os_print_string

    mov dh, 3
    mov dl, 1
    call os_move_cursor

    mov si, msg2
    call os_print_string

    call os_wait_for_key

    ret

msg: db "impostor detected!", 0
msg2: db "sussy sus sus", 0