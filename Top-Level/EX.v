module EX(
    First_LD, 
    Special_encoding, 
    Second_LD, 
    ALU_OC, 
    B_cond,
    dest_reg, 
    op_1_reg_value, 
    op_2_reg_value, 
    immediate, 
    offset,
    r_val_0, 
    r_val_1, 
    w_alu,
    w_other,
    w_enable,
    w_select,
    flags, 
    conditional_flags,
    result,
    data_memory_in_v,
    data_memory_a,
    data_memory_out_v,
    data_memory_read,
    data_memory_write);

    //===========================================  I/O  ===================================================//
    // Just the outputs of decode 
    input wire [1:0]        First_LD;           // First Level Decoding         
    input wire              Special_encoding;   // Encoding for ALU usage
    input wire [3:0]        Second_LD;          // Second Level Decoding
    input wire [2:0]        ALU_OC;             // ALU Operation Commands 
    input wire [3:0]        B_cond;             
    input wire [2:0]        dest_reg;
    input wire [31:0]       op_1_reg_value;
    input wire [31:0]       op_2_reg_value;
    input wire [15:0]       immediate;
    input wire [15:0]       offset;
    input wire [31:0]       r_val_0;
    input wire [31:0]       r_val_1;
    input wire [31:0]       w_alu;
    input wire [31:0]       w_other;
    input wire              w_enable;    //Enables writing to regs (active high)
    input wire              w_select;    //Mux select for ALU/ID writing to reg files, 0 = ALU, 1 = ID
    input wire [3:0]        flags;       // CPSR      N, C, Z, V  [sadly not the same as arm8 hard to remember]
    input wire [3:0]        conditional_flags;
    wire [31:0]             extended_immediate;
    output reg [32:0]       result;

    //Memory access
    input [31:0]       data_memory_in_v; //data memory read value
    output reg [31:0]       data_memory_a; //data memory access address
    output reg [31:0]       data_memory_out_v; //data memory write value
    output reg             data_memory_read; //data memory read enable
    output reg             data_memory_write; //data memory write enable
    
    reg                     write_enable;
    reg                     write_select;

    reg [3:0]        cpsr_flags;              //CPSR      N, C, Z, V  sadly not the same as arm8 hard to remember

    //output wire [32:0]      ALU_results;
    
    //output wire [31:0]      updated_pc;
    assign extended_immediate[15:0] = immediate[15:0];
    assign extended_immediate[31:16] = {16{immediate[15]}};
    assign w_select = !Special_encoding;

    assign  op_1_reg_value = r_val_0;
    assign  op_2_reg_value = r_val_1;
    assign w_alu = result[31:0];
    assign w_other = result[31:0];
    assign w_enable = write_enable;
    assign w_select = write_select;

    assign conditional_flags [3:0] = cpsr_flags;

    // Assign the result to ALU_results
 
   initial begin
    result = 'h000000000;
    cpsr_flags = 'b0000;
    write_enable = 0;
    data_memory_read = 1'b0;
    data_memory_write = 1'b0;
   end

always @(*) begin
    result = 'h000000000;
    if (Special_encoding) begin
        // Special Encoding high means ALU, so these are ALU FUNCTIONS
        write_enable = 1;
        case (ALU_OC[2:0])
            3'b001: begin // ADD Control Command
                case (First_LD[0])
                    1'b0: result = op_1_reg_value + extended_immediate; // Immediate is being used

                    1'b1: result = op_1_reg_value + op_2_reg_value; // Register is being used
                endcase
            end
            3'b010: begin // SUB Control Command
                case (First_LD[0])
                    1'b0: result = op_1_reg_value - extended_immediate; // Immediate is being used

                    1'b1: result = op_1_reg_value - op_2_reg_value; // Register is being used
                endcase
            end
            3'b011: begin // AND Control Command
                case (First_LD[0])
                    1'b0: result = op_1_reg_value & extended_immediate; // Immediate is being used

                    1'b1: result = op_1_reg_value & op_2_reg_value; // Register is being used
                endcase
            end
            3'b100: begin // OR Control Command
                case (First_LD[0])
                    1'b0: result = op_1_reg_value | extended_immediate; // Immediate is being used

                    1'b1: result = op_1_reg_value | op_2_reg_value; // Register is being used
                endcase
            end
            3'b101: begin // XOR Control Command
                case (First_LD[0])
                    1'b0: result = op_1_reg_value ^ extended_immediate; // Immediate is being used

                    1'b1: result = op_1_reg_value ^ op_2_reg_value; // Register is being used
                endcase
            end
            3'b110: begin // NOT Control Command
                result = ~op_1_reg_value;
            end
            default: result = result; // Default case for unspecified ALU_OC values
        endcase

//                               flag [3]     flag[2]                     flag[1]          flag[0]
//======= The System Flags are N (Negative), C (Carry, Unsigned Overflow), Z (Zero), and V (Signed Overflow) =======\\
//                                                                                                                  \\
        #1
        if (Second_LD[3]) begin         //Set flags bit is high

            cpsr_flags[3] = result[31];  // Negative

            cpsr_flags[2] = result[32];  // Carry (unsigned overflow)

            case (result[31:0])
                32'b0: cpsr_flags[1] = 1;  // Zero

                default: cpsr_flags[1] = 0;
            endcase

            case (First_LD[0])
                1'b1: cpsr_flags[0] = (op_1_reg_value[31] | op_2_reg_value[31]) ^ result[31]; // V for Register

                1'b0: cpsr_flags[0] = (op_1_reg_value[31] | extended_immediate[31]) ^ result[31]; // V for Immediate
            endcase
        end
       
    end else if (First_LD == 2'b00) begin
        // Non-ALU functions with REG

        write_enable = 1;

        case (ALU_OC[2:0])
            3'b000: begin
                result[15:0] = immediate[15:0]; // MOV operation
                result[31:16] = op_1_reg_value[31:16];

            end

            3'b001: begin
                result[31:16] = immediate[15:0]; // MOVT command
                result[15:0] = op_1_reg_value[15:0];

            end

            3'b100: begin // LSL (Logical Shift Left)
               result = op_1_reg_value << immediate;
               result[32] = 1'b0;
            end
            3'b101: begin // LSR (Logical Shift Right)
                result = op_1_reg_value >> immediate;
                result[32] = 1'b0;
            end
            3'b010: result[31:0] = 'h00000000; // CLR (Clear)
            
            3'b011: result[31:0] = 'h11111111; // SET
            default: result = 32'b0;


        endcase

    end else if (First_LD == 2'b10) begin
        case (Second_LD[3:0])
            4'b0000: begin // LOAD
                //Reading from data mem
                data_memory_read = 1'b1; //enable reading from data mem
                data_memory_a = r_val_0 + immediate; //address to be read from is reg value + immediate offset
                result = data_memory_in_v; //Set value to be written to value read from data mem

                //Writing to register file
                write_select = 1'b1; //enable writing to register from w_other
                write_enable <= 1'b1; //enables writing at clock edge
            end
            4'b0001: begin //STORE
                //Reading from register file
                data_memory_out_v = r_val_0; //Data memory value to write = value of dest reg

                //Writing to data memory
                data_memory_a = r_val_1 + immediate; //address to be written to is reg value + immediate offset
                data_memory_write = 1'b1; //enable writing to data mem
            end
        endcase
    
    end else begin
        // Branching and System calls default
        write_enable = 0;
        case (ALU_OC[2:0])
            3'b000: begin
                // Branching code
            end
            3'b001: begin
                // Implement branch conditional
                case (cpsr_flags[3:0]) // N, C, Z, V
                    4'b0000: begin // beq
                        case (cpsr_flags[1])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0001: begin // bne
                        case (!cpsr_flags[1])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0010: begin // branch carry set
                        case (cpsr_flags[2])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0011: begin // branch carry clear
                        case (!cpsr_flags[2])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0100: begin // branch negative
                        case (cpsr_flags[3])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0101: begin // branch positive
                        case (!cpsr_flags[3])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0110: begin // branch overflow set
                        case (cpsr_flags[0])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0111: begin // branch overflow clear
                        case (!cpsr_flags[0])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1000: begin // branch unsigned higher
                        case (cpsr_flags[2] && !cpsr_flags[1])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1001: begin // branch unsigned lower or same
                        case (!(cpsr_flags[2] && !cpsr_flags[1]))
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1010: begin // branch signed greater than or equal
                        case (cpsr_flags[3] == cpsr_flags[0])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1011: begin // branch signed less than or equal
                        case (cpsr_flags[3] != cpsr_flags[0])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1100: begin // branch greater than
                        case ((cpsr_flags[1] == 0) && (cpsr_flags[3] == cpsr_flags[0]))
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1101: begin // branch less than or equal
                        case (!((cpsr_flags[1] == 0) && (cpsr_flags[3] == cpsr_flags[0])))
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1110: begin // branch always
                        // branch
                    end
                    4'b1111: begin // nop
                        // nop
                    end
                endcase
            end
            default: result = result; // NOP
        endcase
    end
end
endmodule