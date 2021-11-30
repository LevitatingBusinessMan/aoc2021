get_input:
	nasm -f elf64 -g -F dwarf main.asm -o main.o
	nasm -f elf64 -g -F dwarf read.asm -o read.o
	gcc -m64 -o main main.o read.o -no-pie

clean:
	rm main.o read.o main
