org 0h7c00
bits 16

; FAT 12 headers
jmp short main
nop

; => bios paramater block
db 'MSWIN4.1'               ; oem_identifier
dw  512                     ; bytes per sector
db  1                       ; sector per cluster
dw  1                       ; reserved sectors
db  2                       ; fat count
dw  0E0h                    ; dir entries count
dw  2880                    ; total sectors
db  0F0h                    ; media descriptor
dw  9                       ; sectors per fat
dw  18                      ; sectors per track
dw  2                       ; heads
dd  0                       ; hidden sectors
dd  0                       ; large sector count

; => extended boot record
db  0                       ; drive number
db  0
db  0h29                    ; signature
db  0h13, 0h43, 0h74, 0h21  ; volume id
db  'Pand0raOS  '           ; volume label
db  'FAT12   '              ; system label

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