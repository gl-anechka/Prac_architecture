%include 'io.inc'

section .bss
    x1 resd 1
    x2 resd 1
    x3 resd 1
    y1 resd 1
    y2 resd 1
    y3 resd 1

section .text
global main
main:
    GET_DEC 4, x1
    GET_DEC 4, y1
    GET_DEC 4, x2
    GET_DEC 4, y2
    GET_DEC 4, x3
    GET_DEC 4, y3
    
    ;2*S=(x2-x1)*(y3-y1) - (x3-x1)*(y2-y1)
    mov eax, dword[x2]
    sub eax, dword[x1]  
    mov ebx, dword[y3]
    sub ebx, dword[y1]   
    imul eax, ebx
    
    mov ecx, dword[x3]
    sub ecx, dword[x1]
    mov ebx, dword[y2]
    sub ebx, dword[y1]   
    imul ecx, ebx
    
    sub eax, ecx
    
    ;|x|
    mov ebx, eax
    sar ebx, 31
    xor eax, ebx
    sub eax, ebx  
    
    ;S
    cdq
    mov ecx, 2
    idiv ecx
    imul edx, 5
    PRINT_DEC 4, eax
    PRINT_CHAR `.`
    PRINT_DEC 4, edx
            
    xor eax, eax
    ret