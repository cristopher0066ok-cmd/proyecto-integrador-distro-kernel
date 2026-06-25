all: kernel.iso

kernel.o: src/main.asm
	docker run --rm -v $PWD:/kernel kernel-builder nasm -f elf64 src/main.asm -o targets/x86_64/kernel.o

header.o: src/header.asm
	docker run --rm -v $PWD:/kernel kernel-builder nasm -f elf64 src/header.asm -o targets/x86_64/header.o

kernel.bin: kernel.o header.o
	docker run --rm -v $PWD:/kernel kernel-builder ld -n -o targets/x86_64/kernel.bin -T targets/x86_64/linker.ld targets/x86_64/header.o targets/x86_64/kernel.o

kernel.iso: kernel.bin
	mkdir -p targets/x86_64/isofiles/boot/grub
	cp targets/x86_64/kernel.bin targets/x86_64/isofiles/boot/
	cp targets/x86_64/grub.cfg targets/x86_64/isofiles/boot/grub/
	docker run --rm -v $PWD:/kernel kernel-builder grub-mkrescue -o kernel.iso targets/x86_64/isofiles -- -as mkisofs -R

clean:
	rm -rf targets/x86_64/*.o targets/x86_64/*.bin targets/x86_64/isofiles kernel.iso
