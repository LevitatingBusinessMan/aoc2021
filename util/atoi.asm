section .data
	;array dq 0

section .text
	global int_parse
	extern atoi
	extern malloc

int_parse:
	;0		rbp
	;-4	rsp
	enter 4,0

	; create the buffer
	push rdi
	mov r14, rsi	; rsi is the buffer length (in integers, not bytes)
	shl r14, 2		; multiply by 4
	mov rdi, r14
	call malloc
	mov r13, rax
	pop rdi

	mov r12, rdi
	xor rcx, rcx	; inputbuffer index
	xor rdx, rdx	; array index

.fetch_int:
	mov al, byte [r12]
	inc r12
	cmp al, 0xa
	je .newline

	mov [rbp+rcx], al
	inc rcx
	jmp .fetch_int

.newline:
	; at this point rbp should show the string int
	
	mov rdi, rbp
	push rdx
	call atoi
	pop rdx
	mov [r13+rdx], eax
	add rdx, 4
	
	mov eax, 0
	mov [rbp], eax		; reset the stack var

	xor rcx, rcx
	cmp rdx, r14 			; this 400 should be dynamic (integers in array * 4)
	jl .fetch_int			; parse more if less than 8000

	mov rax, r13

	leave
	ret
