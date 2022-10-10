[bits 16]
%include "./programs/libsus.inc"
[org 32768]

bmp_start equ 36864

start:
    mov ax, title_msg
	mov bx, footer_msg
	mov cx, BLACK_ON_WHITE
	call os_draw_background

	call os_file_selector
	jc near close

	mov bx, ax
	mov di, ax

	call os_string_length
	add di, ax

	dec di
	dec di
	dec di

	mov si, bmp_extension
	mov cx, 3
	rep cmpsb
	je near valid_extension

	jmp start

valid_extension:
	call os_clear_screen

	mov ax, bx
	mov cx, 36864 ; 4k after program start
	call os_load_file

	mov al, [bmp_start + 0xa]
	mov ah, [bmp_start + 0xb]
	mov [data_offset], ax

	mov al, [bmp_start + 0x12]
	mov ah, [bmp_start + 0x13]
	mov [img_width], ax

	mov al, [bmp_start + 0x16]
	mov ah, [bmp_start + 0x17]
	mov [img_height], ax

	call os_vga_enable

	mov ax, 0
	mov [counter], ax

.loop:
	mov dx, [counter]
	call draw_row

	mov ax, [counter]
	cmp ax, [img_height]
	ja .end

	inc ax
	mov [counter], ax

	jmp .loop

.end:
	call os_wait_for_key
	call os_vga_disable
	jmp close

close:
	call os_clear_screen
	ret

counter: dw 0

; dx = y
draw_row:
	pusha

	mov ax, 0
	mov [.count], ax

.loop:
	mov cx, [.count]
	call draw_pixel

	mov ax, [.count]
	cmp ax, [img_width + 1]
	ja .end

	inc ax
	mov [.count], ax

	jmp .loop
.end:
	popa
	ret

.count: dw 0

; cx = x, dx = y
draw_pixel:
	pusha
	push dx
	push cx

	mov ax, [img_width]
	mul dx
	add ax, cx

	mov si, ax
	add si, bmp_start
	add si, [data_offset]

	mov ax, [si]

	pop cx
	pop dx
	call os_vga_pixel

	popa
	ret

data_offset: dw 0
img_width: dw 0
img_height: dw 0

title_msg: db "8B BMP viewer", 0
footer_msg: db " ", 0

bmp_extension: db "BMP", 0