section .boot
bits 16
global boot




boot:
	mov ax, 0x2401
	int 0x15

	mov ax, 0x3
	int 0x10

	mov [disk],dl

	mov ah, 0x2    ;read sectors
	mov al, 6      ;sectors to read
	mov ch, 0      ;cylinder idx
	mov dh, 0      ;head idx
	mov cl, 2      ;sector idx
	mov dl, [disk] ;disk idx
	mov bx, copy_target;target pointer
	int 0x13

	cli
	lgdt [gdt_ptr]
	
	mov eax, cr0
    or eax,0x1
    mov cr0, eax

	jmp 0x8:boot2

bit32:
  
  mov ax, 0x10
  mov ds, ax
  mov es, ax
  mov fs, ax
  mov gs, ax
  mov ss, ax
  ; End of changing mode code
  ; Jumps into 32 bit code
  jmp 0x8:.done
.done:
    ret



bits16:
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp 0x18:.done
.done:
    ret
gdt_start:
gdt_:
;null descriptor
    dd 0
    dd 0
;32bit code
    dw 0xFFFF ; limit value 
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
;32bit data
    dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
;16bit code
    dw 0xFFFF ; limit value (2 bytes)
	dw 0x0    ;    (2 bytes)
	db 0x0    ;    (1 byte)
	db 10011010b ; (1 byte)
    db 00000000b ; (1 byte)
	db 0x0       ; (1 byte)
;16bit data
    dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
    db 00000000b ; (1 byte)
	db 0x0
gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start - 1
    dd gdt_start
disk:
	db 0x0


times 510 - ($-$$) db 0
dw 0xaa55
copy_target:
bits 32
	hello: db "Hello more than 512 bytes world!!",0
boot2:
    call bit32
	mov esi,hello
	mov ebx,0xb8000
.loop:
	lodsb
	or al,al
	jz halt
	or eax,0x0F00
	mov word [ebx], ax
	add ebx,2
	jmp .loop
halt:
	mov esp,kernel_stack_top
	extern stage2
	call stage2
	
	cli
	hlt

[BITS 32]
global print_what
global print_yo

section .bss
align 4
kernel_stack_bottom: equ $
	resb 16384 ; 16 KB
kernel_stack_top: