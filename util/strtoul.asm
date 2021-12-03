section .data
	;array dq 0
	;buf dq 0,0,0,0

section .text
	global string_to_int
	extern atoi
	extern strtoul
	extern malloc

string_to_int:
	enter 32,0

	mov r15, rbx 	; string length

	mov r14, r8		; rsi is the buffer length (in integers, not bytes)
	shl r14, 2		; multiply by 4

	mov r13, rsi

	mov r12, rdi
	xor rcx, rcx	; local variable index
	xor rbx, rbx	; array index

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
	mov rsi, rbp
	sub rsi, r15
	mov rbx, 2
	push rsp
	push rbp
	call strtoul
	pop rbp
	pop rsp
	mov [r13+rbx], eax
	add rbx, 4
	
	;mov QWORD [rbp], QWORD 0	; reset the stack var
	;mov QWORD [rbp-8], QWORD 0	
	;mov QWORD [rbp-16], QWORD 0	
	;mov QWORD [rbp-24], QWORD 0
	
	xor rcx, rcx
	cmp rbx, r14 
	jl .fetch_int

	mov rax, r13

	leave
	ret
