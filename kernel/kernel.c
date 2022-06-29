#include "../cpu/isr.h"
#include "../drivers/screen.h"
#include "kernel.h"
#include "../libc/string.h"
#include "../libc/mem.h"

void main(void) {
    clrscr_c(0x08);

    isr_install();
    irq_install();

    clrscr();

    kprint("AMONG OS\n");
    kprint("type end to finish the suffering, page to do some funny memory things\n> ");
}

void user_input(char *input) {
    if(strcmp(input, "END") == 0) {
        kprint("among os got ejected!!!!! (sussy)\n");
        asm volatile("hlt");
    } else if(strcmp(input, "PAGE") == 0) {
        u32 phys_addr;
        u32 page = kmalloc(1000, 1, &phys_addr);
        char page_str[16] = "";
        hex_to_ascii(page, page_str);
        char phys_str[16] = "";
        hex_to_ascii(phys_addr, phys_str);
        
        kprint("page: ");
        kprint(page_str);
        kprint("\n");

        kprint("physical address: ");
        kprint(phys_str);
        kprint("\n");
    }
    kprint("You said: ");
    kprint(input);
    kprint("\n> ");
}