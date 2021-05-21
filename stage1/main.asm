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

	;mov si,hello0
	;call print_16

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

[bits 32]

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
bits 32

bit32: ; goes into 32 bit mode
  
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


hello: db "Hello more than 512 bytes world!!",0
yo: db "dsd",0
print_:
	mov esi,hello
	mov ebx,0xb8000
	ret
print_1:
	mov esi,yo
	mov ebx,0xb8000
.loop:
	lodsb
	or al,al
	jz halt
	or eax,0x0F00
	mov word [ebx], ax
	add ebx,2
	jmp .loop


boot2:
    call bit32
	
	call print_1

	mov si,hell
	lea esi, [rel + print_16]
	call function16
halt:
	mov esp,kernel_stack_top
	extern stage2
	call stage2
	
	cli
	hlt


[bits 16]
hell:
 db "sdfasd",0
function16:
	call bits16
	call RealMode
	;call esi ; calls the function
	ret

print_16:
	mov ah,0x0e
.loop:
    lodsb
    or al,al ; is al == 0 ?
    jz halt  ; if (al == 0) jump to halt label
    int 0x10 ; runs BIOS interrupt 0x10 - Video Services
    jmp .loop


[BITS 32]
global print_what
global print_yo


[bits 16]
 
idt_real:
	dw 0x3ff		; 256 entries, 4b each = 1K
	dd 0			; Real Mode IVT @ 0x0000
 
savcr0:
	dd 0			; Storage location for pmode CR0.
 
RealMode:
        ; We are already in 16-bit mode here!
 
	cli			; Disable interrupts.
 
	; Need 16-bit Protected Mode GDT entries!
	mov eax, 0x18	; 16-bit Protected Mode data selector.
	mov ds, eax
	mov es, eax
	mov fs, eax
	mov gs, eax
	mov ss, eax
 
 
	; Disable paging (we need everything to be 1:1 mapped).
	mov eax, cr0
	mov [savcr0], eax	; save pmode CR0
	and eax, 0x7FFFFFFe	; Disable paging bit & disable 16-bit pmode.
	mov cr0, eax
 
	jmp 0:GoRMode		; Perform Far jump to set CS.
 
GoRMode:
	mov sp, 0x8000		; pick a stack pointer.
	mov ax, 0		; Reset segment registers to 0.
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	lidt [idt_real]
	sti	
[bits 32]

section .bss
align 4
kernel_stack_bottom: equ $
	resb 16384 ; 16 KB
kernel_stack_top: