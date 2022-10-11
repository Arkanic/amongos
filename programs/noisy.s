[bits 16]
%include "./programs/libsus.inc"
[org 16384]

start:
    call os_speaker_tone

    call os_wait_for_key

    call os_speaker_off

    ret