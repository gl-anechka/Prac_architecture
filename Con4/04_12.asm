%include 'io.inc'

section .bss
    x1 resd 1
    y1 resd 1
    x2 resd 1
    y2 resd 1
    x3 resd 1
    y3 resd 1
    n resd 1

section .text
global main
global square
global nod
main:
    push ebp
    mov ebp, esp
    
    GET_DEC 4, x1
    GET_DEC 4, y1
    GET_DEC 4, x2
    GET_DEC 4, y2
    GET_DEC 4, x3
    GET_DEC 4, y3
    
    mov eax, [x1]
    sub eax, [x2]
    mov ebx, [x1]
    sub ebx, [x3]
    mov ecx, [x2]
    sub ecx, [x3]
    mov [x1], eax  ;x1-x2
    mov [x2], ebx  ;x1-x3
    mov [x3], ecx  ;x2-x3
    
    mov eax, [y1]
    sub eax, [y2]
    mov ebx, [y1]
    sub ebx, [y3]
    mov ecx, [y2]
    sub ecx, [y3]
    mov [y1], eax  ;y1-y2
    mov [y2], ebx  ;y1-y3
    mov [y3], ecx  ;y2-y3
    
    ;считаем площадь треугольника
    push dword[x1]
    push dword[x2]
    push dword[y1]
    push dword[y2]
    call square
    mov ebx, eax
    add esp, 16
    
    ;считаем кол-во точек на гранях
    push dword[x1]
    push dword[y1]
    call nod
    mov [n], eax
    add esp, 8
    
    push dword[x2]
    push dword[y2]
    call nod
    add [n], eax
    add esp, 8
    
    push dword[x3]
    push dword[y3]
    call nod
    add [n], eax
    add esp, 8
    
    ;формула Пика: S = В + Г/2 - 1
    ;тогда искомая величина: В = (2S + 2 - Г) / 2
    ;Г = НОД(|x2 - x1|, |y2 - y1|)
    mov eax, ebx  ;тут лежит площадь
    add eax, 2
    sub eax, [n]
    cdq
    mov ecx, 2
    idiv ecx
    
    PRINT_DEC 4, eax
    
    ;add esp, 40
    mov esp, ebp
    pop ebp
    
    xor eax, eax
    ret
    
    
;Площадь треугольника через определитель
square:
    push ebp
    mov ebp, esp
    
    ;2*S=(x2-x1)*(y3-y1) - (x3-x1)*(y2-y1)
    mov eax, [ebp+8]
    mov edx, [ebp+20]   
    imul eax, edx
    
    mov ecx, [ebp+12]
    mov edx, [ebp+16]
    imul ecx, edx
    
    sub eax, ecx
    
    ;|S|
    mov edx, eax
    sar edx, 31
    xor eax, edx
    sub eax, edx
    
    mov esp, ebp
    pop ebp
    
    ret
    
    
;НОД(a, b)
nod:
    push ebp
    mov ebp, esp
    
    mov eax, [ebp+8]
    mov ecx, [ebp+12]
    
    ;будем работать с модулями разности
    mov edx, eax
    sar edx, 31
    xor eax, edx
    sub eax, edx
    
    mov edx, ecx
    sar edx, 31
    xor ecx, edx
    sub ecx, edx
    
    cmp eax, ecx
    jg .continue
    xchg eax, ecx
    
.continue:  
    ;if (b == 0 || a == b) -> return
    test ecx, ecx
    jz .return   
    cmp eax, ecx
    je .return
    
    ;алгоритм Евклида
    jg .iter
    xchg eax, ecx
.iter:
    cdq
    idiv ecx
    mov eax, ecx
    mov ecx, edx
    jmp .continue

.return:    
    mov esp, ebp
    pop ebp
    
    ret