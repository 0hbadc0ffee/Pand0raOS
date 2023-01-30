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
    pusha
    mov al, [bx]
    cmp al, 0
    je .done
    mov ah, 0h0E
    int 0h10
    inc bx
    jmp print

.done:
    popa
    ret

main:
    mov bx, OS_BOOT_MSG
    call print

.halt:
    jmp .halt

OS_BOOT_MSG: db "[*] Booting Pand0raOS ...", 0

times 510-($-$$) db 0
dw 0hAA55