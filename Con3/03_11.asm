%include 'io.inc'

section .data
    const dd 1

section .text
global main
main:
    GET_DEC 4, eax
    GET_DEC 4, ebx
    
    cmp eax, ebx
    jle .continue
    xchg eax, ebx
    
.continue:  
    ;if (b == 0 || a == b) -> return
    test ebx, ebx
    jz .return   
    cmp eax, ebx
    je .return
    
    ;алгоритм Евклида
    jg .iter
    xchg eax, ebx
.iter:
    cdq
    idiv ebx
    mov eax, ebx
    mov ebx, edx
    jmp .continue
    
.return:
    PRINT_DEC 4, eax  
    
    xor eax, eax
    ret