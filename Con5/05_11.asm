extern printf
extern malloc, free
extern fopen, fscanf, fprintf, fclose

;смещения в структуре
;struct list
;  int value
;  struct list *prev
;  struct list *next
VALUE equ 0
PREV equ 4
NEXT equ 8

section .rodata
    readf db `%d %d`, 0
    
    open1 db `input.txt`, 0
    read1 db `r`, 0
    
    open2 db `output.txt`, 0
    read2 db `w`, 0
    
    pr db `%d `, 0
    prer db `error`, 0
    
section .bss
    file resd 1  ;указатель на файл
    
    n resd 1
    m resd 1
    
    left resd 1
    right resd 1
    
    pointers resd 1200000  ;массив указателей на эл-ты списка
    head resd 1  ;указатель на голову списка
    now resd 1  ;обрабатываемый элемент
    prev resd 1  ;предыдущий обрабатываемый

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
    
    
    ;считываем из файла n и m
    mov eax, [file]
    mov dword[esp], eax
    mov dword[esp+4], readf
    mov dword[esp+8], n
    mov dword[esp+12], m
    call fscanf
    
    
    ;выделение памяти под список
    mov eax, [n]
    imul eax, 12  ;n * размер структуры
    
    mov [esp], eax
    call malloc
    test eax, eax
    jz .error  ;если память не выделена
    
    mov [head], eax
    mov [now], eax
    
    
    ;выделение памяти на все эл-ты списка
    xor esi, esi  ;i
.for1:
    ;создание очередного звена
    mov ebx, [now]
    mov [ebx+VALUE], esi  ;now->value=i
    mov ecx, [prev]
    mov [ebx+PREV], ecx  ;now->prev=prev
    mov dword[esp], 12  ;размер структуры
    call malloc
    test eax, eax
    jz .error
    mov [ebx+NEXT], eax  ;now->next=malloc()
    
    mov [prev], ebx
    mov [pointers+esi*4], ebx  ;сохраняем указатель на эл-т в массив
    
    mov eax, [n]
    dec eax
    cmp esi, eax
    jge .else
    mov ebx, [ebx+NEXT]
    mov [now], ebx  ;now=now->next
    jmp .continue
.else:  ;последнее звено
    mov eax, [now]
    mov eax, [eax+NEXT]
    mov dword[esp], eax  ;free(now->next)
    call free
    
    mov eax, [now]
    mov ecx, [head]
    mov [eax+NEXT], ecx  ;now->next=head
    
    mov eax, [now]
    mov [ecx+PREV], eax  ;head->prev=now
.continue:    
    inc esi
    cmp esi, [n]
    jl .for1

    ;add esp, 16
    ;jmp .return
    
    ;перемещение частей списка
    mov ebx, [now]
    xor esi, esi
.for2:
    mov eax, [file]
    mov dword[esp], eax
    mov dword[esp+4], readf
    mov dword[esp+8], left
    mov dword[esp+12], right
    call fscanf  ;считали перемещаемый кусок
    dec dword[left]
    dec dword[right]
    
    mov eax, [ebx+VALUE]
    cmp [right], eax
    jz .simple  ;кусок из конца списка => перемещаем в начало
    mov eax, [head]
    mov eax, [eax+VALUE]
    cmp eax, [left]
    jz .go
    
    ;нетривиальное перемещение ___
    
    ;перевязываем указатели вне куска
    ;poiters[left]->prev->next = poiters[right]->next
    mov ecx, [right]
    mov eax, [pointers+ecx*4]
    mov eax, [eax+NEXT]
    mov ecx, [left]
    mov edx, [pointers+ecx*4]
    mov edx, [edx+PREV]
    mov [edx+NEXT], eax
    ;poiters[right]->next->prev = poiters[left]->prev
    mov ecx, [left]
    mov eax, [pointers+ecx*4]
    mov eax, [eax+PREV]
    mov ecx, [right]
    mov edx, [pointers+ecx*4]
    mov edx, [edx+NEXT]
    mov [edx+PREV], eax
    
    ;перевязываем указатели куска
    ;pointers[left]->prev = head->prev
    mov eax, [head]
    mov eax, [eax+PREV]
    mov ecx, [left]
    mov edx, [pointers+ecx*4]
    mov [edx+PREV], eax
    ;head->prev->next = pointers[left]
    mov ecx, [left]
    mov edx, [pointers+ecx*4]
    mov eax, [head]
    mov eax, [eax+PREV]
    mov [eax+NEXT], edx
    ;pointers[right]->next = head
    mov ecx, [right]
    mov eax, [pointers+ecx*4]
    mov edx, [head]
    mov [eax+NEXT], edx
    ;head->prev = pointers[right]
    mov ecx, [right]
    mov eax, [pointers+ecx*4]
    mov edx, [head]
    mov [edx+PREV], eax
    
    ;новая голова списка
    mov ecx, [left]
    mov eax, [pointers+ecx*4]
    mov [head], eax 
    ;___
    jmp .go
    
    ;кусок из конца списка перемещаем в начало
.simple:
    mov ecx, [left]
    mov eax, [pointers+ecx*4]
    mov [head], eax  ;head=pointers[left]
    mov eax, [eax+PREV]
    mov ebx, eax  ;node=pointers[left]->prev    
.go:
    inc esi
    cmp esi, [m]
    jl .for2
    
    
    ;закрываем первый файл
    mov eax, [file]
    mov [esp], eax
    call fclose
    
    
    ;открываем файл на запись
    mov dword[esp], open2
    mov dword[esp+4], read2
    call fopen
    test eax, eax
    jz .error
    mov [file], eax
    
    ;запись итогового списка в файл
    xor esi, esi
.for3:
    mov ebx, [head]
    mov eax, [ebx+VALUE]
    inc eax  ;эл-т списка
    
    mov ecx, [file]
    mov dword[esp], ecx
    mov dword[esp+4], pr
    mov dword[esp+8], eax
    call fprintf  ;записываем в файл
    
    mov ebx, [ebx+NEXT]
    mov [head], ebx  ;head=head->next
    
    mov eax, [head]
    mov eax, [eax+PREV]
    mov [esp], eax
    call free  ;free(head->prev)
    
    inc esi
    cmp esi, [n]
    jl .for3
    
    jmp .return
    ;на случай нулевого указателя    
.error:
    sub esp, 16
    mov dword[esp], prer  ;ошибка открытия/памяти
    call printf
    add esp, 16
.return:    
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret