[bits 16]

%include "./programs/libsus.inc"

[org 32768]

start:
    call os_clear_screen

    call os_wait_for_key

    ret