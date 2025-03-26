%include 'io.inc'

section .bss
    n resd 1
    x resd 1
    y resd 1

section .text
global nod
global main
main:
    push ebp
    mov ebp, esp
    
    GET_DEC 4, n
    
    GET_DEC 4, x
    GET_DEC 4, y
    
    cmp dword[n], 1  ;только 1 дробь
    je .go
    
    ;цикл по всем считываемым элементам
    ;получаем сумму всех дробей
.for:
    ;сложение двух дробей с привидением к общему знаменателю
    GET_DEC 4, eax
    GET_DEC 4, ebx
    imul eax, [y]
    mov ecx, [x]
    imul ecx, ebx
    add ecx, eax
    mov [x], ecx
    imul ebx, [y]
    mov [y], ebx
    
    dec dword[n]
    cmp dword[n], 1
    jg .for

.go:   
    ;сокращение полученной дроби
    ;x = max(x, y), y = min(x, y)
    mov eax, [x]
    mov ebx, [y]
    cmp eax, ebx
    jge .continue
    xchg eax, ebx
.continue:  ;собственно сокращение
    push eax  ;max
    push ebx  ;min
    call nod  ;НОД(x, y)
    mov ecx, eax
    add esp, 8  
    
    mov eax, [x]
    cdq
    idiv ecx
    mov [x], eax
    mov eax, [y]
    cdq
    idiv ecx
    mov [y], eax
    
    PRINT_DEC 4, x
    PRINT_CHAR ' '
    PRINT_DEC 4, y  
    
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret
    
    
;НОД по алгоритму Евклида
nod:
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
    
.return:
    mov esp, ebp
    pop ebp
    
    ret  