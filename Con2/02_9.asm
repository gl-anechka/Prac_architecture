%include 'io.inc'

section .text
global main
main:
    GET_DEC 4, eax
    
    ;|x| = (x^(x>>31)) - (x>>31)
    mov ebx, eax
    sar ebx, 31
    xor eax, ebx
    sub eax, ebx
    
    PRINT_DEC 4, eax
    
    xor eax, eax
    ret