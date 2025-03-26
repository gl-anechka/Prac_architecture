%include 'io.inc'

section .text
global main
global func
main:
    push ebp
    mov ebp, esp
    
    push 1
    call func  ;func(numb), где numb - параметр печати
    
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret
    
func: 
    push ebp
    mov ebp, esp
    
    mov edx, [ebp + 8]
    
    GET_DEC 4, ecx
    test ecx, ecx
    jz .return
    
    ;if numb % 2 == 1 => print and call func
    test edx, 0x1
    jz .else
    PRINT_DEC 4, ecx
    PRINT_CHAR ' '
    inc edx
    push edx
    call func
    pop edx
    jmp .return
    
    ;if numb % 2 == 0 => call func and print
.else:
    inc edx
    push ecx  ;обязательно push, т.к. перезапишется
              ;при следующем вызове
    push edx
    call func
    pop edx
    pop ecx
    PRINT_DEC 4, ecx
    PRINT_CHAR ' '
    jmp .return

.return:    
    mov esp, ebp
    pop ebp
    
    ret