SFLAGS=-O0 -w+orphan-labels

qemu: among.flp
	qemu-system-i386 -fda among.flp -nographic

among.flp: system/boot/boot.bin system/among.bin
	rm among.flp || true
	mkdosfs -C among.flp 1440

	dd conv=notrunc status=noxfer if=system/boot/boot.bin of=among.flp
	mcopy -i among.flp system/among.bin ::

%.bin: %.s
	nasm ${SFLAGS} $< -f bin -o $@

clean:
	rm *.flp system/*.bin system/boot/*.bin || true