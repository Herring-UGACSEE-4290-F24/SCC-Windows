main:
    ADD R0, R0, #5
    SUB R1, R0, #6
    MOV R0, #0
    B label
    MOV R0, #0
    NOP
label:
    ADD R3, R1, #7
    NOP
    HALT