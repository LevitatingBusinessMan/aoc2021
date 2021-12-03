
section .rodata
	columnlen equ 5
	rowlen equ 12

section .bss
	bitbuffy resb columnlen

section .text
	global part2

part2:
	mov r12, rdi 		; inputbuffer

	xor rax, rax		; counter for 1
	xor rbx, rbx		; counter for 0
	xor rcx, rcx		; column
	xor rdx, rdx		; row

.count_bit:

	; confirm to be good row
	mov r11, rcx

	cmp rcx, 0				; if on first column skip check
	je .good_row

.confirm_loop:
	dec r11
	
	movzx r13, byte [bitbuffy+r11]
	mov r14, r12
	mov r15, columnlen
	inc r15					; for the newline
	imul r15, rdx
	add r14, r15
	add r14, r11
	movzx r14, byte [r14]
	sub r14, 0x30

	cmp r13, r14			; bad row
	; cmp byte [bitbuffy+r11], byte [r12+rdx*columnlen+r11]
	jne .skip
	cmp r11, 0				; continue checking
	jg .confirm_loop
	jmp .good_row

.skip:
	inc rdx
	cmp rdx, rowlen
	jge .finished_column
	jmp .count_bit

.good_row:
	;addr calc
	mov r13, r12
	mov r14, columnlen
	inc r14				; account for newline
	imul r14, rdx
	add r13, r14
	add r13, rcx

	xor r11, r11
	movzx r11, byte [r13]
	cmp r11, 0x30
	je .0
	inc rax
	jmp .tail
.0:
	inc rbx
.tail:
	inc rdx
	cmp rdx, rowlen
	jge .finished_column
	jmp .count_bit

.finished_column:
	cmp rax, rbx
	jg .greater
	mov byte [bitbuffy+rcx], 0
	jmp .foo
.greater:
	mov byte [bitbuffy+rcx], 1
.foo:
	inc rcx
	cmp rcx, columnlen
	jge .continue
	xor rdx, rdx					; reset row index
	xor rax, rax					; reset counters for the next column
	xor rbx, rbx
	jmp .count_bit

.continue:
	ret
