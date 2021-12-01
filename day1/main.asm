section .rodata
	NR_WRITE equ 1
	STDOUT equ 1

	inputfilename db "input.txt", 0
	inputbufferlen equ 9590
	arraylen equ 2000

	result1_string db "part 1: %d", 10, 0

section .bss
	inputbuffer resb inputbufferlen
	; Letting "read_file" make it's own buffer via alloc resulted in a bunch of issues

section .text
	global main
	extern read_file
	extern int_parse
	extern printf

main:
	mov rdi, inputfilename
	mov rsi, inputbufferlen
	mov rdx, inputbuffer
	call read_file

	; print (rdx set by read)
	mov rsi, rax
	mov rax, NR_WRITE
	mov rdi, STDOUT
	;syscall

	mov rdi, rsi
	mov rsi, arraylen
	call int_parse

	mov r12, rax		; save array to r12
	xor rcx, rcx
	xor rdx, rdx
	xor rax, rax
	xor rbx, rbx

.loop:
	mov eax, [r12+rcx]		; prev
	add rcx, 4				; index
	mov ebx, [r12+rcx]		; curr

	cmp rax, rbx
	jg .decrement
	inc rdx					; increment count

.decrement:
	cmp rcx, arraylen*4
	jl .loop

	mov rsi, rdx
	mov rdi, result1_string
	xor rax, rax			; this is somehow essential for printf to work
	call printf

	ret
