#include "timer.h"
#include "../drivers/screen.h"
#include "ports.h"
#include "isr.h"
#include "../libc/function.h"

u32 tick = 0;

static void timer_callback(registers_t regs) {
    tick++;
    UNUSED(regs);
}

void init_timer(u32 freq) {
    register_interrupt_handler(IRQ0, timer_callback);

    u32 divisor = 1193180 / freq;
    u8 low = (u8)(divisor & 0xff);
    u8 high = (u8)((divisor >> 8) & 0xff);

    port_byte_out(0x43, 0x36);
    port_byte_out(0x40, low);
    port_byte_out(0x40, high);
}

u32 get_ticks(void) {
    return tick;
}