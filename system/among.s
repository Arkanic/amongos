[bits 16]

%DEFINE AMONGOS_VER '1.0'
%DEFINE AMONGOS_API_VER 16

disk_buffer equ 24576

os_call_vectors:
    jmp os_main ; 0

    jmp os_fatal_error ; 3
    jmp os_get_api_version ; 6
    jmp os_pause ; 9

    jmp os_get_file_list ; C
    jmp os_load_file ; F
    jmp os_write_file ; 12
    jmp os_file_exists ; 15
    jmp os_create_file ; 18
    jmp os_remove_file ; 1b
    jmp os_rename_file ; 1e
    jmp os_get_file_size ; 21

    jmp os_print_string ; 24
    jmp os_clear_screen ; 27
    jmp os_move_cursor ; 2a
    jmp os_get_cursor_pos ; 2d
    jmp os_print_horiz_line ; 30
    jmp os_show_cursor ; 33
    jmp os_hide_cursor ; 36
    jmp os_draw_block ; 39
    jmp os_file_selector ; 3c
    jmp os_list_dialog ; 3f
    jmp os_draw_background ; 42
    jmp os_print_newline ; 45
    jmp os_dump_registers ; 48
    jmp os_input_dialog ; 4b
    jmp os_dialog_box ; 4e
    jmp os_print_space ; 51
    jmp os_dump_string ; 54
    jmp os_print_digit ; 57
    jmp os_print_1hex ; 5a
    jmp os_print_2hex ; 5d
    jmp os_print_4hex ; 60
    jmp os_input_string ; 63

    jmp os_main ; 66 UNUSED1

    jmp os_string_length ; 69
    jmp os_string_reverse ; 6C
    jmp os_find_char_in_string ; 6F
    jmp os_string_charchange ; 72
    jmp os_string_uppercase ; 75
    jmp os_string_lowercase ; 78
    jmp os_string_copy ; 7b
    jmp os_string_truncate ; 7e
    jmp os_string_join ; 81
    jmp os_string_chomp ; 84
    jmp os_string_strip ; 87
    jmp os_string_compare ; 8a
    jmp os_string_strincmp ; 8d
    jmp os_string_parse ; 90
    jmp os_string_to_int ; 93
    jmp os_int_to_string ; 96
    jmp os_sint_to_string ; 99
    jmp os_long_int_to_string ; 9c
    jmp os_set_time_fmt ; 9f
    jmp os_get_time_string ; a2
    jmp os_set_date_fmt ; a5
    jmp os_get_date_string ; a8
    jmp os_string_tokenize ; ab

    jmp os_wait_for_key ; ae
    jmp os_check_for_key ; b1

    jmp os_seed_random ; b4
    jmp os_get_random ; b7
    jmp os_bcd_to_int ; ba
    jmp os_long_int_negate ; bd

    jmp os_port_byte_out ; c0
    jmp os_port_byte_in ; c3
    jmp os_serial_port_enable ; c6
    jmp os_send_via_serial ; c9
    jmp os_get_via_serial ; cc

    jmp os_speaker_tone ; cf
    jmp os_speaker_off ; d2

    jmp os_vga_enable ; d5
    jmp os_vga_disable ; d8
    jmp os_vga_pixel ; db
    jmp os_vga_rectangle ; de
    jmp os_vga_horiz_line ; e1
    jmp os_vga_background ; e4

nop
nop
nop

os_main:
    cli
    mov ax, 0
    mov ss, ax
    mov sp, 0xFFFF
    sti

    cld

    mov ax, 0x2000
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    cmp dl, 0
    je no_change
    mov [bootdev], dl
    push es
    mov ah, 8
    int 0x13
    pop es
    and cx, 0x3f
    mov [SecsPerTrack], cx
    movzx dx, dh
    add dx, 1
    mov [Sides], dx

no_change:
    mov ax, 0x1003
    mov bx, 0
    int 0x10

    call os_seed_random

    mov ax, autorun_bin_filename
    call os_file_exists
    jc no_autorun_bin

    mov cx, 32768
    call os_load_file
    jmp execute_bin_program

no_autorun_bin:
    jmp app_selector

    os_init_msg: db "Welcome to AmongOS", 0
    os_version_msg: db "Version ", AMONGOS_VER, 0

app_selector:
    call os_clear_screen

    mov ax, os_init_msg
    mov bx, os_version_msg
    mov cx, 10101111b
    call os_draw_background

    call os_file_selector

    jc app_selector

    mov si, ax
    mov di, kernel_filename
    call os_string_compare
    jc no_kernel_execute

    push si

    mov bx, si
    mov ax, si
    call os_string_length

    mov si, bx
    add si, ax

    dec si
    dec si
    dec si

    mov di, bin_ext
    mov cx, 3
    rep cmpsb
    jne not_bin_extension

    pop si

    mov ax, si
    mov cx, 32768
    call os_load_file

execute_bin_program:
    call os_clear_screen

    mov ax, 0
    mov bx, 0
    mov cx, 0
    mov dx, 0
    mov si, 0
    mov di, 0

    call 32768

    call os_clear_screen
    jmp app_selector

no_kernel_execute:
    mov ax, kernelne_1
    mov bx, kernelne_2
    mov cx, kernelne_3
    mov dx, 0
    call os_dialog_box

    jmp app_selector

not_bin_extension:
    pop si

    mov ax, ext_1
    mov bx, ext_2
    mov cx, 0
    mov dx, 0
    call os_dialog_box

    jmp app_selector

    kernel_filename: db "AMONG.BIN", 0

    autorun_bin_filename: db "AUTORUN.BIN", 0

    bin_ext: db "BIN"

    kernelne_1: db "Cant run kernel", 0
    kernelne_2: db "In the kernel", 0
    kernelne_3: db "Dummy", 0

    ext_1: db "Invalid filename!", 0
    ext_2: db "Only .BIN files can be run!", 0

fmt_12_24: db 0
fmt_date: db 0, '/'

%include "./system/features/screen.s"
%include "./system/features/disk.s"
%include "./system/features/keyboard.s"
%include "./system/features/math.s"
%include "./system/features/misc.s"
%include "./system/features/string.s"
%include "./system/features/ports.s"
%include "./system/features/sound.s"
%include "./system/features/vga.s"