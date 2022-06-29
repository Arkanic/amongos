global _start

[bits 32]
[extern kernel_main]
_start:
call kernel_main
jmp $