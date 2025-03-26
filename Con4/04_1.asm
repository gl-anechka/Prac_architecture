%include 'io.inc'

section .bss
    a resd 1
    b resd 1
    c resd 1
    d resd 1

section .text
global main
global nod
main:
    push ebp
    mov ebp, esp
    
    GET_DEC 4, a
    GET_DEC 4, b
    GET_DEC 4, c
    GET_DEC 4, d
    
    ;a <- НОД(a, b)
    push dword[a]
    push dword[b]
    call nod    
    mov [a], eax
    
    ;b <- НОД(c, d)
    push dword[c]
    push dword[d]
    call nod
    mov [b], eax
    
    ;eax <- НОД(a, b, c, d)
    push dword[a]
    push dword[b]
    call nod
    
    PRINT_DEC 4, eax
    
    add esp, 24    
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret
    

;функция, реализующая алгоритм Евклида
nod:    
    ;пролог функции
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]
    mov ecx, [ebp+12]
    
    cmp eax, ecx
    jle .continue
    xchg eax, ecx
    
.continue:  
    ;if (b == 0 || a == b) -> return
    test ecx, ecx
    jz .return   
    cmp eax, ecx
    je .return
    
    ;алгоритм Евклида
    jg .iter
    xchg eax, ecx
.iter:
    cdq
    idiv ecx
    mov eax, ecx
    mov ecx, edx
    jmp .continue
    
    ;эпилог функции
.return:
    mov esp, ebp
    pop ebp
    
    ret  