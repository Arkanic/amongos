os_wait_for_key:
    pusha

    mov ax, 0
    mov ah, 0x10
    int 0x16

    mov [.tmp_buf], ax

    popa
    mov ax, [.tmp_buf]
    ret

    .tmp_buf: dw 0

os_check_for_key:
    pusha

    mov ax, 0
    mov ah, 1
    int 0x16

    jz .nokey

    mov ax, 0
    int 0x16

    mov [.tmp_buf], ax

    popa
    mov ax, [.tmp_buf]
    ret

.nokey
    popa
    mov ax, 0
    ret

    .tmp_buf: dw 0