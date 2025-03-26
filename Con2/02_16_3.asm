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
    
    ;считаем x -> eax
    
    ;a11&(~a12)&b1
    mov eax, [a12]
    not eax
    and eax, [a11]
    and eax, [b1]
    
    ;a21&(~a22)&b2
    mov ebx, [a22]
    not ebx
    and ebx, [a21]
    and ebx, [b2]
    
    or eax, ebx
    
    ;a11&a12&(~a21)&a22&b1&(~b2)
    ;a11&a12&(~a21)&a22&(~b1)&b2
    
    ;общая часть: a11&a12&(~a21)&a22 -> ebx
    mov ebx, [a21]
    not ebx
    and ebx, [a11]
    and ebx, [a12]
    and ebx, [a22]
    mov ecx, [a21]
    ;a11&a12&(~a21)&a22&b1&(~b2)
    mov ecx, [b2]
    not ecx
    and ecx, [b1]
    and ecx, ebx
    
    or eax, ecx
    
    ;a11&a12&(~a21)&a22&(~b1)&b2
    mov ecx, [b1]
    not ecx
    and ecx, [b2]
    and ecx, ebx
    
    or eax, ecx
    
    ;(~a11)&a12&a21&a22&b1&(~b2)
    ;(~a11)&a12&a21&a22&(~b1)&b2
    
    ;общая часть: (~a11)&a12&a21&a22 -> ebx
    mov ebx, [a11]
    not ebx
    and ebx, [a12]
    and ebx, [a21]
    and ebx, [a22]
    ;(~a11)&a12&a21&a22&(~b1)&b2
    mov ecx, [b1]
    not ecx
    and ecx, [b2]
    and ecx, ebx
    
    or eax, ecx
    
    ;(~a11)&a12&a21&a22&b1&(~b2)
    mov ecx, [b2]
    not ecx
    and ecx, [b1]
    and ecx, ebx
    
    or eax, ecx
    
    PRINT_UDEC 4, eax
    PRINT_CHAR ' '
    
    xor eax, eax
    ret