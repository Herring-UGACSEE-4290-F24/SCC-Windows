main:
    NOP
    MOV R0, #0xFFFF
    MOVT R0, #0xFFFF
    NOT R0, R0
    CLR R0
    ADD R0, R0, #0x1
    SET R1
    CLR R1
    ;str r0 ;here since it will 1
    LSL R1, R0, #0x2
    LSR R1, R1, #0x1
    ;str r1 ;here since it will be 2
    CMP R1, R1, #0x3      ;2-3 = -1 so Negative high
    b.mi labelmi
    NOP
    b failed
    NOP
    NOP
    NOP
labelmi: 
    MOV R0, #0xFFFB
    MOVT R0, #0xFFFF
    NOT R0, R0
    CLR R0
    MOV R0, #0x4
    ;str  r0 ;here should be 4
    AND R0, R0, #0xFFFF ;4 still
    ADDS R0, R0, R1  ;3
    b.ne labelne
    NOP
    b failed
    NOP
    NOP
    NOP
labelne:
    SUB R0, R0, #0x1
    MOV R2, #0x2
    ANDS R0, R0, R2     ;should be two still
    b.pl labelpl        ;since + should take
    NOP
    b failed
    NOP
    NOP
    NOP
    
labelpl:
    CLR R2
    CLR R1
    MOV R1, #0x1
    MOV R2, #0x1
    XORS R2, R2, R1
    b.eq labeleq
    NOP
    b failed
    NOP
    NOP
    NOP
labeleq:
    CLR R0
    CLR R1
    MOV R0, #0x4
    MOV R1, #0x8
    OR R1, R1, R0
    NOP
    XOR R1, R1, #0x4
    NOP
    ;str r1     ;should be 8
    CMP R1, R1, #0xA
    b.lt labellt
    NOP
    b failed
    NOP
    NOP
    NOP
labellt:
    mov R7, #0x1
    LSL R7, R7, #0x4
    ;str r7 ;should be 16
    MOV R1, #0xFFFF
    MOVT R1, #0x7FFF
    ADDS R1, R1, #0x10
    b.vs labelvs
    NOP
    b failed

labelvs:
    CLR R1
    MOV R1, #0x10
    ADD R1, R1, R1
    ;str r1 ;since it will be 32



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
    NOP
    HALT


    
