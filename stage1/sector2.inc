[bits 32]


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


	