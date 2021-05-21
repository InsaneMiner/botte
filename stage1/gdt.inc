




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
