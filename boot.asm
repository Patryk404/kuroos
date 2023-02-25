ORG 0
BITS 16

_start:
    jmp short start
    nop 

times 33 db 0

start:
    start jmp 0x7c0:step2 

handle_zero:
    mov ah,0eh
    mov al,'A'
    mov bx,0x00
    int 0x10
    iret

handle_one:
    mov si, message2
    call print
    iret

keyboard_func: ;keyboard interrupt
    mov si, messagekeyboard 
    call print
    iret

step2: 
    cli 
    mov ax,0x7c0
    mov ds,ax
    mov es,ax
    mov ax,0x00
    mov ss,ax 
    mov sp,0x7c00
    sti

    mov word[ss:0x00], handle_zero
    mov word[ss:0x02], 0x7c0
    
    mov word[ss:0x04], handle_one
    mov word[ss:0x06], 0x7c0

    mov word[ss:0x0024], keyboard_func
    mov word[ss:0x0026], 0x7c0
    
read_from_hard_disk: ; buffer is store in es:bx and basically if you want to print it you need to set appropriately ds and si because ds:si 
    mov ax, 0x7c0
    mov ds,ax
    mov es,ax
    mov ah,2
    mov al,1
    mov ch,0
    mov cl,2
    mov dh,0
    mov bx,buffer
    int 0x13
    jnc read_buffer 
error:
    mov si,messageError
    call print
read_buffer:
    mov si,buffer
    call print
    jmp $

print:
    mov bx, 0
.loop:
    lodsb
    cmp al, 0
    je .done
    call print_char
    jmp .loop
.done:
    ret

print_char:
    mov ah, 0eh
    int 0x10
    ret

message: db 'Hello World!!!', 0
message2: db 'Interrupt lol', 0 
messagekeyboard: db 'Pressed something',0
messageError: db 'Nie wierze czasami',0
times 510-($ - $$) db 0
dw 0xAA55
buffer:

