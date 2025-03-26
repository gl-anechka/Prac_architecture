%include 'io.inc'

section .bss
    n resd 1
    m resd 1
    k resd 1
    
    mt_a resd 100*100
    mt_b resd 100*100
    mt_c resd 100*100

section .text
global main
main:
    GET_DEC 4, n
    GET_DEC 4, m
    GET_DEC 4, k
    
    
    ;Матрица A
    xor ecx, ecx 
    mov eax, [n]
    imul eax, [m]  
.readA:
    GET_DEC 4, [mt_a + ecx*4]    
    inc ecx
    cmp ecx, eax
    jl .readA


    ;Матрица B
    xor ecx, ecx 
    mov eax, [k]
    imul eax, [m]  
.readB:
    GET_DEC 4, [mt_b + ecx*4]    
    inc ecx
    cmp ecx, eax
    jl .readB
    
    
    ;Умножение
    xor edi, edi  ;i
.mult_xor0:
    xor ebx, ebx  ;j
.mult_xor:
    xor ecx, ecx  ;k
.mult:
    mov eax, edi
    imul eax, [m]
    add eax, ecx  
    mov eax, [mt_a + eax*4]
    
    mov edx, ecx
    imul edx, [k]
    add edx, ebx 
    mov edx, [mt_b + edx*4]
    
    imul eax, edx
    
    mov edx, edi
    imul edx, [k]
    add edx, ebx
    add [mt_c + edx*4], eax
    
    inc ecx
    cmp ecx, [m]
    jl .mult
    
    PRINT_DEC 4, [mt_c + edx*4]
    PRINT_CHAR ' '
    
    inc ebx
    cmp ebx, [k]
    jl .mult_xor
    
    NEWLINE
    
    inc edi
    cmp edi, [n]
    jl .mult_xor0
    
    xor eax, eax
    ret