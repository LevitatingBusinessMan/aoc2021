section .rodata
	NR_WRITE equ 1
	STDOUT equ 1

	inputfilename db "input.txt", 0
	inputbufferlen equ 1024

section .text
	global main
	extern read_file

main:
	mov rdi, inputfilename
	mov rsi, inputbufferlen
	call read_file

	; print
	mov rsi, rax
	mov rax, NR_WRITE
	mov rdi, STDOUT
	syscall

	ret
