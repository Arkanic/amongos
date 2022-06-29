#include "../cpu/isr.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../libc/string.h"

void main(void) {
    isr_install();
    irq_install();

    kprint("AMONG OS\n");
    kprint("type end to finish the suffering\n> ");
}

void user_input(char *input) {
    if(strcmp(input, "END") == 0) {
        kprint("among os got ejected!!!!! (sussy)\n");
        asm volatile("hlt");
    }
    kprint("You said: ");
    kprint(input);
    kprint("\n> ");
}