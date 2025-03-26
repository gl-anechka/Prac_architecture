%include 'io.inc'

section .bss
    a resd 1
    b resd 1
    c resd 1
    v resd 1

section .text
global main
main:
    GET_UDEC 4, a
    GET_UDEC 4, b
    GET_UDEC 4, c
    GET_UDEC 4, v
    
    mov eax, dword[a]
    mul dword[b]
    div dword[v]
    mov ecx, edx  ;спасаем дробную часть AB/C
    
    ;целая часть AB/C
    mul dword[c]
    mov ebx, eax
           
    ;дробная часть AB/C
    mov eax, ecx
    mul dword[c]
    div dword[v]
    
    add eax, ebx
    PRINT_UDEC 4, eax
    
    xor eax, eax
    ret