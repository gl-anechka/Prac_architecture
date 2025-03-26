extern scanf, printf
extern malloc, free

MIN_TR equ -10000000

section .rodata
    sk db `%d`, 0
    prm db `%d `, 0
    prn db `\n`, 0
    prer db `no free memory`, 0
    
section .data
    max_tr dq MIN_TR  ;максим. след
    
section .bss
    n resd 1  ;кол-во матриц
    tr resq 1  ;текущий след
    max_size resd 1  ;размер матрицы с макс. следом
    size resd 1  ;текущий размер
    max_m resd 1  ;указатель на матрицу с макс. следом
    m resd 1  ;указатель на текущую матрицу

section .text
global main
main:
    push ebp
    mov ebp, esp
    and esp,  0xFFFFFFF0
    
    sub esp, 16  ;освобождаем место на стеке
    mov dword[esp], sk
    mov dword[esp+4], n
    call scanf  ;получили кол-во матриц
    
    ;СЧИТЫВАНИЕ МАТРИЦ
    mov esi, 0
.for1:    
    mov dword[esp], sk
    mov dword[esp+4], size
    call scanf  ;получили размер текущей матрицы
    
    ;выделение памяти
    mov eax, [size]
    imul eax, [size]
    imul eax, 4
    mov [esp], eax  ;на стек кладем требуемый размер
    call malloc
    test eax, eax
    jz .error  ;если нулевой указатель
    mov dword[m], eax  ;указатель на матрицу
    
    ;обнуляем след
    mov dword[tr], 0
    mov dword[tr+4], 0
    
    ;заполнение матрицы и подсчет следа
    mov edi, 0
.for2:
    mov ebx, 0
.for3:
    mov eax, edi
    imul eax, [size]
    add eax, ebx
    imul eax, 4
    add eax, [m]
    mov dword[esp], sk
    mov dword[esp+4], eax  ;указатель на эл-т матрицы
    call scanf  ;считываем очередной эл-т матрицы
    
    cmp edi, ebx
    jnz .continue  ;не главная диагональ -> пропускаем
    
    mov eax, edi
    imul eax, [size]
    add eax, ebx
    imul eax, 4
    add eax, [m]
    mov eax, [eax]  ;значение эл-та
    cdq
    add dword[tr], eax  ;увеличиваем значение следа
    adc dword[tr+4], edx
    
.continue:    
    inc ebx
    cmp ebx, [size]
    jl .for3
    
    inc edi
    cmp edi, [size]
    jl .for2
    
    ;сравнение на максимальный след   
    mov eax, [max_tr]
    mov edx, [max_tr+4]
    sub eax, [tr]
    sbb edx, [tr+4]
    
    jge .free_matrix  ;матрица имеет меньший след
    mov eax, [max_m]
    mov dword[esp], eax
    call free
    
    ;сохраняем новую матрицу
    mov eax, [size]
    mov [max_size], eax
    mov eax, [tr]
    mov [max_tr], eax
    mov eax, [tr+4]
    mov [max_tr+4], eax
    mov eax, [m]
    mov [max_m], eax
    jmp .go
.free_matrix:    
    mov eax, [m]
    mov dword[esp], eax
    call free
.go:   
    inc esi
    cmp esi, [n]
    jl .for1
    
    mov eax, [max_m]
    test eax, eax
    jz .error
    
    ;ВЫВОД ИСКОМОЙ МАТРИЦЫ
    mov esi, 0
.for4:
    mov edi, 0
.for5:
    mov dword[esp], prm
    mov eax, esi
    imul eax, [max_size]
    add eax, edi
    imul eax, 4
    add eax, [max_m]
    mov eax, [eax]  ;разыменование
    mov dword[esp+4], eax
    call printf

    inc edi
    cmp edi, dword[max_size]
    jl .for5
    
    mov dword[esp], prn
    call printf
    
    inc esi
    cmp esi, dword[max_size]
    jl .for4
    
    mov eax, [max_m]
    mov dword[esp], eax
    call free  ;освобождение памяти

    jmp .return
    
.error:   
    mov dword[esp], prer 
    call printf
.return:   
    add esp, 16
    
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret