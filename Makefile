C_SOURCES=$(wildcard kernel/*.c drivers/*.c cpu/*.c)
HEADERS=$(wildcard kernel/*.h drivers/*.h cpu/*.h)

OBJ=${C_SOURCES:.c=.o cpu/interrupt.o}

CC=/usr/local/i386elfgcc/bin/i386-elf-gcc
LD=/usr/local/i386elfgcc/bin/i386-elf-ld
GDB=/usr/local/i386elfgcc/bin/i386-elf-gdb

CFLAGS=-g

os.bin: boot/boot.bin kernel.bin
	cat $^ > os.bin

kernel.bin: boot/kernel_entry.o ${OBJ}
	${LD} -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: boot/kernel_entry.o ${OBJ}
	${LD} -o $@ -Ttext 0x1000 $^

run: os.bin
	qemu-system-i386 -fda os.bin

debug: os.bin kernel.elf
	qemu-system-i386 -s -fda os.bin &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

%.o: %.c ${HEADERS}
	${CC} ${CFLAGS} -ffreestanding -c $< -o $@

%.o: %.s
	nasm $< -f elf -o $@

%.bin: %.s
	nasm $< -f bin -o $@

clean:
	rm -rf *.bin *.dis *.o os.bin *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o cpu/*.o