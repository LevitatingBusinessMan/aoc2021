section .rodata
	inputfilename db "input.txt", 0
	inputbufferlen equ 7844
	errorstr db "error", 10, 0
	resultstr db "part%d: h%d d%d *%d", 10, 0

section .bss
	inputbuffer resb inputbufferlen

section .text
	global main
	extern read_file
	extern printf

main:
	mov rdi, inputfilename
	mov rsi, inputbufferlen
	mov rdx, inputbuffer
	call read_file

	; for some reason a bunch of starting bytes seem to be ignored when using inputbuffer var instead of the returned
	; address, even though they are identical
	; seems to be an issue with how variables are read
	; whatever
	mov r12, rax

	mov rsi, r12
	mov rax, 1
	mov rdi, 1
	;syscall

	; 0x30 = 0
	; 0x39 = 9

	xor rbx, rbx				; offset
	xor r13, r14

	enter 16, 0					; 4 32bit values
	mov qword [rbp], qword 0	; make sure these are all 0
	mov qword [rbp+8], qword 0	

	; horizontal
	; depth1
	; aim
	; depth2

.parse_line:
	cmp rbx, inputbufferlen-1	; -1 because of the null byte
	jge .return
	movzx r13, byte [r12+rbx]	; first byte
	
.loop1:
	inc rbx
	movzx  r14, byte [r12+rbx]
	cmp r14, 0x30
	jge .greater
	jmp .loop1

.greater:
	cmp r14, 0x39
	jle .number					; we got the number
	jmp .loop1

.number:
	; r14 holds number
	; r13 holds first type
	add rbx, 2					; step over newline
	
	sub r14, 0x30				; turn into correct number instead of char
	cmp r13, 0x66
	je .forward
	cmp r13, 0x75
	je .up
	cmp r13, 0x64
	je .down
	jmp .error

.forward:
	add [rbp], r14			; horizontal
	mov rax, [rbp+8]		; aim
	imul rax, r14
	add [rbp+12], rax		; depth2
	jmp .parse_line

.up:
	sub [rbp+4], r14		; depth1
	sub [rbp+8], r14		; aim
	jmp .parse_line

.down:
	add [rbp+4], r14		; depth1
	add [rbp+8], r14		; aim
	jmp .parse_line

.error:
	xor rax,rax
	mov rdi, errorstr
	call printf

	leave
	ret

.return:

	xor rax, rax
	mov rdi, resultstr
	mov rsi, 1
	mov rdx, [rbp]
	mov rcx, [rbp+4]
	mov r8, [rbp]
	imul r8, rcx
	call printf

	xor rax, rax
	mov rdi, resultstr
	mov rsi, 2
	mov rdx, [rbp]
	mov rcx, [rbp+12]
	mov r8, [rbp]
	imul r8, rcx
	call printf

	leave
	mov     rax, 60
	xor     rdi, rdi
	syscall
