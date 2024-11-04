main:
    NOP
    MOV R1, #0x1111 
    MOV R2, #0x1111
    CMP R1, R2, R1
    B.eq label
    NOP
    NOP
    NOP
    NOP

label:
    CLR R2
    MOV R2, #0x1111
    CMP R2, R2, #0x2111
    B.mi   main 
    CLR R2
    NOP
    NOP
    NOP
    NOP
end:
    NOP
    HALT