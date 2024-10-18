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
//    wire [1:0]        1LD;                    
//    wire              Special_encoding;
//    wire [3:0]        2LD;
//    wire [2:0]        ALU_OC;
//    wire [3:0]        B_cond;
//    wire [3:0]        dest_reg;
//    wire [2:0]        pointer_reg;
//    wire [3:0]        op_1_reg;
//    wire [3:0]        op_2_reg;
//    wire [15:0]       immediate;
//    wire [15:0]       offset;
//    wire [3:0]        flags;


    //Execute input and output declarations
//    wire [15:0]       op_1_reg_value
//    wire [15:0]       op_2_reg_value


    //Instatiate Module IF
    IF instruction_fetch(
    .clk(clk),
    .reset(reset), 
    .instruction(in_mem)
    );


    //Instatiate Module Decode
//    ID instruction_decode(
//    .clk(clk), 
//    .Instruction(Instruction), 
//    .Instruction_next(Instruction_next), 
//    .1LD(1LD), 
//   .Special_encoding(Special_encoding),
//    .2LD(2LD),
//   .ALU_OC(ALU_OC),
//    .B_cond(B_cond),
//    .dest_reg(dest_reg), 
//    .pointer_reg(pointer_reg),
//    .op_1_reg(op_1_reg),
//    .op_2_reg(op_2_reg),
//    .immediate(immediate), 
//    .offset(offset), 
//    .flags(flags)
//    );

    //Should access reg files depending on which regs use aka for now check ths msb of op_1_reg if high fetch from reg file and pass into execute
//    if(op_1_reg[3] == 0)
//        begin

//        end

//     if(op_2_reg[3] == 0)
//        begin

//        end


    //Instatiate Reg File
    // RegFile reg_file (
    //     .clk(clk), 
    //     .r_addr_0(r_addr_0), 
    //     .r_addr_1(r_addr_1), 
    //     .w_addr(w_addr), 
    //     .w_enable(w_enable), 
    //     .w_select(w_select), 
    //     .w_alu(w_alu), 
    //     .w_id(w_id), 
    //     .r_val_0(r_val_0), 
    //     .r_val_1(r_val_1)
    // );
    //Instatiate Module_Execute

    //EX instruction_execute(
    //.1LD(1LD), 
    //.Special_encoding(Special_encoding),
    //.2LD(2LD),
    //.ALU_OC(ALU_OC),
    //.B_cond(B_cond),
    //.dest_reg(dest_reg), 
    //.pointer_reg(pointer_reg),
    //.op_1_reg_value(op_1_reg_value),
    //.op_2_reg_value(op_2_reg_value),
    //.immediate(immediate), 
    //.offset(offset), 
    //.flags(flags),
    //.ALU_results(ALU_results)
    //);

endmodule
