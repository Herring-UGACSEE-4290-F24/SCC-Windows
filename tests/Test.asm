main:
    ADD R0, R0, #5
    SUB R1, R0, #6
    MOV R0, #0
    B main
    MOV R0, #0
    NOP
    BR R0
    HALT