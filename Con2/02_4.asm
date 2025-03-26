%include 'io.inc'

section .bss
    x resd 1
    n resd 1
    m resd 1
    y resd 1

section .text
global main
main:
    GET_DEC 4, x
    GET_DEC 4, n
    GET_DEC 4, m
    GET_DEC 4, y
    
    mov eax, dword[n]
    sub eax, dword[m]  ;n-m, расход книг
    mov ebx, dword[y]
    sub ebx, 2011  ;y-2011
    
    imul eax, ebx  ;(n-m)*(y-2011)
    add eax, dword[x]
    PRINT_DEC 4, eax
    
    xor eax, eax
    ret