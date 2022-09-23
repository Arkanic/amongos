[bits 16]

jmp short START
nop

OEMLabel db "SUS BOOT"
BytesPerSector dw 512
SectorsPerCluster db 1
ReservedForBoot dw 1
NumberOfFats db 2
RootDirEntries dw 224

LogicalSectors dw 2880
MediumByte db 0xF0
SectorsPerFat dw 9
SectorsPerTrack dw 18
Sides dw 2
HiddenSectors dd 0
LargeSectors dd 0
DriveNo dw 0
Signature db 41
VolumeId dd 0x00000000
VolumeLabel db "AMONGOS    "
FileSystem db "FAT12   "

START:
    mov ax, 0x7c0
    add ax, 544
    cli
    mov ss, ax
    mov sp, 4096
    sti

    mov ax, 0x7c0
    mov ds, ax

    cmp dl, 0
    je no_change
    mov [bootdev], dl
    mov ah, 8
    int 0x13
    jc fatal_disk_error
    and cx, 0x3f
    mov [SectorsPerTrack], cx
    movzx dx, dh
    add dx, 1
    mov [Sides], dx

no_change:
    mov eax, 0

floppy_ok:
    mov ax, 19
    call l2hts

    mov si, buffer
    mov bx, ds
    mov es, bx
    mov bx, si

    mov ah, 2
    mov al, 14

    pusha

read_root_dir:
    popa
    pusha

    stc
    int 0x13

    jnc search_dir
    call reset_floppy
    jnc read_root_dir

    jmp reboot

search_dir:
    popa

    mov ax, ds
    mov di, buffer

    mov cx, word [RootDirEntries]
    mov ax, 0

next_root_entry:
    xchg cx, dx

    mov si, kernel_filename
    mov cx, 11
    rep cmpsb
    je found_file_to_load

    add ax, 32
    mov di, buffer
    add di, ax

    xchg dx, cx
    loop next_root_entry

    mov si, file_not_found
    call print_string
    jmp reboot

found_file_to_load:
    mov ax, word [es:di+0xf]
    mov word [cluster], ax

    mov ax, 1
    call l2hts

    mov di, buffer
    mov bx, di

    mov ah, 2
    mov al, 9

    pusha

read_fat:
    popa
    pusha

    stc
    int 0x13

    jnc read_fat_ok
    call reset_floppy
    jnc read_fat

fatal_disk_error:
    mov si, disk_error
    call print_string
    jmp reboot

read_fat_ok:
    popa
    
    mov ax, 0x2000
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, 1

    push ax

load_file_sector:
    mov ax, word [cluster]
    add ax, 31

    call l2hts

    mov ax, 0x2000
    mov es, ax
    mov bx, word [pointer]

    pop ax
    push ax

    stc
    int 0x13

    jnc calculate_next_cluster
    call reset_floppy
    jmp load_file_sector

calculate_next_cluster:
    mov ax, [cluster]
    mov dx, 0
    mov bx, 3
    mul bx
    mov bx, 2
    div bx
    mov si, buffer
    add si, ax
    mov ax, word [ds:si]

    or dx, dx

    jz even

odd:
    shr ax, 4
    jmp short next_cluster_cont

even:
    and ax, 0xfff

next_cluster_cont:
    mov word [cluster], ax

    cmp ax, 0xff8
    jae end

    add word [pointer], 512
    jmp load_file_sector

end:
    pop ax
    mov dl, byte [bootdev]

    jmp 0x2000:0x0000

reboot:
    mov ax, 0
    int 0x16
    mov ax, 0
    int 0x19

print_string:
    pusha

    mov ah, 0x0e

.repeat:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp short .repeat

.done:
    popa
    ret

reset_floppy:
    push ax
    push dx
    mov ax, 0
    mov dl, byte [bootdev]
    stc
    int 0x13
    pop dx
    pop ax
    ret

l2hts:
    push bx
    push ax

    mov bx, ax

    mov dx, 0
    div word [SectorsPerTrack]
    add dl, 0x01
    mov cl, dl
    mov ax, bx

    mov dx, 0
    div word [SectorsPerTrack]
    mov dx, 0
    div word [Sides]
    mov dh, dl
    mov ch, al

    pop ax
    pop bx

    mov dl, byte [bootdev]

    ret

kernel_filename: db "AMONG   BIN"

disk_error: db "Floppy error! Press any key...", 0
file_not_found: db "AMONG.BIN not found!", 0

bootdev db 0
cluster dw 0
pointer dw 0

times 510 - ($-$$) db 0
dw 0xaa55

buffer: