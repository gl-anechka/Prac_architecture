%include 'io.inc'

extern scanf, printf, fprintf
extern malloc, free

section .rodata
    st db `%d`, 0
    pr db `%d\n`, 0
    er db `error`, 0    
    
section .bss
    n resd 1  ;временная переменная для считывания числа из файла
    k resd 1  ;кол-во чисел
    arr resd 1  ;указатель на массив
    stdout resd 1  ;указатель на поток вывода

section .text
global main
main:
    push ebp
    mov ebp, esp
    and esp, 0xFFFFFFF0
    
    sub esp, 16
    
    ;получаем кол-во чисел
    mov dword[esp], st
    mov dword[esp+4], k
    call scanf
    
    ;выделение памяти для массива
    mov eax, [k]
    imul eax, 4  ;требуемый размер
    mov [esp], eax
    call malloc
    test eax, eax
    jz .error
    mov [arr], eax
    
    ;считывание чисел в массив
    xor esi, esi
.for:
    mov dword[esp], st
    mov dword[esp+4], n
    call scanf  ;считали очередное число
    
    mov eax, [arr]
    mov ecx, [n]
    mov [eax+esi*4], ecx  ;записали число в массив
    
    inc esi
    cmp esi, [k]
    jl .for
    
    call get_stdout
    mov [stdout], eax
    
    sub esp, 16
    
    ;вызов ф-ии из условия
    mov eax, [arr]
    mov [esp], eax  ;первый параметр
    mov eax, [k]
    mov [esp+4], eax  ;второй параметр
    mov dword[esp+8], fprintf  ;третий параметр
    mov dword[esp+12], 2  ;четвертый параметр
    mov dword[esp+16], stdout  ;пятый параметр
    mov dword[esp+20], pr  ;шестой параметр
    call apply
    
    jmp .return
    
.error:
    mov dword[esp], er  ;ошибка памяти
    call printf
.return:    
    add esp, 32
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret
    
    
  
; apply(int* array, size_t length, void (*fn) (...), int n, ...)  
;стек уже выровнян по 16 байт
;лежит 3 параметра, потом n и затем n параметров (они идут первыми в ф-ию fn)
;всего n+4 параметра на стеке
;перед вызовом ф-ии fn надо отступить на стеке место для n+1 параметра
;остальные параметры ф-ии сохранять не надо, т.к. они и так на стеке, просто потом вернемся в исходное положение
;единственно, что надо сохранить - номер обрабатываемого эл-та массива
apply:
    push ebp
    mov ebp, esp
    
    ;mov eax, [ebp+8]  ;массив
    ;mov ecx, [ebp+20]  ;n
    
    xor ecx, ecx  ;счетчик эл-ов массива
.for:
    push ecx  ;сохранили значение счетчика
    
    ;___ кладем параметры на стек
    mov eax, [ebp+8]  ;начало массива
    mov eax, [eax+ecx*4]  ;n-ый эл-т массива
    push eax
    
    mov edx, [ebp+20]  ;счетчик 
.put:
    mov eax, [ebp+edx*4+20]  ;параметры (в обратном порядке)
    push eax
    
    dec edx
    test edx, edx
    jnz .put
    ;___
    
    ;mov eax, [ebp+16]  ;указатель на функцию
    ;call eax
    call fprintf
    
    mov eax, [ebp+20]
    inc eax
    imul eax, 4
    add esp, eax  ;восстановили стек
    
    pop ecx  ;восстановили значение счетчика
    
    inc ecx
    cmp ecx, [ebp+12]  ;length
    jl .for
    
    mov esp, ebp
    pop ebp
    ret