[bits 16]
%include "./programs/libsus.inc"
[org 32768]

start:
    mov ax, ask_1
    mov bx, ask_2,
    mov cx, ask_3
    mov dx, 1
    call os_dialog_box

    cmp ax, 1
    jne near shutdown

    ret

shutdown:
    call os_clear_screen
    cli
    hlt
    jmp $

ask_1: db "OK to shutdown", 0
ask_2: db "amongos", 0
ask_3: db " ", 0