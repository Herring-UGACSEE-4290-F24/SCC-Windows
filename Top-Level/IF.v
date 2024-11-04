// Instruction Fetch Implementation

module IF(clk, reset, prefetch, conditional_flags, pc, instruction);

    //===========================================  I/O  ===================================================//
    input                   clk;                   // main clock 
    input                   reset;                 // resets pc to known state
    input wire [31:0]       prefetch;              // instruction pre-fetched one ahead
    input wire [3:0]        conditional_flags;                 // cpsr flags written back
    output reg [31:0]       pc;                    // address of next instruction in memory
    output reg [31:0]       instruction;           // fetched instruction

    reg  [31:0]             br_immediate;          // Non-conditional branch immediate
    //=====================================================================================================//

    // Instruction fetching logic
    initial begin
        // PC always starts at 0
        pc = 32'h0000;
    end

    always @(*)
        begin
            br_immediate = prefetch[15:0];              // Extracting immediate value from instruction
            if (prefetch[31:25] == 7'b1100000)         // Checking if instruction is unconditional branch
                begin
                if (br_immediate[15] == 1'b0)                   
                    begin
                    pc = pc + br_immediate;                 // Incrementing PC by positive offset
                    end
                else
                    begin
                    br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                    pc = pc + br_immediate;                // Decrementing PC by negative offset
                    end
            end
    end

    always @(posedge clk or posedge reset)
        begin
        instruction <= prefetch;
        br_immediate = prefetch[15:0]; 
        if (reset) begin
            pc = 32'h0000;                              // Resets PC if reset is high
        end 
        if (prefetch[31:25 != 7'b1100001])begin
            pc = pc + 32'h0004;                         // Default case: Increment PC by four
        end
        else         // Conditional branching
                begin
                    case (prefetch[28:25]) // N, C, Z, V
                    4'b0000: begin // beq
                        case (conditional_flags[1])
                            1'b1: begin

                            if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end

                                end
                        endcase
                    end
                    4'b0001: begin // bne
                        case (!conditional_flags[1])
                            1'b1: begin
                               
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end

                            end
                        endcase
                    end
                    4'b0010: begin // branch carry set
                        case (conditional_flags[2])
                            1'b1: begin
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                            end
                        endcase
                    end
                    4'b0011: begin // branch carry clear
                        case (!conditional_flags[2])
                            1'b1: begin

                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end

                            end
                        endcase
                    end
                    4'b0100: begin // branch negative
                        case (conditional_flags[3])
                            1'b1: begin

                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end

                            end
                        endcase
                    end
                    4'b0101: begin // branch positive
                        case (!conditional_flags[3])
                            1'b1: begin
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                            end
                        endcase
                    end
                    4'b0110: begin // branch overflow set
                        case (conditional_flags[0])
                            1'b1: begin
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                            end
                        endcase
                    end
                    4'b0111: begin // branch overflow clear
                        case (!conditional_flags[0])
                            1'b1: begin
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                            end
                        endcase
                    end
                    4'b1000: begin // branch unsigned higher
                        case (conditional_flags[2] && !conditional_flags[1])
                            1'b1: begin
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                            end
                        endcase
                    end
                    4'b1001: begin // branch unsigned lower or same
                        case (!(conditional_flags[2] && !conditional_flags[1]))
                            1'b1: begin
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                            end
                        endcase
                    end
                    4'b1010: begin // branch signed greater than or equal
                        case (conditional_flags[3] == conditional_flags[0])
                            1'b1: begin
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                            end
                        endcase
                    end
                    4'b1011: begin // branch signed less than or equal
                        case (conditional_flags[3] != conditional_flags[0])
                            1'b1: begin
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                            end
                        endcase
                    end
                    4'b1100: begin // branch greater than
                        case ((conditional_flags[1] == 0) && (conditional_flags[3] == conditional_flags[0]))
                            1'b1: begin
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                            end
                        endcase
                    end
                    4'b1101: begin // branch less than or equal
                        case (!((conditional_flags[1] == 0) && (conditional_flags[3] == conditional_flags[0])))
                            1'b1: begin
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                            end
                        endcase
                    end
                    4'b1110: begin // branch always
                           if (br_immediate[15] == 1'b0)                   
                                begin
                                pc = pc + br_immediate;                 // Incrementing PC by positive offset
                                end
                             else begin
                                br_immediate[31:16] = 16'hFFFF;        // Sign-extending immediate value to 32 bits
                                pc = pc + br_immediate;                // Decrementing PC by negative offset
                            end
                    end
                    4'b1111: begin // nop
                        // nop
                    end
                endcase
                end
  
    end
endmodule