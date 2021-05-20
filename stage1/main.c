//#include "arch/x86/common.h"
//#include "formats/elf/elf.h"

#define SECTSIZE 512


int  stage2(){
    //struct elfhdr *elf;
    //elf = (struct elfhdr*)0x10000;


    

    //Entry16();
    /*
    const short color = 0x0F00;
	const char* hello = "Botte Bootloader";
	short* vga = (short*)0xb8000;
	for (int i = 0; i<16;++i)
		vga[i+80] = color | hello[i];
    */
    return 0;
}



void write_string( int colour, const char *string )
{
    volatile char *video = (volatile char*)0xB8000;
    while( *string != 0 )
    {
        *video++ = *string++;
        *video++ = colour;
    }
}