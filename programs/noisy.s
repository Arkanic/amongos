[bits 16]
%include "./programs/libsus.inc"
[org 32768]

start:
    call os_speaker_tone

    mov ax, 10
    call os_pause

    call os_speaker_off

    ret