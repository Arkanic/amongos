SFLAGS=-O0 -w+orphan-labels

PROG_DIR:=./programs
PROG_SRC_FILES:=$(wildcard $(PROG_DIR)/*.s)
PROG_BIN_FILES:=$(patsubst $(PROG_DIR)/%.s,$(PROG_DIR)/%.bin,$(PROG_SRC_FILES))

LOOSE_DIR:=./loose
LOOSE_FILES:=$(wildcard $(LOOSE_DIR)/*.*)

all: clean qemu

qemu: among.iso
	qemu-system-i386 -cdrom among.iso -nographic

among.iso: .tmp
	mkisofs -quiet -V "AMONGOS" -input-charset iso8859-1 -o among.iso -b among.flp .

.tmp: among.flp $(PROG_BIN_FILES)
	touch .tmp

	mcopy -i among.flp loose/*.* ::

among.flp: system/boot/boot.bin system/among.bin
	rm among.flp || true
	mkdosfs -C among.flp 1440

	dd conv=notrunc status=noxfer if=system/boot/boot.bin of=among.flp
	mcopy -i among.flp system/among.bin ::

system/%.bin: system/%.s
	nasm ${SFLAGS} $< -f bin -o $@

$(PROG_DIR)/%.bin: $(PROG_DIR)/%.s
	nasm ${SFLAGS} $< -f bin -o $@

	mcopy -i among.flp $@ ::

clean:
	rm .tmp *.flp *.iso system/*.bin system/boot/*.bin programs/*.bin || true