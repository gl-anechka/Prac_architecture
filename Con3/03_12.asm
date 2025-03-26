%include 'io.inc'

section .bss
    k resd 1

section .text
global main
main:
    GET_DEC 4, eax
    GET_DEC 4, k
    
    xor ecx, ecx  ;ответ задачи
    mov esi, eax
    
.for: ;цикл по всем числам от n до 1
    test esi, esi
    jz .return
    mov eax, esi
    xor ebx, ebx  ;кол-во 0 в числе
.do:  ;подсчет кол-ва 0 в числе
    shr eax, 1  ;бит во флаге
    jc .go  ;если 1, т.е. CF установлен
    inc ebx
.go:
    test eax, eax
    jne .do
    
    dec esi
    cmp ebx, [k]
    jne .for
    inc ecx
    jmp .for

.return: 
    PRINT_DEC 4, ecx
      
    xor eax, eax
    ret