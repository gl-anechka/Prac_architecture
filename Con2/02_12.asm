%include 'io.inc'

section .data
    m db 'SCDH'
    n db '23456789TJQKA'

section .text
global main
main:
    xor eax, eax
    GET_DEC 1, al
    dec al
    xor ecx, ecx
    mov cl, 13
    idiv cl
    
    ;достоинство карты - остаток от деления на 13
    xor ecx, ecx
    mov cl, ah
    PRINT_CHAR [n+ecx]
    
    ;масть карты - целая часть от деления на 13
    xor ecx, ecx
    mov cl, al
    PRINT_CHAR [m+ecx]
    
    xor eax, eax
    ret