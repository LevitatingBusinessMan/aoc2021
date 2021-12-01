section .rodata
	NR_WRITE equ 1
	STDOUT equ 1

	inputfilename db "input.txt", 0
	inputbufferlen equ 9590
	arraylen equ 2000

	result_string db "part %d: %d", 10, 0

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

.loop1:
	mov eax, [r12+rcx]		; prev
	add rcx, 4				; index
	mov ebx, [r12+rcx]		; curr

	cmp eax, ebx
	jge .decrement1
	inc rdx					; increment count

.decrement1:
	cmp rcx, arraylen*4-4
	jl .loop1

	mov rsi, 1
	mov rdi, result_string
	xor rax, rax			; this is somehow essential for printf to work
	call printf

	; Part 2
	xor rcx, rcx			; this will be the offset again
	xor rdx, rdx			; the increment counter

	mov rcx, 8

.loop2:
	mov eax, [r12+rcx-8]
	add eax, [r12+rcx-4]
	add eax, [r12+rcx]	; sum of first window
	add rcx, 4
	mov ebx, [r12+rcx-8]
	add ebx, [r12+rcx-4]
	add ebx, [r12+rcx]	; sum of second window

	cmp eax, ebx
	jge .decrement2
	inc rdx					; increment count

.decrement2:
	cmp rcx, arraylen*4-4
	jl .loop2

	mov rsi, 2
	mov rdi, result_string
	xor rax, rax
	call printf

	ret
