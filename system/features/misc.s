; current api version
os_get_api_version:
    mov al, AMONGOS_VER
    ret

os_pause:
    pusha
    cmp ax, 0
    je .time_up

    mov cx, 0
    mov [.counter_var], cx

    mov bx, ax
    mov ax, 0
    mov al, 2
    mul bx
    mov [.orig_req_delay], ax

    mov ah, 0
    int 0x1a

    mov [.prev_tick_count], dx

.checkloop:
    mov ah, 0
    int 0x1a

    cmp [.prev_tick_count], dx

    jne .up_date
    jmp .checkloop

.time_up:
    popa
    ret

.up_date:
    mov ax, [.counter_var]
    inc ax
    mov [.counter_var], ax

    cmp ax, [.orig_req_delay]
    jge .time_up

    mov [.prev_tick_count], dx

    jmp .checkloop

    .orig_req_delay: dw 0
    .counter_var: dw 0
    .prev_tick_count: dw 0

; fatal error
os_fatal_error:
    jmp $