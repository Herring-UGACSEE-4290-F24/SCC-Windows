module EX(1LD, Special_encoding, 2LD, ALU_OC, B_cond, dest_reg, pointer_reg, op_1_reg, op_2_reg, immediate, offset, flags )


    //just the outputs of decode 
    input wire [1:0]        1LD;                    
    input wire              Special_encoding;
    input wire [3:0]        2LD;
    input wire [2:0]        ALU_OC;
    input wire [3:0]        B_cond;
    input wire [2:0]        dest_reg;
    input wire [2:0]        pointer_reg;
    input wire [2:0]        op_1_reg;
    input wire [2:0]        op_2_reg;
    input wire [15:0]       immediate;
    input wire [15:0]       offset;
    input wire [3:0]        flags;


    // 3 Commands to implement Add_Immediate, Add_Regs, and NOP

