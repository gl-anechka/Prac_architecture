extern io_get_dec, io_print_udec, io_newline

section .text

global main
main:
    call      io_get_dec
    mov       ecx, eax

    mov       ebx, 1
    xor       eax, eax

.label:
    xor       eax, ebx
    xor       ebx, eax
    xor       eax, ebx

    add       ebx, eax
    loop      .label

    call      io_print_udec
    call      io_newline

    xor       eax, eax
    ret