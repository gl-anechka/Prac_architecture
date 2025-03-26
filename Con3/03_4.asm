%include 'io.inc'

section .bss
    n resd 1
    oct_n resd 11
    
section .data
    bas dd 8  ;основание системы счисления

section .text
global main
main:
    GET_UDEC 4, [n]
    mov eax, [n]
    mov ecx, 0
    
    ;заполнение массива
.do:
    cdq
    div dword[bas]
    mov dword[oct_n + ecx*4], edx
    
    inc ecx
    cmp eax, 0
    jne .do
    
    ;печать числа
.print:
    dec ecx  ;ecx <- кол-во элементов массива
    
    PRINT_DEC 4, [oct_n + ecx*4]

    cmp ecx, 0
    jne .print
    
    xor eax, eax
    ret