main:
    NOP
    MOV R0, #0xFFFF
    MOVT R0, #0xFFFF
    NOT R0, R0

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
    MOV R0, 0xFFFB
    MOVT R0, 0xFFFF
    NOT R0, R0
    ;str  r0 here should be 4
    AND R0, 0xFFFF ;4 still
    ADDS R0, R0, R1  ;3
    b.ne labelne
    b failed
    NOP
    NOP
    NOP
labelne:
    SUB R0, R0, #1
    MOV R2, #2
    ANDS R0, R0, R2     ;should be two still
    b.pl labelpl        ;since + should take
    b failed
    NOP
    NOP
    NOP
    
labelpl:
    CLR R2
    MOV R1, #0
    XORS R2, R2, R1
    b.eq labeleq
    b failed
    NOP
    NOP
    NOP
labeleq:
    MOV R0, #4
    MOV R1, #8
    OR R1, R1, r0
    XOR R1, R1, #4
    ;str r1     should be 8
    CMP R1, R1, #10
    b.lt labellt
    b failed
    NOP
    NOP
    NOP
labellt:
    mov R7, #1
    LSL R7, #4
    ;str r7 should be 16
    MOV R1, #0xFFFF
    MOVT R1, #0x7FFF
    ADDS R1, R1, #0x10
    b.vs labelvs
    b failed

labelvs:
    CLR R1
    MOV R1, #16
    ADD, R1, R1, R1
    ;str r1 since it will be 32



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


    
