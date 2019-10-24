%include "io.inc"
section .data
    a dq 1.0  
    b dq 5.0 
    c dq 4.0 
    four dq 4.0
    fmt db '%lf ',10,13,0 
section .bss
    x1 resq 1
    x2 resq 1
    dskr resq 1    
section .text
global CMAIN
CMAIN:
    mov ebp, esp
    finit 
    call Diskriminant
    fstp qword [dskr]
    fstp st0
    fstp st0
    fstp st0
    fstp st0
    fstp st0
    fstp st0
       
    push dword [dskr+4]
    push dword [dskr]
    push fmt
    call printf 
    add esp, 12  
    xor eax, eax
    ret
    
Roots:

ret

Diskriminant: 
    fld qword [a]
    fld qword [c]
    fmul st0, st1
    fld qword [four]
    fmul st0, st1
    fld qword [b]
    fld st0
    fmul st0, st1
    fsub st0, st2
    fsqrt
    ret
    

    