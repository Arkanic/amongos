SFLAGS=-O0

PROG_DIR:=./programs
SRC_FILES:=$(wildcard $(PROG_DIR)/*.s)
BIN_FILES:=$(patsubst $(PROG_DIR)/%.s,$(PROG_DIR)/%.bin,$(SRC_FILES))

all: clean qemu

qemu: .tmp
	qemu-system-i386 -fda among.flp -nographic

.tmp: among.flp $(BIN_FILES)
	touch .tmp

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
	echo $(SRC_FILES)
	echo $(BIN_FILES)
	rm .tmp *.flp system/*.bin system/boot/*.bin programs/*.bin || true