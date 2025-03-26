%include 'io.inc'

section .text
global main
main:
    GET_UDEC 4, eax
    mov ecx, 32  ;счетчик
    xor ebx, ebx  ;кол-во 1
    
.do:
    shr eax, 1  ;бит во флаге
    jnc .go  ;если 0, т.е. CF не установлен
    inc ebx  ;если 1

.go:
    dec ecx
    cmp ecx, 0
    jne .do
   
    PRINT_DEC 4, ebx
    
    xor eax, eax
    ret