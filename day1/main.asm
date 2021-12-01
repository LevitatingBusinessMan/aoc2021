section .rodata
	NR_WRITE equ 1
	STDOUT equ 1

	inputfilename db "input.txt", 0
	inputbufferlen equ 100000;9590
	arraylen equ 100		; I tried creating this array in this file via .bss, but it for some reason overwrote the inputbuffer malloc'd by read.asm

section .text
	global main
	extern read_file
	extern int_parse

main:
	mov rdi, inputfilename
	mov rsi, inputbufferlen
	call read_file

	; print (rdx set by read)
	mov rsi, rax
	mov rax, NR_WRITE
	mov rdi, STDOUT
	;syscall

	mov rdi, rsi
	mov rsi, arraylen
	call int_parse

	;mov rax, [array]

	ret
