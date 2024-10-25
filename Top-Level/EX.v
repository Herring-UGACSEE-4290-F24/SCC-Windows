module EX(
    First_LD, 
    Special_encoding, 
    Second_LD, 
    ALU_OC, 
    B_cond,
    dest_reg, 
    pointer_reg, 
    op_1_reg_value, 
    op_2_reg_value, 
    immediate, 
    offset,
    r_val_0, 
    r_val_1, 
    w_alu,
    w_enable,
    w_select,
    flags, 
    result);

    //===========================================  I/O  ===================================================//
    // Just the outputs of decode 
    input wire [1:0]        First_LD;           // First Level Decoding         
    input wire              Special_encoding;   // Encoding for ALU usage
    input wire [3:0]        Second_LD;          // Second Level Decoding
    input wire [2:0]        ALU_OC;             // ALU Operation Commands 
    input wire [3:0]        B_cond;             
    input wire [2:0]        dest_reg;
    input wire [2:0]        pointer_reg;
    input wire [31:0]       op_1_reg_value;
    input wire [31:0]       op_2_reg_value;
    input wire [15:0]       immediate;
    input wire [15:0]       offset;
    input wire [31:0]       r_val_0;
    input wire [31:0]       r_val_1;
    input wire [31:0]       w_alu;
    input wire              w_enable;    //Enables writing to regs (active high)
    input wire              w_select;    //Mux select for ALU/ID writing to reg files, 0 = ALU, 1 = ID
    input wire [3:0]        flags;       // CPSR      N, C, Z, V  [sadly not the same as arm8 hard to remember]

    wire [31:0]             extended_immediate;

    output reg [32:0]       result;
    reg                     write_enable;
    reg [3:0]        conditional_flags;              //CPSR      N, C, Z, v  sadly not the same as arm8 hard to remember
    //output wire [32:0]      ALU_results;
    
    //output wire [31:0]      updated_pc;
    assign extended_immediate[15:0] = immediate[15:0];
    assign extended_immediate[31:16] = {16{immediate[15]}};
    assign w_select = !Special_encoding;

    assign  op_1_reg_value = r_val_0;
    assign  op_2_reg_value = r_val_1;
    assign w_alu = result[31:0];
    assign w_enable = write_enable;
    assign flags [3:0] = conditional_flags;
    // Assign the result to ALU_results
 
   initial begin
    result = 'h000000000;
    conditional_flags = 'b0000;
   end

always @(*) begin
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

        if (Second_LD[3]) begin         //Set flags bit is high

            conditional_flags[3] = result[31];  // Negative

            conditional_flags[2] = result[32];  // Carry (unsigned overflow)

            case (result[31:0])
                32'b0: conditional_flags[1] = 1;  // Zero

                default: conditional_flags[1] = 0;
            endcase

            case (First_LD[0])
                1'b1: conditional_flags[0] = (op_1_reg_value[31] | op_2_reg_value[31]) ^ result[31]; // V for Register

                1'b0: conditional_flags[0] = (op_1_reg_value[31] | extended_immediate[31]) ^ result[31]; // V for Immediate
            endcase
        end
       
    end else if (First_LD == 2'b00) begin
        // Non-ALU functions with REG
        case (ALU_OC[2:0])
            3'b000: result = extended_immediate; // MOV operation

            3'b001: result[31:16] = immediate[15:0]; // MOVT command

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
    end else begin
        // Branching and System calls default
        case (ALU_OC[2:0])
            3'b000: begin
                // Branching code
            end
            3'b001: begin
                // Implement branch conditional
                case (conditional_flags[3:0]) // N, C, Z, V
                    4'b0000: begin // beq
                        case (conditional_flags[1])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0001: begin // bne
                        case (!conditional_flags[1])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0010: begin // branch carry set
                        case (conditional_flags[2])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0011: begin // branch carry clear
                        case (!conditional_flags[2])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0100: begin // branch negative
                        case (conditional_flags[3])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0101: begin // branch positive
                        case (!conditional_flags[3])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0110: begin // branch overflow set
                        case (conditional_flags[0])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b0111: begin // branch overflow clear
                        case (!conditional_flags[0])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1000: begin // branch unsigned higher
                        case (conditional_flags[2] && !conditional_flags[1])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1001: begin // branch unsigned lower or same
                        case (!(conditional_flags[2] && !conditional_flags[1]))
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1010: begin // branch signed greater than or equal
                        case (conditional_flags[3] == conditional_flags[0])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1011: begin // branch signed less than or equal
                        case (conditional_flags[3] != conditional_flags[0])
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1100: begin // branch greater than
                        case ((conditional_flags[1] == 0) && (conditional_flags[3] == conditional_flags[0]))
                            1'b1: begin
                                // branch
                            end
                        endcase
                    end
                    4'b1101: begin // branch less than or equal
                        case (!((conditional_flags[1] == 0) && (conditional_flags[3] == conditional_flags[0])))
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