%include 'io.inc'

section .text
global main
global rec
main:
    push ebp
    mov ebp, esp
    
    call rev
    
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret
    
rev:
    push ebp
    mov ebp, esp
    
    GET_DEC 4, ecx
    test ecx, ecx
    jz .return  
    
    push ecx 
    call rev
    pop ecx
    
    PRINT_DEC 4, ecx
    PRINT_CHAR ' '

.return:   
    mov esp, ebp 
    pop ebp
    ret