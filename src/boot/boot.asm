ORG 0x7C00
BITS 16

CODE_SEG equ gdt_code-gdt_start
DATA_SEG equ gdt_data-gdt_start

_start:
    jmp short step2
    nop 

times 33 db 0


step2: 
    cli 
    mov ax,0
    mov ds,ax
    mov es,ax
    mov ss,ax 
    mov sp,0x7c00
    sti

protected_mode:
    cli
    lgdt [gdt_descriptor]
    mov eax, cr0 
    or al, 1       ; set PE (Protection Enable) bit in CR0 (Control Register 0)
    mov cr0, eax
    jmp CODE_SEG:load32    
    ; jmp $ ; 8 + load32 CODE_SEG:load32 this make like codesegment set to 8 but i am not sure what happens when we set it to just 0 lol



;=============================================================================
; ATA read sectors (LBA mode)  stole it from osdev
;
; @param EAX Logical Block Address of sector
; @param CL  Number of sectors to read
; @param RDI The address of buffer to put data obtained from disk
;
; @return None
;=============================================================================
ata_lba_read:
               and eax, 0x0FFFFFFF
               push eax
               push ebx
               push ecx
               push edx
               push edi
 
               mov ebx, eax         ; Save LBA in ebx
 
               mov edx, 0x01F6      ; Port to send drive and bit 24 - 27 of LBA
               shr eax, 24          ; Get bit 24 - 27 in al
               or al, 11100000b     ; Set bit 6 in al for LBA mode
               out dx, al
 
               mov edx, 0x01F2      ; Port to send number of sectors
               mov al, cl           ; Get number of sectors from CL
               out dx, al
 
               mov edx, 0x1F3       ; Port to send bit 0 - 7 of LBA
               mov eax, ebx         ; Get LBA from EBX
               out dx, al
 
               mov edx, 0x1F4       ; Port to send bit 8 - 15 of LBA
               mov eax, ebx         ; Get LBA from EBX
               shr eax, 8           ; Get bit 8 - 15 in AL
               out dx, al
 
 
               mov edx, 0x1F5       ; Port to send bit 16 - 23 of LBA
               mov eax, ebx         ; Get LBA from EBX
               shr eax, 16          ; Get bit 16 - 23 in AL
               out dx, al
 
               mov edx, 0x1F7       ; Command port
               mov al, 0x20         ; Read with retry.
               out dx, al
 
.still_going:  in al, dx
               test al, 8           ; the sector buffer requires servicing.
               jz .still_going      ; until the sector buffer is ready.
 
               mov eax, 256         ; to read 256 words = 1 sector
               xor bx, bx
               mov bl, cl           ; read CL sectors
               mul bx
               mov ecx, eax         ; ecx is counter for INSW
               mov edx, 0x1F0       ; Data port, in and out
               rep insw             ; in to [edi]
 
               pop edi
               pop edx
               pop ecx
               pop ebx
               pop eax
               ret
    
gdt_start:
gdt_null:
    dd 0x0
    dd 0x0
gdt_code: ;; offset 0x08
    dw 0xffff
    dw 0
    db 0
    db 0x9a
    db 11001111b
    db 0
    
gdt_data:
    dw 0xffff
    dw 0
    db 0 
    db 0x92 
    db 11001111b
    db 0 

gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_start-1 
    dd gdt_start


[BITS 32]
load32:
    mov eax,1
    mov cl,100
    mov edi,0x100000

    call ata_lba_read

    jmp CODE_SEG:0x0100000 ; CODE_SEGMENT Still here? 
    ;When in protected mode we have selectors that replace the segmentation model found in real mode. The selector is specified in the GDT, so the rules in the GDT explain how we access memory on a selector.
    ; We are not jumping to segment 0x8h because that is now a selector, it does not follow the segmentation model found in real mode as we are in protected mode now. We have many lectures explaining the whole process so do not worry just keep following the course.




times 510-($ - $$) db 0
dw 0xAA55

