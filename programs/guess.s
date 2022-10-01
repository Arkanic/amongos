[bits 16]
%include "./programs/libsus.inc"
[org 32768]

start:
    jmp new_game

new_game:
    call os_clear_screen
    call draw_background

    mov word [guesses], 0

    mov ax, 1
    mov bx, 100
    call os_get_random
    mov word [randomnum], cx

game_loop:
    call os_clear_screen
    call draw_background

    mov dx, 0
    mov ax, input_number_msg
    mov bx, 0
    mov cx, 0
    call os_dialog_box

    call os_clear_screen
    mov dh, 0
    mov dl, 1
    call os_move_cursor

    mov ax, numinput
    call os_input_string

    mov si, ax
    call os_string_to_int

    call draw_background

    mov word bx, [randomnum]
    cmp ax, bx
    je .win
    jle .small
    jge .high

.win:
    mov dx, 1
    mov ax, win_msg_1
    mov bx, win_msg_2
    mov cx, win_msg_3
    call os_dialog_box

    cmp ax, 0
    jne near quit

    jmp new_game

.small:
    mov dx, 0
    mov ax, small_msg
    mov bx, 0
    mov cx, 0
    call os_dialog_box

    jmp game_loop

.high:
    mov dx, 0
    mov ax, high_msg
    mov bx, 0
    mov cx, 0
    call os_dialog_box

    jmp game_loop

draw_background:
    pusha
    mov ax, title_msg
    mov bx, footer_msg
    mov cx, BLACK_ON_WHITE
    call os_draw_background
    popa
    ret

quit:
    ret

title_msg: db "Guessing game", 0
footer_msg: db "sus!", 0
input_number_msg: db "Please input your number", 0
win_msg_1: db "You win!!!", 0
win_msg_2: db "OK to play again,", 0
win_msg_3: db "Cancel to quit.", 0
small_msg: db "Number is too small!", 0
high_msg: db "Number is too high!", 0

guesses: dw 0
randomnum: dw 0
numinput: times 16 db 0