module SCC(clk, reset, in_mem, data_in, in_mem_addr, data_addr, data_out);

    input           clk;             // main clock signal
    input           reset;           // sets all regs to known state
    input [31:0]    in_mem;          // instructions being fetched
    input [31:0]    data_in;         // data read from memory    

    output [31:0]   in_mem_addr;     // address pointed to in instruction memory
    output          in_mem_en;       // enable instruction memory fetch
    output [31:0]   data_addr;       // address pointed to in data memory
    output [31:0]   data_out;        // data to write to memory

    //Decoder output declarations  (also used in execute as inputs)
    wire [1:0]        First_LD;                    
    wire              Special_encoding;
    wire [3:0]        Second_LD;
    wire [2:0]        ALU_OC;
    wire [3:0]        B_cond;
    wire [2:0]        dest_reg;
    wire [2:0]        pointer_reg;
    wire [2:0]        op_1_reg;
    wire [2:0]        op_2_reg;
    wire [15:0]       immediate;
    wire [15:0]       offset;
    wire [3:0]        flags;


    //Execute input and output declarations
    wire [31:0]       op_1_reg_value;
    wire [31:0]       op_2_reg_value;



    //Instatiate Module IF
    IF instruction_fetch(
    .clk(clk),
    .reset(reset), 
    .instruction(in_mem)
    );


    //Instatiate Module Decode
    ID instruction_decode( 
    .Instruction(in_mem), 
    .First_LD(First_LD), 
    .Special_encoding(Special_encoding),
    .Second_LD(Second_LD),
    .ALU_OC(ALU_OC),
    .B_cond(B_cond),
    .dest_reg(dest_reg), 
    .pointer_reg(pointer_reg),
    .op_1_reg(op_1_reg),
    .op_2_reg(op_2_reg),
    .immediate(immediate), 
    .flags(flags)
    );



    //Instatiate Reg File
     RegFile reg_file (
         .clk(clk), 
         .r_addr_0(op_1_reg), 
         .r_addr_1(op_2_reg), 
         .w_addr(dest_reg), 
         .w_enable(w_enable), 
         .w_select(w_select), 
         .w_alu(w_alu), 
         .w_id(w_id), 
         .r_val_0(op_1_reg_value), 
         .r_val_1(op_2_reg_value)
        );
    //Instatiate Module_Execute

    EX instruction_execute(
    .First_LD(First_LD), 
    .Special_encoding(Special_encoding),
    .Second_LD(Second_LD),
    .ALU_OC(ALU_OC),
    .B_cond(B_cond),
    .dest_reg(dest_reg), 
    .pointer_reg(pointer_reg),
    .op_1_reg_value(op_1_reg_value),
    .op_2_reg_value(op_2_reg_value),
    .immediate(immediate), 
    .offset(offset), 
    .flags(flags),
    .result(ALU_results)
    );

endmodule
