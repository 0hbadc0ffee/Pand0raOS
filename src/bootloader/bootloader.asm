org 0h7c00
bits 16

print:
    push bx

.repeat:
    mov al, [bx]
    cmp al, 0
    je .done
    mov ah, 0h0E
    int 0h10
    add bx, 1
    jmp .repeat

.done:
    pop bx
    ret

main:
    mov bx, OS_BOOT_MSG
    call print

.halt:
    jmp .halt

OS_BOOT_MSG: db "[*] Booting Pand0raOS ...", 0

times 510-($-$$) db 0
dw 0hAA55