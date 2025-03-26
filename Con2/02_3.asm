%include 'io.inc'

section .bss
    a resd 1  ;красный
    b resd 1  ;синий
    c resd 1  ;зеленый
    
    d resd 1  ;красный
    e resd 1  ;синий
    f resd 1  ;зеленый

section .text
global main
main:
    GET_DEC 4, a
    GET_DEC 4, b
    GET_DEC 4, c
    GET_DEC 4, d
    GET_DEC 4, e
    GET_DEC 4, f
    
    ;выбрать a и e или f
    mov eax, [e]
    add eax, [f]
    imul eax, [a]
    
    ;выбрать b и d или f
    mov ebx, [d]
    add ebx, [f]
    imul ebx, [b]
    
    add eax, ebx
    
    ;выбрать c и d или e
    mov ebx, [d]
    add ebx, [e]
    imul ebx, [c]
    
    add eax, ebx
    
    PRINT_DEC 4, eax
    
    xor eax, eax
    ret