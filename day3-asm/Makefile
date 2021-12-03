build:
	nasm -f elf64 -g -F dwarf main.asm -o main.o
	nasm -f elf64 -g -F dwarf ../util/read.asm -o read.o
	nasm -f elf64 -g -F dwarf ../util/strtoul.asm -o strtoul.o
	gcc -m64 -o day3 main.o read.o strtoul.o -no-pie

clean:
	rm -f main.o read.o strtoul.o day3
