extern printf
extern scanf

section .rodata
    sk db `%u `, 0
    pr db  `0x%08X\n`, 0
    
section .bss
    n resd 1

section .text
global main
main:     
    push ebp
    mov ebp, esp
    
    and esp, 0xFFFFFFF0
    
.for:
    push 0
    push 0
    push n
    push sk
    call scanf
    
    add esp, 16
    
    cmp eax, -1
    jz .return
    push 0
    push 0
    push dword[n]
    push pr
    call printf
    
    add esp, 16
    jmp .for
    
.return:    
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret