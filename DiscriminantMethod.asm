%include "io.inc"
section .data        ;Дискриминант:      <0     >0      =0
    a dq 1.0                            ;1.0   ;1.0    ;1.0
    b dq 5.0                            ;1.0   ;5.0    ;4.0
    c dq 4.0                            ;1.25  ;4.0    ;4.0
    ;four dq 4.0
    ;two dq 2.0
    fmtR1 db 'x1=%lf',10,0 
    fmtR2 db 'x2=%lf',10,0 
    fmtI1 db 'x1=%lf + i*%lf',10,0 
    fmtI2 db 'x2=%lf - i*%lf',10,0 
    
section .bss
    x1 resq 1
    x2 resq 1
    i resq 1
    ;dscr resq 1  
      
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    push dword 2
    push dword 4
    finit 
    call Discriminant
    xor eax, eax
    add esp, 8
    ret
    
RealRoots:
    fld qword [esp + 4]
    fld qword [b]
    fchs
    fadd st0, st1
    fld qword [a]
    fild dword [esp + 20]
    ;fld qword [two]
    fmul st1
    fxch st2
    fdiv st2
    fstp qword [x1]
    call Cleaning
    fld qword [esp + 4]
    fld qword [b]
    fchs
    fsub st0, st1
    fld qword [a]
    fild dword [esp + 20]
    ;fld qword [two]
    fmul st1
    fxch st2
    fdiv st2
    fstp qword [x2]
    ret

ImagineRoots:
    fld qword [b]
    fchs
    fld qword [a]
    fild dword [esp + 20]
    ;fld qword [two]
    fmul st1
    fxch st2
    fdiv st2
    fstp qword [x1]
    fld qword[esp + 4]
    fdiv st2
    fstp qword [i]
    ret
    
Discriminant: 
    fld qword [a]
    fld qword [c]
    fmul st0, st1
    fild dword [esp + 4]
    ;fld qword [four]
    fmul st0, st1
    fld qword [b]
    fld st0
    fmul st0, st1
    fsub st0, st2
    fldz
    fxch st1
    fcom st1 ; b^2 - 4ac > 0 ?
    fstsw ax
    sahf
    jb DiscrLess   ;если b^2 - 4ac < 0 
    ja DiscrMore   ;если b^2 - 4ac > 0 
    call Cleaning
    fld qword [a]
    fild dword [esp + 8]
    ;fld qword [two]
    fmul st1
    fld qword [b]
    fdiv st1
    fchs 
    fstp qword [x1]
    push dword [x1+4]
    push dword [x1]
    push fmtR1
    call printf 
    add esp, 12
    ret
 
    DiscrMore:
        fsqrt
        ;fstp qword [dscr]
        sub esp, 8
        fstp qword [esp]
        call Cleaning
        call RealRoots
        add esp, 8
        push dword [x1+4]
        push dword [x1]
        push fmtR1
        call printf 
        add esp, 12
        push dword [x2+4]
        push dword [x2]
        push fmtR2
        call printf 
        add esp, 12
        ret 
    DiscrLess:
        fchs
        fsqrt
        sub esp, 8
        fstp qword [esp]
        call Cleaning
        call ImagineRoots
        add esp, 8
        push dword [i+4]
        push dword [i]
        push dword [x1+4]
        push dword [x1]
        push fmtI1   
        call printf 
        add esp, 20
        push dword [i+4]
        push dword [i]
        push dword [x1+4]
        push dword [x1]
        push fmtI2   
        call printf 
        add esp, 20
        ret 
Cleaning:
    fstp st0
    fstp st0
    fstp st0
    fstp st0
    fstp st0
    ret
    

    