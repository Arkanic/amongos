; arkanic addon to mikeos kernel libraries
; generic canvas paint-like commands for VGA 320x200 graphics

; turn on vga mode
os_vga_enable:
    pusha

    mov ah, 00h
    mov al, 13h

    int 0x10

    popa
    ret

; turn off vga mode
os_vga_disable:
    pusha

    mov ax, 3
    mov bx, 0
    int 0x10
    mov ax, 0x1003
    int 0x10

    popa
    ret

; draw pixel
; IN=cx = x, dx = y, al = colour
os_vga_pixel:
    pusha

    mov ah, 0ch
    mov bh, 0

    int 10h

    popa
    ret

; draw line at y axis
; IN: bx = x start, cx = x end, dx = y axis al = colour
os_vga_horiz_line:
    pusha

.loop:
    pusha
    mov cx, bx
    call os_vga_pixel
    popa

    inc bx
    cmp bx, cx
    jge .over

    jmp .loop

.over:
    popa
    ret

; draw rectangle
; IN: cx, bh = x y start; dx, bl = x y end, al = colour
os_vga_rectangle:
    pusha

.loop:
    pusha
    push ax
    mov ax, dx
    mov dh, 0
    mov dl, bh
    mov bx, cx
    mov cx, ax
    pop ax
    call os_vga_horiz_line
    popa

    inc bh
    cmp bh, bl
    ja .end

    jmp .loop

.end:
    popa
    ret

; draw a solid colour background
; IN: al = colour
os_vga_background:
    pusha

    mov cx, 0
    mov bh, 0
    mov dx, 320
    mov bl, 200
    call os_vga_rectangle

    popa
    ret