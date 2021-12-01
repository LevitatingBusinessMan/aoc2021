build:
	nasm -f elf64 -g -F dwarf main.asm -o main.o
	nasm -f elf64 -g -F dwarf ../util/read.asm -o read.o
	nasm -f elf64 -g -F dwarf ../util/atoi.asm -o atoi.o
	gcc -m64 -o day1 main.o read.o atoi.o -no-pie

clean:
	rm -f main.o read.o atoi.o day1
