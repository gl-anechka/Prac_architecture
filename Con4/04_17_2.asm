%include 'io.inc'

MAXSIZE EQU 40

section .bss
    a resd MAXSIZE
    lena resd 1
    
    b resd MAXSIZE
    lenb resd 1
    
    c resd MAXSIZE
    lenc resd 1
    
    temp resd MAXSIZE
    answ resd MAXSIZE
    
section .data
    const dd 10

section .text
global main
global toarray
global mult
main:
    mov ebp, esp; for correct debugging
    GET_UDEC 4, eax
    GET_UDEC 4, esi
    GET_UDEC 4, edi
    
    test eax, eax
    jz .null
    test esi, esi
    jz .null
    test edi, edi
    jz .null
    
    ;заполенение массивов
    push a
    call toarray
    mov [lena], eax
    
    mov eax, esi
    push b
    call toarray
    mov [lenb], eax
    
    mov eax, edi
    push c
    call toarray
    mov [lenc], eax
    
    ;умножение (a*b)
    push temp
    push a
    push b
    push dword[lena]
    push dword[lenb]
    call mult
    
    ;длина временного массива (a*b)
    mov ebx, [lena]
    add ebx, [lenb]
    
    ;умножение ((a*b)*c)
    push answ
    push temp
    push c
    push ebx
    push dword[lenc]
    call mult
    
    ;печать ответа без ведущих нулей
    xor ecx, ecx
.do:
    mov ebx, [answ + ecx*4]
    test ebx, ebx
    jnz .for
    inc ecx
    jmp .do

.for:    
    PRINT_DEC 4, [answ + ecx*4]
    inc ecx
    cmp ecx, MAXSIZE
    jl .for    
    
    add esp, 52
    jmp .return

.null:
    PRINT_DEC 4, 0  ;хотя бы один из множителей 0

.return:   
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
    mov edi, MAXSIZE  ;индексация массива с числом
    dec edi
    mov ecx, 10
    xor esi, esi
.for:
    xor edx, edx
    div ecx
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
;+24 - результирующий массив
mult:
    push ebp
    mov ebp, esp
    
    push ebx
    push edi  ;i
    push esi  ;j
    
    ;тут лежат индексы, до которых надо умножать
    neg dword[ebp+8]
    add dword[ebp+8], MAXSIZE
    dec dword[ebp+8]
    neg dword[ebp+12]
    add dword[ebp+12], MAXSIZE
    dec dword[ebp+12] 

    ;_____
    ;умножение в столбик
    mov edi, MAXSIZE
    dec edi
.for1:
    xor eax, eax  ;остаток
    mov esi, MAXSIZE
    dec esi
.for2:
    ;индекс результирующего массива
    mov ecx, esi
    sub ecx, MAXSIZE
    inc ecx
    add ecx, edi
    
    xchg eax, ebx
    
    ;a[j]*b[i] + ost
    mov edx, [ebp + 16]
    mov eax, dword[edx + esi*4]
    mov edx, [ebp + 20]
    mul dword[edx + edi*4]
    add ebx, eax
    
    xchg eax, ebx
    
    xor edx, edx
    div dword[const] 
    mov ebx, [ebp+24]
    add dword[ebx + ecx*4], edx
    
    dec esi
    cmp esi, [ebp+8]
    jge .for2
    
    dec edi
    cmp edi, [ebp+12]
    jge .for1
    ;_____
    
    ;после ужножения приводим массив к нужному виду
    ;(т.к. могут быть двузн. числа в элементах массива)
    mov edi, MAXSIZE
    dec edi
    mov ebx, [ebp+24]
.for3:
    mov eax, [ebx + edi*4]
    xor edx, edx
    div dword[const]
    add dword[ebx + edi*4 - 4], eax
    mov dword[ebx + edi*4], edx
    
    dec edi
    test edi, edi
    jnz .for3  
    
    pop esi
    pop edi
    pop ebx
    
    mov esp, ebp
    pop ebp
    
    ret