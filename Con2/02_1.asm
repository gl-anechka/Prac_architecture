%include 'io.inc'

section .bss
    vx resd 1
    vy resd 1
    ax2 resd 1
    ay2 resd 1
    t resd 1
 
section .text

global main
main:
    mov ebp, esp; for correct debugging
    GET_DEC 4, vx
    GET_DEC 4, vy
    GET_DEC 4, ax2
    GET_DEC 4, ay2
    GET_DEC 4, t
    
    ;считаем координату x
    mov eax, dword[t]
    mov ebx, eax
    imul ebx, eax
    imul ebx, dword[ax2]
    imul eax, dword[vx]
    add eax, ebx
    
    ;считаем координату y
    mov edx, dword[t]
    mov ebx, edx
    imul ebx, edx
    imul ebx, dword[ay2]
    imul edx, dword[vy]
    add edx, ebx 
    
    PRINT_DEC 4, eax
    PRINT_STRING ` `
    PRINT_DEC 4, edx
    
    xor eax, eax
    ret