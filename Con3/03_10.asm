%include 'io.inc'

section .bss
    n resd 1

section .text
global main
main:
    GET_DEC 4, n
    
    ;ebx <- n / 2 с округлением вверх
    mov eax, [n]
    cdq
    mov ecx, 2
    idiv ecx
    add eax, edx
    mov ebx, eax
    inc ebx  ;для удобства цикла

.while:
    dec ebx
    mov eax, [n]
    cdq
    div ebx
    
    test edx, edx
    jnz .while
    
    PRINT_DEC 4, ebx
    
    xor eax, eax
    ret