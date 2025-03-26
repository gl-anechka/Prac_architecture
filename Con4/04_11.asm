%include 'io.inc'

section .bss
    n resd 1

section .text
global div3
global main
main:
    push ebp
    mov ebp, esp
    
    GET_DEC 4, n
.for:
    cmp dword[n], 0
    je .return
    dec dword[n]
    
    GET_UDEC 4, ebx
    push ebx
    call div3
    test eax, eax
    jnz .no  ;не делится
    PRINT_STRING 'YES'
    NEWLINE
    jmp .for
.no:
    PRINT_STRING 'NO'
    NEWLINE
    jmp .for

.return:    
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret
    


;Проверка делимости
div3:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebp+8]
    xor eax, eax  ;сумма битов на нечетных местах
    xor edx, edx  ;сумма битов на четных местах
.count:
    test ecx, ecx
    je .rec
    shr ecx, 1
    adc eax, 0  ;сложение с учетом флага CF
    
    test ecx, ecx
    je .rec
    shr ecx, 1
    adc edx, 0  ;сложение с учетом флага CF
    jmp .count
    
.rec:
    sub eax, edx  ;разность сумм
    ;модуль разности
    mov edx, eax
    sar edx, 31
    xor eax, edx
    sub eax, edx
    
    cmp eax, 3
    jl .return  ;уже понятен результат
    
    push eax
    call div3
    add esp, 4
    
.return:
    test eax, eax  ;0 - делится
    mov ecx, 1
    cmovnz eax, ecx  ;1 - не делится
          
    pop ebp
    ret