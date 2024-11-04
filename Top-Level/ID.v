//
// Instruction Decode Implementation
// Handles instruction outputted from fetch tied together in the scc
// 


// Instruction Encoding according to class isa
// 31-30 1First_LD                (First Level Decoding which determines the instruction type)
// 29    Special_encoding   (Special Encoding for ALU)
// 28-25 Second_LD                (Second level decode)
// 27-25 ALU   OC           (ALU OC)
// 24-21 B. Cond            
// 24-22 Destination Reg    
// 21-19 op 1 reg
// 18-16 op 2 reg
// 15-0  Immediate


// Branch Prediction 
// Possibly implement the two stage state machine discused in class
// I currently am unsure how to store that tho
//

// For prefetch 
// check bits 31:25 of next instruction and see if it is 1100000 or 1100010 this is unconditonal branch and branch
// I am unsure how to implement the address saving yet

//===========================================  I/O  ===================================================//
module ID(
    input [31:0] Instruction,        // Instruction that was fetched
    input [2:0]     r_addr_0,
    input [2:0]     r_addr_1,
    input [2:0]        w_addr,
    output reg [1:0] First_LD,       // First Level Decoding
    output reg Special_encoding,     // Encoding for ALU usage
    output wire  [3:0] Second_LD,      // Second Level Decoding

    output wire [2:0] ALU_OC,         // ALU Operation Commands 

    output reg [3:0] B_cond,
    output reg [2:0] dest_reg,
    output reg [2:0] pointer_reg,
    output reg [2:0] op_1_reg,
    output reg [2:0] op_2_reg,
    output reg [15:0] immediate,
    output reg [3:0] flags,
    //Memory access
    input [31:0]       data_memory_in_v, //data memory read value
    output reg [31:0]       data_memory_a, //data memory access address
    output reg [31:0]       data_memory_out_v, //data memory write value
    output reg             data_memory_read, //data memory read enable
    output reg             data_memory_write, //data memory write enable
    output reg [31:0]       r_val_0, //Register value 0
    output reg [31:0]      w_id, //register write value from ID
    output reg            w_select, //mux select to write to reg file
    output reg            w_enable //enable writing to reg file

);
/*=====================================================================================================*/
    
    assign r_addr_0 = op_1_reg;
    assign r_addr_1 = op_2_reg;
    assign w_addr = dest_reg;
    assign Second_LD = Instruction[28:25];

    assign ALU_OC = Instruction[27:25];

    always @* begin
        // Default values to prevent latches
        First_LD = Instruction[31:30]; 
        dest_reg = 3'b0;
        op_1_reg = 3'b0;
        op_2_reg = 3'b0;
        pointer_reg = 3'b0;
        Special_encoding = 0;
        immediate = 16'b0;
        flags = 4'b0;
        B_cond = 3'b0;
       

        //
        // Data|Immediate
        //
        if (First_LD == 2'b00) begin
            case (Instruction[29:25])
                5'b00000: begin  // Mov Command
                    dest_reg[2:0] = Instruction[24:22];
                    // Used as enable in top level 
                    immediate = Instruction[15:0];
                end
                5'b00001: begin  // Movt Command
                    dest_reg[2:0] = Instruction[24:22];
                    // Used as enable in top level 
                    immediate = Instruction[15:0];
                end
                5'b10001: begin  // add
                    dest_reg[2:0] = Instruction[24:22];
                    // Used as enable in top level 
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                    
                    Special_encoding = 1;
                end
                5'b11001: begin  // adds
                    dest_reg[2:0] = Instruction[24:22];
                    // Used as enable in top level 
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                    Special_encoding = 1;
                end
                5'b10010: begin  // sub
                    dest_reg[2:0] = Instruction[24:22];
                    // Used as enable in top level 
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                    Special_encoding = 1;
                end
                5'b11010: begin  // subs
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                  
                    Special_encoding = 1;
                end
                5'b10011: begin  // and
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                   
                    Special_encoding = 1;
                end
                5'b11011: begin  // ands
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                  
                    Special_encoding = 1;
                end
                5'b10100: begin  // or
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
               
                    Special_encoding = 1;
                end
                5'b11100: begin  // ors
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                
                    Special_encoding = 1;
                end
                5'b10101: begin  // xor
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0]; 
                   
                    Special_encoding = 1;
                end
                5'b11101: begin  // xors
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                   
                    Special_encoding = 1;
                end
                5'b00100: begin  // lsl
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                end
                5'b00101: begin  // lsr
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                end
                5'b00010: begin  // clr
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                end
                5'b00011: begin  // set
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                end
            endcase
        end

        //
        // Data|Register
        //
        else if (First_LD == 2'b01) begin
            case (Instruction[29:25])
                5'b10001, 5'b11001, 5'b10010, 5'b11010, 
                5'b10011, 5'b11011, 5'b10100, 5'b11100, 
                5'b10101, 5'b11101: begin  // Add, Adds, Sub, Subs, And, Ands, Or, Ors, Xor, Xors
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                    op_2_reg[2:0] = Instruction[18:16];
                    Special_encoding = 1;
                end
                5'b10110: begin  // NOT
                    dest_reg[2:0] = Instruction[24:22];
                    op_1_reg[2:0] = Instruction[21:19];
                  
                    Special_encoding = 1;
                end
            endcase
        end

        //
        // Load/Store (bits 29-26 don't care)
        //
        else if (First_LD == 2'b10) begin
            if (Instruction[25] == 1'b1) begin //store
                dest_reg[2:0] = Instruction[24:22];
                pointer_reg[2:0] = Instruction[21:19];
                immediate = Instruction[15:0];
                //Still need store logic, inputs and outputs should be setup,
                //logic should be reverse of load
            
            end else begin //load
                dest_reg[2:0] = Instruction[24:22];
                pointer_reg[2:0] = Instruction[21:19];
                immediate = Instruction[15:0];

                data_memory_read = 1'b1;    //enable read from data mem
                op_1_reg = pointer_reg;  //set reg read addr to pointer_reg
                data_memory_a <= r_val_0 + immediate;        //set data read address to register value + offset
                w_select <= 1'b1;    //enable writing to reg from ID
                w_id <= data_memory_in_v; //set ID write to reg file to value read from data mem
                w_enable <= 1'b1; //enables write, value will be written to reg file at next clock edge

            end
        end

        //
        // System|Branch
        //
        else if (First_LD == 2'b11) begin
            case (Instruction[28:25])
                4'b0000: begin  // Branch unconditional
                    immediate = Instruction[15:0];
                end
                4'b0001: begin  // Branch conditional
                    flags = Instruction[24:21];
                    immediate = Instruction[15:0];
                end
                4'b0010: begin  // BR
                    pointer_reg[2:0] = Instruction[21:19];
                    immediate = Instruction[15:0];
                end
                default: begin  // Check for NOP and HALT
                    if (Instruction[27] == 1'b1) begin
                        // NOP: Do nothing
                    end else if (Instruction[28] == 1'b1) begin
                        // HALT
                    end
                end
            endcase
        end
    end

endmodule
