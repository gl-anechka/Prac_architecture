%include 'io.inc'

section .bss
    n resd 1
    arr resd 10000

section .text
global main
main:   
    GET_DEC 4, n
    
    mov ecx, 0
.get_arr:
    GET_DEC 4, [arr + ecx*4]
    inc ecx
    cmp ecx, dword[n]
    jl .get_arr
    
    mov ecx, 0
.for1:
    mov edi, [n]
    sub edi, 2
.for2:
    ;arr[edi] > arr[edi+1] => swap
    mov eax, [arr + edi*4]
    mov ebx, [arr + edi*4 + 4]
    cmp eax, ebx
    jle .continue
    mov [arr + edi*4 + 4], eax
    mov [arr + edi*4], ebx
.continue: 
    dec edi
    cmp edi, ecx
    jge .for2
    
    inc ecx
    cmp ecx, [n]
    jl .for1

    ;печать отсортированного массива    
    mov ecx, 0
.print:
    PRINT_DEC 4, [arr + ecx*4]
    PRINT_CHAR ' '
    inc ecx
    cmp ecx, [n]
    jl .print
    
    xor eax, eax
    ret