%include 'io.inc'

section .bss
    m resd 1
    d resd 1

section .text
global main
main:
    GET_DEC 4, m
    GET_DEC 4, d
    
    ;на регистр m-1
    mov eax, dword[m]
    dec eax
    
    ;получаем частное и остаток
    cdq
    mov ecx, 2
    idiv ecx
    
    ;(ост.+част.)*41
    add edx, eax
    imul edx, 41
    
    ;част.*42
    imul eax, 42
    
    ;част.*42 + (ост.+част.)*41 + d
    add eax, edx
    add eax, dword[d]
    PRINT_DEC 4, eax 
    
    xor eax, eax
    ret