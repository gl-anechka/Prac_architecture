%include 'io.inc'

section .bss
    a11 resd 1
    a12 resd 1
    a21 resd 1
    a22 resd 1
    b1 resd 1
    b2 resd 1

section .text
global main
main:
    GET_UDEC 4, a11
    GET_UDEC 4, a12
    GET_UDEC 4, a21
    GET_UDEC 4, a22
    GET_UDEC 4, b1
    GET_UDEC 4, b2
    
    ;y -> eax
    mov eax, 0
    not eax
    xor eax, dword[b1]
    xor eax, dword[b2]
    xor eax, dword[a12]
    xor eax, dword[a22]
    
    mov ebx, dword[a21]
    not ebx
    xor eax, ebx
    mov ebx, dword[a11]
    not ebx
    xor eax, ebx
    
    ;x -> ebx
    mov ebx, eax
    and ebx, dword[a12]
    xor ebx, dword[b1]
    
    mov edx, dword[a11]
    not edx
    or ebx, edx
    
    PRINT_UDEC 4, eax
    PRINT_CHAR ` `
    PRINT_UDEC 4, ebx
    
    xor eax, eax
    ret