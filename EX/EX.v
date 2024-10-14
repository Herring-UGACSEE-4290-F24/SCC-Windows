module EX(First_LD, Special_encoding, Second_LD, ALU_OC, B_cond, dest_reg, pointer_reg, op_1_reg_value, op_2_reg_value, immediate, offset, flags, ALU_results);

    // Just the outputs of decode 
    input wire [1:0]        First_LD;                    
    input wire              Special_encoding;
    input wire [3:0]        Second_LD;
    input wire [2:0]        ALU_OC;
    input wire [3:0]        B_cond;
    input wire [2:0]        dest_reg;
    input wire [2:0]        pointer_reg;
    input wire [15:0]       op_1_reg_value;
    input wire [15:0]       op_2_reg_value;
    input wire [15:0]       immediate;
    input wire [15:0]       offset;
    input wire [3:0]        flags;

    output wire [15:0]      ALU_results;
    reg [15:0]              result;

    // Assign the result to ALU_results
    assign ALU_results = result;

    always @(*) begin
        if (Special_encoding) begin
            // Ironically Special Encoding high means ALU, so these are ALU FUNCTIONS
            case (ALU_OC[2:0])
                3'b001: begin // ADD Control Command
                    if (First_LD[0] == 1'b0) // Immediate is being used
                        result = op_1_reg_value + immediate;
                    else // Register is being used
                        result = op_1_reg_value + op_2_reg_value;
                end
                3'b010: begin // SUB Control Command
                    if (First_LD[0] == 1'b0)
                        result = op_1_reg_value - immediate;
                    else
                        result = op_1_reg_value - op_2_reg_value;
                end
                3'b011: begin // AND Control Command
                    if (First_LD[0] == 1'b0)
                        result = op_1_reg_value & immediate;
                    else
                        result = op_1_reg_value & op_2_reg_value;
                end
                3'b100: begin // OR Control Command
                    if (First_LD[0] == 1'b0)
                        result = op_1_reg_value | immediate;
                    else
                        result = op_1_reg_value | op_2_reg_value;
                end
                3'b101: begin // XOR Control Command
                    if (First_LD[0] == 1'b0)
                        result = op_1_reg_value ^ immediate;
                    else
                        result = op_1_reg_value ^ op_2_reg_value;
                end
                3'b110: begin // NOT Control Command
                    result = ~op_1_reg_value;
                end
                default: result = 16'b0; // Default case for unspecified ALU_OC values
            endcase
        end
        else if (First_LD == 2'b00) begin
            // Non-ALU functions with REG
            case (ALU_OC[2:0])
                3'b000: begin
                    // Implement MOV operation
                end
                3'b001: begin
                    // Implement MOVT command
                end
                3'b100: begin
                    // Implement LSL (Logical Shift Left)
                end
                3'b101: begin
                    // Implement LSR (Logical Shift Right)
                end
                3'b010: begin
                    // Implement CLR (Clear)
                end
                3'b011: begin
                    // Implement SET
                end
                default: result = 16'b0;
            endcase
        end
        else begin
            // Branching and System calls default
            case (ALU_OC[2:0])
                3'b000: begin
                    // Implement branch command 'b'
                end
                3'b001: begin
                    // Implement branch conditional
                end
                3'b010: begin
                    // Implement branch command 'br'
                end
                default: result = 16'b0; // NOP
            endcase
        end
    end
endmodule