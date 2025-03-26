%include 'io.inc'

section .bss
    minx resd 1
    maxx resd 1
    
    miny resd 1
    maxy resd 1

section .text
global main
main:
    ;1 вершина
    GET_DEC 4, eax
    GET_DEC 4, ebx   
    mov dword[minx], eax
    mov dword[maxx], eax    
    mov dword[miny], ebx
    mov dword[maxy], ebx
    
    ;2-4 вершины
    mov ecx, 3
.read_and_comp:
    GET_DEC 4, eax
    GET_DEC 4, ebx
    cmp eax, [minx]
    jge .go1
    xchg eax, [minx]
.go1:
    cmp eax, [maxx]
    jle .go2
    xchg eax, [maxx]
.go2:    
    cmp ebx, [miny]
    jge .go3
    xchg ebx, [miny]
.go3:
    cmp ebx, [maxy]
    jle .go4
    xchg ebx, [maxy]
.go4:
    dec ecx
    cmp ecx, 0
    jne .read_and_comp

    ;точка P
    GET_DEC 4, eax  ;x
    GET_DEC 4, ebx  ;y
    
    cmp eax, [minx]
    jle .no
    cmp eax, [maxx]
    jge .no
    
    cmp ebx, [miny]
    jle .no
    cmp ebx, [maxy]
    jge .no
    
    PRINT_STRING 'YES'
    jmp .end
    
.no:
    PRINT_STRING 'NO'
.end:
       
    xor eax, eax
    ret