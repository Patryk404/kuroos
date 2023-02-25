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
    jmp load32 ; 8 + load32 CODE_SEG:load32 this make like codesegment set to 8 but i am not sure what happens when we set it to just 0 lol

    
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
    mov ax, DATA_SEG ; offset 10
    mov ds, ax
    mov es, ax
    mov fs, ax 
    mov gs, ax 
    mov ss, ax
    mov ax, CODE_SEG ; offset 8
    mov ebp,0x00200000
    mov esp,ebp
    jmp $

times 510-($ - $$) db 0
dw 0xAA55

