section .rodata
	inputfilename db "input.txt", 0
	inputbufferlen equ 13001
	arraylen equ 1000
	resultstr db "g%d e%d m%d",10,0
	bitarraylen equ 12

section .bss
	inputbuffer resb inputbufferlen
	array resb arraylen*4
	bitbuffer resd bitarraylen

section .text
	global main
	extern read_file
	extern string_to_int
	extern printf

main:
	mov rdi, inputfilename
	mov rsi, inputbufferlen
	mov rdx, inputbuffer
	call read_file


	mov r12, rax

	mov rsi, r12
	mov rax, 1
	mov rdi, 1
	;syscall

	xor rcx, rcx 		; index in current bitarray (or column)
	xor r14, r14 		; row

	xor rbx, rbx 		; gamma byte

.fetch_bit:
	mov al, byte [r12]
	cmp al, 0xa
	je .newline
	cmp al, 0x30
	je .0
	mov r11, [bitbuffer+rcx*2]
	inc r11
	mov [bitbuffer+rcx*2], r11
.0:
	inc rcx
	inc r12
	jmp .fetch_bit

.newline:
	; should have a completed bit array now

	inc r12
	inc r14			; increment row
	xor rcx, rcx

	cmp r14, arraylen
	jge .count
	jmp .fetch_bit

.count:
	cmp rcx, bitarraylen
	jge .finish
	movzx rdi, word [bitbuffer+rcx*2]
	cmp word [bitbuffer+rcx*2], arraylen/2
	jl .notgreater

	xor r11,r11
	mov r11, 1				; is the resulting shifted value
	mov rax, bitarraylen-1 	; will be the counter of how many left shifts should still be done
	sub rax, rcx
.left_shift:
	shl r11, 1
	dec rax
	cmp rax, 1
	jge .left_shift

	add rbx, r11

.notgreater:
	inc rcx
	jmp .count

.finish:

	xor rax, rax
	mov rdi, resultstr
	mov rsi, rbx
	mov rdx, 0xffffffffffffffff
	shr rdx, 64-bitarraylen
	xor rdx, rbx
	mov rcx, rbx
	imul rcx, rdx
	call printf

	ret

;001010001110=654

;111010101010