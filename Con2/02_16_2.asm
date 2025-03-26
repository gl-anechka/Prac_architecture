%include 'io.inc'

section .bss
    a11 resd 1
    a12 resd 1
    a21 resd 1
    a22 resd 1
    b1 resd 1
    b2 resd 1
    
section .data
    det dd 0
    detx dd 0
    dety dd 0

section .text
global main
main:
    GET_UDEC 4, a11
    GET_UDEC 4, a12
    GET_UDEC 4, a21 
    GET_UDEC 4, a22
    GET_UDEC 4, b1
    GET_UDEC 4, b2
    
    ;det = a11&a22^a21&a12
    mov eax, [a11]
    and eax, [a22]   
    mov ebx, [a21]
    and ebx, [a12]   
    xor eax, ebx
    
    mov dword[det], eax
    
    ;detx = b1&a22^a12&b2
    mov eax, [a22]
    and eax, [b1]    
    mov ebx, [b2]
    and ebx, [a12]    
    xor eax, ebx
    
    mov dword[detx], eax
    
    ;dety = b2&a11^a21&b1
    mov eax, [b2]
    and eax, [a11]
    mov ebx, [b1]
    and ebx, [a21]
    xor eax, ebx
    
    mov dword[dety], eax
    
    mov eax, [detx]
    and eax, [det]

    PRINT_UDEC 4, eax
    PRINT_CHAR ' '
    
    mov eax, [dety]
    and eax, [det]
    
    PRINT_UDEC 4, eax
    
    xor eax, eax
    ret