main:
    NOP
    MOV R1, #0xFFFF  
    MOVT R1, #0xFFFF ;R1 is 0x11111111
    MOV R2, #0x0       ;R2 is 0x0
    MOV R6, #0x1010
    MOV R7, #0x0101
    ANDS R6, R6, R7  ;R6 is 0x0000
    ADD R6, R6, R1
    NOT R6, R6           ;R6 is 1111...10000
    CLR R6
    CLR R7
    ADDS R1, R1, R2     ;negative 1 should set high and branch
    B.mi labelmi
    B failed
    NOP
    NOP
    NOP
labelmi:
    SET R7
    CLR R1
    SET R2 
    OR R2, R2, R1
    CMP R1, R1, R2      ;should set to zero
    B.eq labeleq
    B failed
    NOP
    NOP
    NOP
labeleq:
    SET R6          
    CLR R2
    MOV R2, #0xFFFF
    MOVT R2, #0xFFFF
    ADDS R2, R2, #1
    B.hs labelhs              ;should branch because carry high
    b failed
    NOP
    NOP
    NOP
labelhs:
    SET R5
    SET R1  
    MOV R2, #1
    ANDS R1, R1, R2
    B.ne labelne
    b failed

labelne:
    SET R4
    MOV R2, #0xFFFF
    MOVT R2, #0x7FFF
    ADDS R2, R2, #1
    b.vs labelvs
    b failed
    NOP
    NOP
    NOP
labelvs: 
    SET R3
    CLR R2
    MOV R2, #0xFFFF
    MOVT R2, #0x7FFF
    ADDS R2, R2, #1
    b.hi labelhi
    b failed
    NOP
    NOP
    NOP
labelhi:
    CLR R2
    SET R2
    MOV R1, #10
    CMP R1, R1, #1
    b.ge labelge
    b failed
    NOP
    NOP
    NOP
labelge:
    CLR R1
    SET R1
    MOV R0, #0x10
    CMP R0, R0, #0x12
    b.lt    labellt
    b failed
    NOP
    NOP
    NOP
labellt:
    CLR R0
    SET R0
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
    NOP
    NOP
    HALT