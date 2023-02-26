[BITS 32]
CODE_SEG equ 0x08
DATA_SEG equ 0x10
global _start
_start: 

    mov ax, DATA_SEG ; offset 10
    mov ds, ax
    mov es, ax
    mov fs, ax 
    mov gs, ax 
    mov ss, ax
    mov ax, CODE_SEG ; offset 8
    mov ebp,0x00200000
    mov esp,ebp
     ;; enabling a20 line 
    in al, 0x92
    or al, 2
    out 0x92, al

    jmp $
