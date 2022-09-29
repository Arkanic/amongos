[bits 16]
%include "./programs/libsus.inc"
[org 32768]


main_start:
	call draw_background

	call os_file_selector

	jc near close

	mov bx, ax

	mov di, ax

	call os_string_length
	add di, ax

	dec di
	dec di
	dec di

	mov si, txt_extension
	mov cx, 3
	rep cmpsb
	je near valid_txt_extension

	dec di

	mov si, pcx_extension
	mov cx, 3
	rep cmpsb
	je valid_pcx_extension

	mov dx, 0
	mov ax, err_string
	mov bx, 0
	mov cx, 0
	call os_dialog_box

	jmp main_start


valid_pcx_extension:
	mov ax, bx
	mov cx, 36864
	call os_load_file

	mov ah, 0
	mov al, 0x13
	int 0x10


	mov ax, 0A000h
	mov es, ax

	mov si, 36864 + 0x80

	mov di, 0

decode:
	mov cx, 1
	lodsb
	cmp al, 192
	jb single
	and al, 63
	mov cl, al
	lodsb
single:
	rep stosb
	cmp di, 64001
	jb decode

	mov dx, 0x3c8
	mov al, 0
	out dx, al
	inc dx

	mov cx, 768
setpal:
	lodsb
	shr al, 2
	out dx, al
	loop setpal


	call os_wait_for_key

	mov ax, 3
	mov bx, 0
	int 0x10
	mov ax, 0x1003
	int 0x10

	mov ax, 0x2000
	mov es, ax
	call os_clear_screen
	jmp main_start

draw_background:
	mov ax, title_msg
	mov bx, footer_msg
	mov cx, BLACK_ON_WHITE
	call os_draw_background
	ret

valid_txt_extension:
	mov ax, bx
	mov cx, 36864
	call os_load_file

	add bx, 36864


	mov cx, 0
	mov word [skiplines], 0


	pusha
	mov ax, txt_title_msg
	mov bx, txt_footer_msg
	mov cx, 11110000b
	call os_draw_background
	popa



txt_start:
	pusha

	mov bl, 11110000b
	mov dh, 2
	mov dl, 0
	mov si, 80
	mov di, 23
	call os_draw_block

	mov dh, 2
	mov dl, 0
	call os_move_cursor

	popa

	mov si, 36864
	mov ah, 0Eh

redraw:
	cmp cx, 0
	je loopy
	dec cx

skip_loop:
	lodsb
	cmp al, 10
	jne skip_loop
	jmp redraw


loopy:
	lodsb

	cmp al, 10
	jne skip_return
	call os_get_cursor_pos
	mov dl, 0
	call os_move_cursor

skip_return:
	int 10h

	cmp si, bx
	je finished

	call os_get_cursor_pos
	cmp dh, 23
	je get_input

	jmp loopy


get_input:
	call os_wait_for_key
	cmp ah, KEY_UP
	je go_up
	cmp ah, KEY_DOWN
	je go_down
	cmp al, 'q'
	je main_start
	cmp al, 'Q'
	je main_start
	jmp get_input


go_up:
	cmp word [skiplines], 0
	jle txt_start
	dec word [skiplines]
	mov word cx, [skiplines]
	jmp txt_start

go_down:
	inc word [skiplines]
	mov word cx, [skiplines]
	jmp txt_start


finished:
	call os_wait_for_key
	cmp ah, 0x48
	je go_up
	cmp al, 'q'
	je main_start
	cmp al, 'Q'
	je main_start
	jmp finished


close:
	call os_clear_screen
	ret

txt_extension: db "TXT", 0
pcx_extension: db "PCX", 0

err_string: db "File type not supported!", 0

title_msg: db "Crewmate File Viewer", 0
footer_msg: db "esc = exit, scroll = up/down", 0

txt_title_msg: db "Crewmate Text submodule", 0
txt_footer_msg: db "Use arrow keys to scroll and Q to quit", 0

skiplines: dw 0