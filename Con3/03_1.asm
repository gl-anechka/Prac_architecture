%include 'io.inc'

MIN_VAl equ -2147483648

section .bss
    n resd 1
 
section .data
    max1 dd MIN_VAl
    max2 dd MIN_VAl
    max3 dd MIN_VAl

section .text
global main
main:
    GET_DEC 4, n
    mov ecx, [n]  ;счетчик
    
.do:
    GET_DEC 4, ebx
    
    cmp ebx, [max1]
    jge .big  ;получили самое большое число
    
    cmp ebx, [max2]
    jge .avg  ;получили второе по величине число
    
    cmp ebx, [max1]
    jge .small  ;получили третье по величине число
    
.continue:
    dec ecx
    cmp ecx, 0
    jne .do
    
    jmp .end  ;конец цикла

.big:
    mov edx, [max2]
    mov [max3], edx
    mov edx, [max1]
    mov [max2], edx
    mov [max1], ebx   
    jmp .continue  ;обратно
    
.avg:
    mov edx, [max2]
    mov [max3], edx
    mov [max2], ebx    
    jmp .continue  ;обратно
    
.small:
    mov [max3], ebx
    jmp .continue  ;обратно
    
.end:
    PRINT_DEC 4, [max1]
    PRINT_CHAR ' '
    PRINT_DEC 4, [max2]
    PRINT_CHAR ' '
    PRINT_DEC 4, [max3]
    
    xor eax, eax
    ret