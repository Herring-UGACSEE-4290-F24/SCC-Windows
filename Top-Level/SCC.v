module SCC(clk, reset, in_mem, data_in, in_mem_addr, data_addr, data_out);
    /*===========================================  I/O  ===================================================*/
    input           clk;             // main clock signal
    input           reset;           // sets all regs to known state
    input [31:0]    in_mem;          // instructions being fetched
    input [31:0]    data_in;         // data read from memory    

    output [31:0]   in_mem_addr;     // address pointed to in instruction memory
    output          in_mem_en;       // enable instruction memory fetch
    output [31:0]   data_addr;       // address pointed to in data memory
    output [31:0]   data_out;        // data to write to memory
    /*=====================================================================================================*/
  
    //Instruction Fetch declarations
    wire [31:0]     prefetch;        // prefetched instruction from mem into fetch

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

    //Reg file input and output declarations
    wire [31:0]       r_val_0;
    wire [31:0]       r_val_1;

    wire [2:0]        r_addr_0;
    wire [2:0]        r_addr_1;
    wire [2:0]        w_addr;
    wire              w_enable;    //Enables writing to regs (active high)
    wire              w_select;    //Mux select for ALU/ID writing to reg files, 0 = ALU, 1 = ID
    wire [31:0]       w_alu;

    wire [31:0]       w_id;
    wire [3:0]        conditional_flags;

    //Memory declarations
    wire [31:0]       data_memory_a; //Data memory address
    wire [31:0]       data_memory_in_v; //data memory read value
    wire [31:0]       data_memory_out_v; //data memory write value
    wire              data_memory_read; //data memory read enable
    wire              data_memory_write; //data memory write enable

    //Instantiate Instruction/Data Memory
    Instruction_and_data instr_mem(
        .mem_Clk(clk),
        .instruction_memory_en(1'b1),
        .instruction_memory_a(in_mem_addr),
        .instruction_memory_v(prefetch),
        .data_memory_a(data_memory_a),
        .data_memory_in_v(data_memory_in_v),
        .data_memory_out_v(data_memory_out_v),
        .data_memory_read(data_memory_read),
        .data_memory_write(data_memory_write)
    );

    //Instatiate Module IF
    IF instruction_fetch(
        .clk(clk),
        .reset(reset),
        .prefetch(prefetch),
        .conditional_flags(conditional_flags),
        .pc(in_mem_addr),
        .instruction(in_mem)
    );

    //Instatiate Module Decode
    ID instruction_decode( 
    .Instruction(in_mem), 
    .r_addr_0(r_addr_0), 
    .r_addr_1(r_addr_1),
    .w_addr(w_addr), 
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
    .flags(flags),
    .data_memory_in_v(data_memory_in_v),
    .data_memory_a(data_memory_a),
    .data_memory_out_v(data_memory_out_v),
    .data_memory_read(data_memory_read),
    .data_memory_write(data_memory_write),
    .r_val_0(r_val_0),
    .w_id(w_id),
    .w_select(w_select),
    .w_enable(w_enable)
    );

    //Instatiate Reg File
     RegFile reg_file (
         .clk(clk), 
         .r_addr_0(r_addr_0), 
         .r_addr_1(r_addr_1), 
         .w_addr(w_addr), 
         .w_enable(w_enable), 
         .w_select(w_select), 
         .w_alu(w_alu), 
         .w_id(w_id), 
         .r_val_0(r_val_0), 
         .r_val_1(r_val_1)
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
    .r_val_0(r_val_0), 
    .r_val_1(r_val_1), 
    .w_alu(w_alu),
    .w_id(w_id),
    .w_enable(w_enable),
    .w_select(w_select),
    .flags(flags),
    .conditional_flags(conditional_flags),
    .result(ALU_results)
    );

endmodule
