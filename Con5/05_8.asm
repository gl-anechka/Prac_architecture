extern printf, qsort
extern fopen, fclose, fprintf, fscanf
extern malloc, realloc, free

section .rodata
    sk db `%d`, 0
    pr db  `%d `, 0
    er db `error`, 0
    
    open1 db `input.txt`, 0
    read1 db `r`, 0
    
    open2 db `output.txt`, 0
    read2 db `w`, 0
    
section .bss
    n resd 1  ;текущая переменная
    file resd 1  ;указатель на файл
    m resd 1  ;указатель на массив
    
section .data
    zero dd 0
    plus dd 1
    minus dd -1

section .text
global main
main:     
    push ebp
    mov ebp, esp
    
    and esp, 0xFFFFFFF0
    
    sub esp, 16
    
    ;открываем файл на чтение
    mov dword[esp], open1
    mov dword[esp+4], read1
    call fopen
    test eax, eax
    jz .error
    mov [file], eax
    
    ;выделение одного эл-та массива
    mov esi, 0  ;кол-во эл-тов в массиве
    mov dword[esp], 0
    call malloc
    test eax, eax
    jz .error
    mov [m], eax
.for1:
    ;считываем очередной эл-т
    mov eax, [file]
    mov [esp], eax
    mov dword[esp+4], sk
    mov dword[esp+8], n
    call fscanf
    cmp eax, 0
    jl .continue  ;числа закончились
    
    ;перевыделение памяти
    inc esi
    mov eax, [m]
    mov [esp], eax  ;адрес начала массива
    mov eax, esi
    imul eax, 4
    mov [esp+4], eax  ;необходимый размер памяти
    call realloc
    test eax, eax
    jz .error  ;нулевой указатель
    mov [m], eax
    
    ;запись числа в массив
    mov ecx, [n]
    mov [eax+esi*4-4], ecx
    
    jmp .for1
.continue:
    ;закрываем файл на чтение
    mov eax, [file]
    mov [esp], eax
    call fclose

    ;сортировка массива
    mov eax, [m]
    mov [esp], eax  ;адрес начала массива
    mov [esp+4], esi  ;кол-во эл-тов массива
    mov dword[esp+8], 4  ;размер одного эл-та
    mov dword[esp+12], compare  ;указатель на функцию сравнения
    call qsort
    
    ;открываем файл на запись
    mov dword[esp], open2
    mov dword[esp+4], read2
    call fopen
    test eax, eax
    jz .error
    mov [file], eax
    
    ;запись чисел в файл
    xor edi, edi
.for2:
    mov eax, [file]
    mov [esp], eax  ;файл
    mov dword[esp+4], pr  ;строка
    mov eax, [m]
    mov eax, [eax+edi*4]
    mov [esp+8], eax  ;переменные
    call fprintf
    
    inc edi
    cmp edi, esi
    jl .for2
    
    ;закрываем файл на запись
    mov eax, [file]
    mov [esp], eax
    call fclose
    
    ;освобождаем память
    mov eax, [m]
    mov [esp], eax
    call free
    jmp .return
    
.error:
    mov dword[esp], er  
    call printf
.return:    
    add esp, 16
    mov esp, ebp
    pop ebp
     
    xor eax, eax
    ret
    
    
    
;Функция сортировки (для qsort)
compare:
    push ebp
    mov ebp, esp
    
    sub esp, 8  ;выравнивание стека
    
    mov eax, dword[ebp+8]
    mov eax, [eax]  ;a1
    
    mov ecx, dword[ebp+12]
    mov ecx, [ecx]  ;a2
    
    ;sub eax, ecx
    
    cmp eax, ecx
    cmovg eax, [plus]
    cmovl eax, [minus]
    cmovz eax, [zero]
    
    add esp, 8
    mov esp, ebp
    pop ebp
    
    ret