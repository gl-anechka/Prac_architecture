%include 'io.inc'

section .bss
    xx resb 1
    xy resb 1
    yx resb 1
    yy resb 1

section .text
global main
main:
    GET_CHAR xx
    GET_DEC 1, xy
    GET_CHAR yx  ;считывает пробел
    GET_CHAR yx
    GET_DEC 1, yy
    
    ;будем вести нумерацию с 0
    sub byte[xx], `A`
    sub byte[xy], 1
    sub byte[yx], `A`
    sub byte[yy], 1
    
    ;модуль разности xx и yx -> eax
    ;|x| = (x^(x>>31)) - (x>>31)
    xor eax, eax
    mov al, byte[xx]
    sub al, byte[yx]
    xor ebx, ebx
    mov bl, al
    sar bl, 31
    xor al, bl
    sub al, bl
    
    ;модуль разности xy и yy -> edx
    ;|x| = (x^(x>>31)) - (x>>31)
    xor edx, edx
    mov dl, byte[xy]
    sub dl, byte[yy]
    xor ebx, ebx
    mov bl, dl
    sar bl, 31
    xor dl, bl
    sub dl, bl
    
    add al, dl
    PRINT_DEC 1, al
    
    xor eax, eax
    ret