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
    ADD R2, R2, R2
    CLR R2

end:
    NOP
    HALT