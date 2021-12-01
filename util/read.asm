section .rodata
	; syscall numbers
	NR_READ			equ 0
	NR_WRITE		equ 1
	NR_OPEN			equ 2
	NR_CLOSE		equ 3

	; file access modes
	O_RDONLY		equ 0
	O_WRONLY		equ 1
	O_RDWR			equ 2

	; default file descriptors
	STDIN			equ 0
	STDOUT			equ 1
	STDERR			equ 2

	; fseek
	SEEK_END		equ 3

section .data
	; was having easy with any of these being smaller so that's that
	filedescriptor dq 0
	inputbufferlen dq 0
	inputbuffer dq 0

section .text
	global read_file
	extern malloc

read_file:
	enter 0, 0

	mov [inputbufferlen], rsi
	mov [inputbuffer], rdi

	; address should be loaded to rdi by caller
	mov rax, NR_OPEN			; set our syscall to 'open'
	mov rsi, O_RDONLY			; set read only
	syscall

	cmp rax, 0					; check if the file was opened successfully
	jl .exit

	mov [filedescriptor], rax	; save the fd

	; read the input file
	mov rdi, [filedescriptor]	; load the file descriptor into rdi
	mov rax, NR_READ			; set our syscall to 'read'
	mov rsi, inputbuffer		; load the address of our buffer into rsi
	mov rdx, [inputbufferlen]	; load the length of our buffer into rdx
	dec rdx						; create room for nullbyte

.read:
	syscall

	cmp rax, 0					; rax=bytes_read, negative means error
	jl .close_fd
	je .read_done

	add rsi, rax				; set new buffer offset
	sub rdx, rax				; make buffer length smaller
	mov rax, NR_READ			; set the READ syscall again
	jmp .read

.read_done:
	; add null byte
	inc rsi
	mov [rsi], byte 0

	mov rax, inputbuffer
	mov rdx, rsi
	sub rdx, inputbuffer ; rdx is now the length of bytes written

.close_fd:
	push rax

	mov rdi, [filedescriptor]
	mov rax, NR_CLOSE
	syscall

	pop rax

.exit:
	leave
	ret
