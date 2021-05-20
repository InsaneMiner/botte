all:create-disk

clean:
	rm -rf stage1/*.bin

run: clean
	cd stage1 && make build-bootloader-stage1
	qemu-system-x86_64 -fda stage1/bootloader.bin -d int -monitor pty -no-reboot
