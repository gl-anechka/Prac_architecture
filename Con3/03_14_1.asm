%include 'io.inc'

section .bss
    k resd 1
    n resd 1

section .text
global main
main:
    GET_DEC 4, n
    GET_DEC 4, k
    mov eax, [n]
    
    ;ПРОВЕРКА НА ПРОСТЫЕ СЛУЧАИ
    xor ecx, ecx  ;разряд ведущей 1
    xor edx, edx  ;кол-во 1
.while: ;считаем разряд ведущей 1
    shr eax, 1  ;бит во флаге
    adc edx, 0
    inc ecx
    test eax, eax
    jne .while
    
    mov ebx, [k]
    
    ;если значащих нулей больше, чем разрядов в числе
    cmp ebx, ecx
    mov edi, 0
    cmovge ecx, edi
    jge .return
    
    ;если 0 знач. нулей, то подходят числа только из 1
    test ebx, ebx
    jnz .otherpart  ;не прокатило

    cmp ecx, edx  ;если само число только из 1
    je .return
    dec ecx
    jmp .return
        
    

;ОСНОВНАЯ ЧАСТЬ
.otherpart:
    mov eax, [n]
.begin:    
    xor ecx, ecx  ;ответ задачи
    mov esi, eax
    
.for: ;цикл по всем числам от n до 1
    test esi, esi
    jz .return
    mov eax, esi
    xor edx, edx  ;разряд ведущей 1
    xor ebx, ebx  ;кол-во 0 в числе
.do:  ;подсчет кол-ва 0 в числе
    shr eax, 1  ;бит во флаге
    inc edx
    jc .go  ;если 1, т.е. CF установлен
    inc ebx
.go:
    test eax, eax
    jne .do      
    
    dec esi
    cmp ebx, [k]
    jne .for
    inc ecx
    ;если k 0 в числе и только 1 ведущая 1, то
    ;можно числа меньше не проверять, таких больше нет
    sub edx, ebx  ;кол-во 1 в числе
    cmp edx, 1
    je .return
    jmp .for

.return: 
    PRINT_DEC 4, ecx
      
    xor eax, eax
    ret