%include 'io.inc'

section .bss
    a resd 100
    lena resd 1
    
    b resd 100
    lenb resd 1
    
    c resd 100
    lenc resd 1
    
    answ resd 100
    
section .data
    const dd 10

section .text
global main
global toarray
global mult
main:
    mov ebp, esp; for correct debugging
    ;заполенение массивов
    GET_UDEC 4, eax
    push a
    call toarray
    mov [lena], eax
    
    GET_UDEC 4, eax
    push b
    call toarray
    mov [lenb], eax
    
    GET_UDEC 4, eax
    push c
    call toarray
    mov [lenc], eax
    
    ;умножение
    push a
    push b
    push dword[lena]
    push dword[lenb]
    call mult
    
    
    ;последние 30 цифр числа
    mov ecx, 80
.print:
    PRINT_DEC 4, [answ + ecx*4]
    ;PRINT_CHAR ','
    inc ecx
    cmp ecx, 100
    jl .print    
    NEWLINE
    ;PRINT_DEC 4, eax
    
    
    
    GET_UDEC 4, ebx
    GET_UDEC 4, ecx
    
    add esp, 28
    
    xor eax, eax
    ret
    
    
;Заполняет массив цифрами числа
;Получает на вход указатель на массив
;Возвращает кол-во эл-в массива
toarray:
    push ebp
    mov ebp, esp
    
    push edi
    push ebx  ;указатель на массив
    push esi  ;счетчик
    mov ebx, [ebp+8]
    
    ;число не кладем на стек, т.к. оно уже на регистре eax
    mov edi, 99  ;индексация массива с числом
    mov ecx, 10
    xor esi, esi
.for:
    cdq
    idiv ecx
    inc esi
    mov dword[ebx + edi*4], edx  ;заполнение массива цифрами числа,
                                 ;начиная с последнего числа
    dec edi
    test eax, eax
    jnz .for
    
    mov eax, esi
    
    pop esi
    pop ebx
    pop edi
    
    mov esp, ebp
    pop ebp
    
    ret
    
   
;Умножение двух массивов 
;На стеке лежат указатели на массивы и длины массивов
;+8 - len2
;+12 - len1
;+16 - 2 массив
;+20 - 1 массив
mult:
    push ebp
    mov ebp, esp
    
    push ebx
    push edi  ;i
    push esi  ;j
    
    ;тут лежат индексы, до которых надо умножать
    neg dword[ebp+8]
    add dword[ebp+8], 99
    neg dword[ebp+12]
    add dword[ebp+12], 99 

    ;_____
    ;умножение в столбик
    mov edi, 99
.for1:
    xor eax, eax  ;остаток
    mov esi, 99
.for2:
    ;индекс результирующего массива
    mov ecx, esi
    sub ecx, 99
    add ecx, edi
    
    ;a[j]*b[i] + ost
    mov edx, [ebp + 16]
    mov ebx, dword[edx + esi*4]
    mov edx, [ebp + 20]
    imul ebx, dword[edx + edi*4]
    add eax, ebx
    
    cdq
    idiv dword[const] 
    add dword[answ + ecx*4], edx
    
    dec esi
    cmp esi, [ebp+8]
    jge .for2
    
    dec edi
    cmp edi, [ebp+12]
    jge .for1
    ;_____
    
    ;после ужножения приводим массив к нужному виду
    ;(т.к. могут быть двузн. числа в элементах массива)
    mov edi, 99
.for3:
    mov eax, [answ + edi*4]
    cdq
    idiv dword[const]
    add [answ + edi*4 - 4], eax
    mov [answ + edi*4], edx
    
    dec edi
    test edi, edi
    jnz .for3  
    
    pop esi
    pop edi
    pop ebx
    
    mov esp, ebp
    pop ebp
    
    ret