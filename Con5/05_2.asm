extern scanf
extern printf
extern strstr

section .rodata
    sk db `%s %s`, 0
    pr1 db `2 1`, 0
    pr2 db `1 2`, 0
    pr3 db `0`, 0

section .bss
    a resd 1000
    b resd 1000

section .text
global main
main:
    push ebp
    mov ebp, esp   
    and esp, 0xFFFFFFF0
    
    sub esp, 16
    mov dword[esp], sk
    mov dword[esp+4], a
    mov dword[esp+8], b
    call scanf
    
    ;ищем b в строке a
    mov dword[esp], a
    mov dword[esp+4], b
    call strstr
    test eax, eax
    jnz .print1
    
    ;ищем a в строке b
    mov dword[esp], b
    mov dword[esp+4], a
    call strstr
    test eax, eax
    jnz .print2
    
    mov dword[esp], pr3
    call printf
    jmp .return
    
.print1:
    mov dword[esp], pr1
    call printf
    jmp .return
.print2:
    mov dword[esp], pr2
    call printf
    jmp .return

.return:
    add esp, 16
    
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret