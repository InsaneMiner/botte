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
.done:
    ret

%include "gdt.inc"

disk:
	db 0x0

hello0: db "dsaf",0


times 510 - ($-$$) db 0
dw 0xaa55
copy_target:

%include "sector2.inc"

%include "modes.inc"


section .bss
align 4
kernel_stack_bottom: equ $
	resb 16384 ; 16 KB
kernel_stack_top: