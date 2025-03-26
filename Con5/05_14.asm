extern printf
extern malloc, free
extern fopen, fscanf, fprintf, fclose

;смещения в структуре
;struct list
;  int value
;  struct list *next
VALUE equ 0
NEXT equ 4

section .rodata
    st db `%d `, 0
    er db `error`, 0
    
    open1 db `input.txt`, 0
    read1 db `r`, 0
    
    open2 db `output.txt`, 0
    read2 db `w`, 0
    
    
section .bss
    file resd 1  ;указатель на файл
    n resd 1  ;временная переменная для считывания числа из файла
    head resd 1  ;указатель на голову списка

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
    
    ;считывание чисел из файла 
.while:
    mov eax, [file]
    mov [esp], eax
    mov dword[esp+4], st
    mov dword[esp+8], n
    call fscanf
    
    cmp eax, 1  ;пока считали число
    jnz .go
    ;head=add_elem(head, n)
    mov eax, [head]
    mov dword[esp], eax
    mov eax, [n]
    mov [esp+4], eax
    call add_elem
    mov [head], eax
    jmp .while
    
    ;сортировка списка
.go:
    mov eax, [head]
    mov dword[esp], eax
    call sort
    
    ;зыкрываем первый файл
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
    
    ;запись списка в файл
    mov eax, [head]
    mov [esp], eax
    mov eax, [file]
    mov [esp+4], eax
    mov dword[esp+8], st
    call print_list
    
    ;зыкрываем второй файл
    mov eax, [file]
    mov [esp], eax
    call fclose  
    
    ;удаление списка
    mov eax, [head]
    mov [esp], eax
    call del_list
    
    jmp .return
    ;на случай нулевого указателя    
.error:
    mov dword[esp], er  ;ошибка открытия/памяти
    call printf
.return:    
    add esp, 16
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret
    


;Добавление элемента в начало списка
;Получает указатель на голову и значение ключа
;Возвращает указатель на новую голову
add_elem:
    push ebp
    mov ebp, esp
    
    sub esp, 8  ;выравнивание стека
    
    mov ecx, [ebp+8]  ;head
    mov edx, [ebp+12]  ;value
    
    sub esp, 16
    mov dword[esp], 8
    call malloc  ;выделение памяти
    add esp, 16
    test eax, eax
    jz .error  ;нулевой указатель, память не выделена
    
    mov ecx, [ebp+12]
    mov [eax+VALUE], ecx  ;node->value=value
    mov edx, [ebp+8]
    mov [eax+NEXT], edx  ;node->next=head

    jmp .return
.error:  
    mov eax, [ebp+8]  ;старый указатель
.return:
    add esp, 8
    mov esp, ebp
    pop ebp
    ret
    
    
    
;Печать списка в файл
;Получает указатель на голову списка, файл и строку печати
print_list:
    push ebp
    mov ebp, esp
    
    sub esp, 24  ;выравнивание стека

.while:   
    mov eax, [ebp+8]  ;head
    test eax, eax
    jz .return  ;head==0
    
    mov edx, [eax+VALUE]
    
    mov ecx, [ebp+12]  ;file
    mov [esp], ecx
    mov ecx, [ebp+16]  ;"%d "
    mov [esp+4], ecx
    mov [esp+8], edx  ;head->value
    call fprintf  ;печать
    
    mov eax, [ebp+8]
    mov eax, [eax+NEXT]
    mov [ebp+8], eax  ;head=head->next
    jmp .while

.return:
    add esp, 24   
    mov esp, ebp
    pop ebp
    ret
    
    
   
;Удаление списка
;Получает указатель на голову списка 
del_list:
    push ebp
    mov ebp, esp
    
    sub esp, 24  ;выравнивание стека
    
.while:    
    mov eax, [ebp+8]  ;head
    test eax, eax
    jz .return  ;head==0
    
    mov ecx, eax  ;node=head (ebp-4)
    mov eax, [eax+NEXT]
    mov [ebp+8], eax  ;head=head->next
    
    mov [esp], ecx
    call free  ;free(node)
    jmp .while

.return:   
    add esp, 24
    mov esp, ebp
    pop ebp
    ret
    
    
  
;Нахождение минимального эл-та списка, начиная с заданного
;Получает указатель на элемент списка 
;Возвращает указатель на минимальный эл-т 
find_min:
    push ebp
    mov ebp, esp
    
    sub esp, 8  ;выравнивание стека
    
    mov eax, [ebp+8]  ;head
    mov eax, [eax+NEXT]
    mov [ebp-4], eax  ;next=head->next
    
.while:
    mov eax, [ebp-4]  ;next
    test eax, eax
    jz .return  ;next==0
    
    mov eax, [eax+VALUE]  ;next->value
    mov ecx, [ebp+8]
    mov ecx, [ecx+VALUE]  ;head->value
    cmp eax, ecx
    jge .continue  ;next->value >= head->value
    
    mov eax, [ebp-4]
    mov [ebp+8], eax  ;head=next
.continue:
    mov eax, [ebp-4]
    mov eax, [eax+NEXT]
    mov [ebp-4], eax  ;next=next->next
    jmp .while
    
.return:
    mov eax, [ebp+8]  ;return head
    add esp, 8
    mov esp, ebp
    pop ebp
    ret
    
    

;Сортировка списка, перемещением минимального эл-та в начало
;Получает указатель на голову списка  
sort:
    push ebp
    mov ebp, esp
    
    sub esp, 24  ;выравнивание стека
.while:
    mov eax, [ebp+8]  ;head
    test eax, eax
    jz .return  ;head==0
    
    mov [esp], eax
    call find_min
    mov [ebp-4], eax  ;minnode=find_min(head)
    
    cmp eax, [ebp+8]
    jz .go  ;minnode==head
    
    ;меняем minnode->value и head->value
    mov eax, [eax+VALUE]  ;minnode->value
    mov ecx, [ebp+8]
    mov ecx, [ecx+VALUE]  ;head->value
    ;смена
    mov edx, [ebp-4]
    mov [edx+VALUE], ecx
    mov edx, [ebp+8]
    mov [edx+VALUE], eax
.go:
    mov eax, [ebp+8]
    mov eax, [eax+NEXT]
    mov [ebp+8], eax  ;head=head->next
    jmp .while
    
.return:
    add esp, 24
    mov esp, ebp
    pop ebp
    ret