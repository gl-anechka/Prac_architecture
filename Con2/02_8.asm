%include 'io.inc'

section .text
global main
main:
    ;заменить тернарный оператор на (c&a)|((~c)&b)
    GET_HEX 4, eax  ;a
    GET_HEX 4, ebx  ;b
    GET_HEX 4, ecx  ;c
    
    and eax, ecx
    not ecx
    and ebx, ecx
    or eax, ebx   
    
    PRINT_HEX 4, eax
    
    xor eax, eax
    ret