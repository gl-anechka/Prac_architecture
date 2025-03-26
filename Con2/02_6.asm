%include 'io.inc'

section .bss
    n resd 1
    k resb 1

section .text
global main
main:
    GET_UDEC 4, n
    GET_UDEC 1, k
    mov eax, dword[n]
    mov cl, 32
    sub cl, byte[k]
    shl eax, cl
    shr eax, cl
    PRINT_UDEC 4, eax
    
    xor eax, eax
    ret