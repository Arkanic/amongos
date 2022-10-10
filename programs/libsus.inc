os_main equ 0000h

%DEFINE BLACK_ON_WHITE 11110000b
%DEFINE WHITE_ON_BLACK 00001111b
%DEFINE WHITE_ON_LIGHT_RED 11001111b
%DEFINE WHITE_ON_GREEN 00101111b
%DEFINE RED_ON_LIGHT_GREEN 10100100b

%DEFINE KEY_UP 72
%DEFINE KEY_DOWN 80
%DEFINE KEY_LEFT 75
%DEFINE KEY_RIGHT 77

%DEFINE KEY_ESC 27
%DEFINE KEY_ENTER 13

os_fatal_error equ  0003h
os_get_api_version equ  0006h
os_pause equ  0009h

os_get_file_list equ  000Ch
os_load_file equ  000Fh
os_write_file equ  0012h
os_file_exists equ  0015h
os_create_file equ  0018h
os_remove_file equ  001bh
os_rename_file equ  001eh
os_get_file_size equ  0021h

os_print_string equ  0024h
os_clear_screen equ  0027h
os_move_cursor equ  002ah
os_get_cursor_pos equ  002dh
os_print_horiz_line equ  0030h
os_show_cursor equ  0033h
os_hide_cursor equ  0036h
os_draw_block equ  0039h
os_file_selector equ  003ch
os_list_dialog equ  003fh
os_draw_background equ  0042h
os_print_newline equ  0045h
os_dump_registers equ  0048h
os_input_dialog equ  004bh
os_dialog_box equ  004eh
os_print_space equ  0051h
os_dump_string equ  0054h
os_print_digit equ  0057h
os_print_1hex equ  005ah
os_print_2hex equ  005dh
os_print_4hex equ  0060h
os_input_string equ  0063h

UNUSED1 equ  0066h

os_string_length equ  0069h
os_string_reverse equ  006Ch
os_find_char_in_string equ  006Fh
os_string_charchange equ  0072h
os_string_uppercase equ  0075h
os_string_lowercase equ  0078h
os_string_copy equ  007bh
os_string_truncate equ  007eh
os_string_join equ  0081h
os_string_chomp equ  0084h
os_string_strip equ  0087h
os_string_compare equ  008ah
os_string_strincmp equ  008dh
os_string_parse equ  0090h
os_string_to_int equ  0093h
os_int_to_string equ  0096h
os_sint_to_string equ  0099h
os_long_int_to_string equ  009ch
os_set_time_fmt equ  009fh
os_get_time_string equ  00a2h
os_set_date_fmt equ  00a5h
os_get_date_string equ  00a8h
os_string_tokenize equ  00abh

os_wait_for_key equ  00aeh
os_check_for_key equ  00b1h

os_seed_random equ  00b4h
os_get_random equ  00b7h
os_bcd_to_int equ  00bah
os_long_int_negate equ  00bdh

os_port_byte_out equ  00c0h
os_port_byte_in equ  00c3h
os_serial_port_enable equ  00c6h
os_send_via_serial equ  00c9h
os_get_via_serial equ  00cch

os_speaker_tone equ  00cfh
os_speaker_off equ  00d2h

os_vga_enable equ  00d5h
os_vga_disable equ  00d8h
os_vga_pixel equ  00dbh
os_vga_rectangle equ  00deh
os_vga_horiz_line equ  00e1h