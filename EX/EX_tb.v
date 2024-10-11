// Testbench for Windows SCC Execute Stage
// Includes all of the testing for the ALU Instructions and Special Instructions

module EX_tb();

    // All of the inputs to the Execute stage (driven by the outputs of the Decode stage)
    reg [1:0]        1LD_s;                    
    reg              Special_encoding_s;
    reg [3:0]        2LD_s;
    reg [2:0]        ALU_OC_s;
    reg [3:0]        B_cond_s;
    reg [2:0]        dest_reg_s;
    reg [2:0]        pointer_reg_s;
    reg [2:0]        op_1_reg_s;
    reg [2:0]        op_2_reg_s;
    reg [15:0]       immediate_s;
    reg [15:0]       offset_s;
    reg [3:0]        flags_s;

    // All of the outputs of the Execute stage (drives the inputs of the Memory stage)
    wire [0:0]        ;
    wire [0:0]        ;
    wire [0:0]        ;
    wire [0:0]        ;