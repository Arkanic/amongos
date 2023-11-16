[bits 16]
%include "./programs/libsus.inc"
[org 16384]

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

    mov dh, 1
    mov dl, 1
    call os_move_cursor

    mov si, msg
    call os_print_string

    mov ah, 0x53
    mov al, 0x00
    xor bx, bx
    int 0x15
    jc apm_error

    ; disconnect from any existing apm
    mov ah, 0x53
    mov al, 0x04
    xor bx, bx
    int 0x15
    jc apm_error

    ; connect to real mode interface
    mov ah, 0x53
    mov al, 0x01 ; 16 bit real mode
    xor bx, bx
    int 0x15
    jc apm_error

    ; enable power management for all devices
    mov ah, 0x53
    mov al, 0x08
    mov bx, 0x0001
    mov cx, 0x0001
    int 0x15
    jc apm_error

    ; set power state to off
    mov ah, 0x53
    mov al, 0x07
    mov bx, 0x0001
    mov cx, 0x03 ; off
    int 0x15
    jc apm_error
forever_loop:
    cli
    hlt
    jmp $

apm_error:
    mov si, apm_error_msg
    call os_print_string

    jmp forever_loop

ask_1: db "OK to shutdown", 0
ask_2: db "amongos", 0
ask_3: db " ", 0

msg: db "sus", 0
apm_error_msg: db 10, "APM error", 10, 0