%include 'io.inc'

section .bss
    n resd 1
    k resb 1

section .data
    max dd 0

section .text
global main
main:
    GET_UDEC 4, n
    GET_DEC 1, k
    
    ;ebx <- маска - k подряд идущих бит
    mov ebx, 1
    shl ebx, 31  ;1 в старший разряд
    
    mov cl, [k]
    dec cl
    sar ebx, cl  ;k 1 в старших разрядах
    
    neg cl
    add cl, 31
    shr ebx, cl  ;k 1 в младших разрядах
    
    mov ecx, 0  ;i
.for:
    mov eax, [n]  ;временная переменная
    and eax, ebx
    shr eax, cl  ;(маска & n) >> i
    
    cmp eax, [max]
    jg .change  ;если получили число больше
.back:    
    shl ebx, 1  ;сдвигаем маску
    
    inc ecx
    cmp ecx, 33
    jne .for
    jmp .end
    
.change:
    mov [max], eax
    jmp .back
    
.end:
    PRINT_UDEC 4, [max]
    
    xor eax, eax
    ret