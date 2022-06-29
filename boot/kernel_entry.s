.global _start

[bits 32]
[extern main]
_start:
call kernel_main
jmp $