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