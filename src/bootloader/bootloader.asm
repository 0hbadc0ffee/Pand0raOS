org 0h7c00
bits 16

; FAT 12 headers
jmp short main
nop

; => bios paramater block
oem: db 'MSWIN4.1'               ; oem_identifier
bps: dw  512                     ; bytes per sector
spc: db  1                       ; sector per cluster
rss: dw  1                       ; reserved sectors
ftc: db  2                       ; fat count
drc: dw  0E0h                    ; dir entries count
tts: dw  2880                    ; total sectors
mdd: db  0F0h                    ; media descriptor
spf: dw  9                       ; sectors per fat
spt: dw  18                      ; sectors per track
hed: dw  2                       ; heads
hds: dd  0                       ; hidden sectors
lsc: dd  0                       ; large sector count

; => extended boot record
drn: db  0                       ; drive number
     db  0
sig: db  0h29                    ; signature
vid: db  0h13, 0h43, 0h74, 0h21  ; volume id
sid: db  'Pand0raOS  '           ; volume label
slb: db  'FAT12   '              ; system label

print:
    push ax
    push si

    lodsb                       ; load char from si into al
    cmp al, 0                   ; is this a null char ?
    je .done                    ; stop the print func if yes
    mov ah, 0h0E
    int 0h10
    jmp print

.done:
    pop si
    pop ax
    ret

disk_read_error:
    mov si, READ_DSK_ERR
    call print
    jmp reboot_system

reboot_system:
    mov ah, 0
    int 16h
    jmp 0xFFFF:0

main:
    mov [drn], dl

    mov ax, 1
    mov cl, 1
    mov bx, 0x7E00
    call read_disk

    mov si, OS_BOOT_MSG
    call print


.halt:
    cli
    hlt

; Disk operations

; convert LBA to CHS
; input
    ; -> LBA 
; returns
    ; -> sector in cx: bytes 0 - 5
    ; -> cylinder in cx: bytes 6 - 15
    ; -> head in dh
conv_lba_chs:
    push ax
    push dx

    ; calculate sector
    xor dx, dx
    div word [spt]
    inc dx
    mov cx, dx

    ; calculate head
    xor dx, dx
    div word [hed]
    mov dh, dl

    ; calculate cylinder
    mov ch, al
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop ax
    ret


; [*] DISK OPERATIONS

; read disk
; input
    ; -> ax: LBA
    ; -> cl: number of sectors to read
    ; -> dl: drive number
    ; -> es:bx: where to store read data

read_disk:
    push ax
    push bx
    push cx
    push dx
    push di

    push cx

    call conv_lba_chs
    pop ax
    
    mov di, 3
    mov ah, 02h

; retry disk read @ least thrice
.retry_disk_read:
    pusha
    stc
    int 13h
    jnc .disk_read_success

    popa
    call reset_disk_controller
    dec di
    test di, di
    jnz .retry_disk_read

; disk reac failed after 3 tries
.failed_disk_read:
    jmp disk_read_error

.disk_read_success:
    popa
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret


reset_disk_controller:
    pusha
    stc

    mov ah, 0
    int 13h
    jc disk_read_error
    popa
    ret


OS_BOOT_MSG:                db "[*] Booting Pand0raOS...", 0
READ_DSK_ERR:               db "[*] Read from disk failed !!!", 0

times 510-($-$$) db 0
dw 0hAA55