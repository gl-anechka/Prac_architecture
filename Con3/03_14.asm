%include 'io.inc'

section .bss
    n resd 1
    k resd 1
    
    one resd 1  ;кол-во единиц в числе
    first resd 1  ;разряд ведущей 1

section .text
global main
main:
    GET_DEC 4, n
    GET_DEC 4, k
    
    ;Подсчет числа 1 в числе
    ;ebx <- кол-во единиц в числе
    ;edx <- разряд ведущей 1 (нумер. с 0) или кол-во разрядов
    mov eax, [n]
    xor edx, edx
    mov ecx, 32  ;счетчик, чтобы определить разряд 1
    xor ebx, ebx  ;кол-во 1   
.do:
    shr eax, 1  ;бит во флаге
    adc ebx, 0
    mov edx, ecx
    dec ecx
    test eax, eax
    jnz .do
    
    mov [one], ebx
   
    mov ecx, 33
    sub ecx, edx
    dec ecx
    mov [first], ecx
    mov edx, ecx

    
    ;Кол-во чисел, удовлетвор. условию
    cmp edx, [k]  ;максимальное кол-во знач. нулей
    jl .end
    
    ;Cnk
    
    ;числитель = edx! -> eax
    mov eax, 1
    mov esi, edx
.cnk1:
    test esi, esi
    je .break1
    imul eax, esi
    dec esi
    jmp .cnk1
.break1:
    
    ;знаменатель = k! -> ecx
    mov edi, [k]
    mov ecx, 1
.cnk2:
    test edi, edi
    jz .break2
    imul ecx, edi
    dec edi
    jmp .cnk2
.break2:

    ;знаменатель = (edx-k)! -> ebx
    mov ebx, 1
    mov esi, edx
    sub esi, [k]
.cnk3:
    test esi, esi
    jz .break3
    imul ebx, esi
    dec esi
    jmp .cnk3
.break3:
    
    ;знаменатель целиком
    imul ecx, ebx
    ;CNK
    cdq
    idiv ecx
    
    PRINT_DEC 4, eax
    jmp .return
    
.end:
    PRINT_DEC 4, 0

.return:   
    xor eax, eax
    ret