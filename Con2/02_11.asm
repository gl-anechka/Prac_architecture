%include 'io.inc'

section .bss
    x resb 1
    y resb 1
    s resb 2

section .text
global main
main:
    GET_CHAR y
    GET_DEC 1, x
    mov al, 7
    sub al, byte[y]
    add al, 'A'
    mov dl, 8  ;y счёт начинается с 1
    sub dl, byte[x]
    
    mul dl  ;ax = al*dl
    mov cl, 2
    div cl
    
    PRINT_DEC 1, al
    
    xor eax, eax
    ret