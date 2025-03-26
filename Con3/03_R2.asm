extern io_get_udec, io_print_udec, io_newline

section .text

global main
main:
    mov ebp, esp; for correct debugging
    call    io_get_udec

    mov     ebx, eax
    dec     ebx
    xor     eax, ebx
    add     eax, 1
    rcr     eax, 1

    call    io_print_udec
    call    io_newline

    xor     eax, eax
    ret