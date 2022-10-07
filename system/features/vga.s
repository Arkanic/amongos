; arkanic addon to mikeos kernel libraries
; generic canvas paint-like commands for VGA 320x200 graphics


; turn on vga mode
; IN/OUT: ax = 0 for success, 1 = vga already on
os_vga_enable:
    pusha

    cmp word [vga_on], 0
    jne .fail

    mov ah, 0
    mov al, 0x13
    int 0x10

    jmp .success

.fail:
    popa
    mov ax, 1
    jmp .end
.success:
    mov word [vga_on], 1

    popa

    mov ax, 0

.end:
    ret

; turn off vga mode
; IN/OUT: ax = 0 for success, 1 = vga already off
os_vga_disable:
    pusha

    cmp word [vga_on], 1
    jne .fail

    mov ax, 3
    mov bx, 0
    int 0x10
    mov ax, 0x1003
    int 0x10

    jmp .success

.fail:
    popa
    mov ax, 1
    jmp .end
.success:
    mov word [vga_on], 0
    popa
    mov ax, 0
.end:
    ret

vga_on: db 0

; draw pixel
; IN=ax = x, bx = y, dl = colour
os_vga_pixel:
    pusha

    mov cx, 0xA000
    mov es, cx

    mov cx, 320
    mul cx
    add ax, bx

    mov di, ax
    mov dl, 7
    mov [es:di], dl

    mov ax, 0x2000
    mov es, ax

    popa
    ret