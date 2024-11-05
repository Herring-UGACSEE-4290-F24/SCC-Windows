main:
    NOP
    MOV R0, #0xFFFF
    MOVT R0, #0xFFFF
    NOT R0, R0
label1:
    ADD R0, R0, #1
    SET R1
    CLR R1
    ;store r0 here since it will 1
    LSL R1, R0, #2
    LSR R1, R1, #1
    ;store r1 here since it will be 2
    CMP R1, R1, #3      ;2-3 = -1 so Negative high
    b.mi labelmi
    b failed
    NOP
    NOP
    NOP
labelmi: 



    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
failed:
HALT


    
