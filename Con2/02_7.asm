%include 'io.inc'

section .text
global main
main:
    mov eax, 0
    mov ebx, 0
    GET_UDEC 1, al  ;a
    GET_UDEC 1, ah  ;b
    GET_UDEC 1, bl  ;c
    GET_UDEC 1, bh  ;d
    shl ebx, 16  
    or eax, ebx 
    PRINT_UDEC 4, eax 
    
    xor eax, eax
    ret