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
    flags, 
    result);

    // Just the outputs of decode 
    input wire [1:0]        First_LD;                    
    input wire              Special_encoding;
    input wire [3:0]        Second_LD;
    input wire [2:0]        ALU_OC;
    input wire [3:0]        B_cond;
    input wire [2:0]        dest_reg;
    input wire [2:0]        pointer_reg;
    input wire [31:0]       op_1_reg_value;
    input wire [31:0]       op_2_reg_value;
    input wire [15:0]       immediate;
    input wire [15:0]       offset;
    input wire [31:0]       r_val_0 ;
    input wire [31:0]       r_val_1 ;
    input wire [31:0]       w_alu;
   
    output reg [3:0]        flags;              //CPSR      N, C, Z, v  sadly not the same as arm8 hard to remember
    output reg [32:0]      result;


    //output wire [32:0]      ALU_results;
    wire [31:0]             extended_immediate;
   
    //output wire [31:0]      updated_pc;
    assign extended_immediate[15:0] = immediate[15:0];
    assign extended_immediate[31:16] = {16{immediate[15]}};
   

    assign  op_1_reg_value = r_val_0;
    assign  op_2_reg_value = r_val_1;
    assign w_alu = result[31:0];
    // Assign the result to ALU_results
   initial begin
    result = 'h00000000;
   end


    always @(*) begin
        
        if (Special_encoding) begin
            // Ironically Special Encoding high means ALU, so these are ALU FUNCTIONS
            case (ALU_OC[2:0])
                3'b001: begin // ADD Control Command
                    if (First_LD[0] == 1'b0) // Immediate is being used
                       begin
                       result = op_1_reg_value + extended_immediate;
                       end
                    else // Register is being used
                        begin
                        result = op_1_reg_value + op_2_reg_value;
                        end
                end
                3'b010: begin // SUB Control Command
                    if (First_LD[0] == 1'b0)
                        begin
                        result = op_1_reg_value - extended_immediate;
                        end
                    else
                        begin
                        result = op_1_reg_value - op_2_reg_value;
                        end
                end
                3'b011: begin // AND Control Command
                    if (First_LD[0] == 1'b0)
                        begin
                        result = op_1_reg_value & extended_immediate;
                        end
                    else
                        result = op_1_reg_value & op_2_reg_value;
                end
                3'b100: begin // OR Control Command
                    if (First_LD[0] == 1'b0)
                        begin
                        result = op_1_reg_value | extended_immediate;
                        end
                    else
                        begin
                        result = op_1_reg_value | op_2_reg_value;
                        end
                end
                3'b101: begin // XOR Control Command
                    if (First_LD[0] == 1'b0)
                        begin
                        result = op_1_reg_value ^ extended_immediate;
                        end
                    else
                        begin
                        result = op_1_reg_value ^ op_2_reg_value;
                        end
                end
                3'b110: begin // NOT Control Command
                    begin
                    result = ~op_1_reg_value;
                    end
                end
                default: result = result; // Default case for unspecified ALU_OC values
            endcase

            if(Second_LD[3])
                begin
                flags[3] = result[31];  //Negative
                end

  


                if(First_LD[0])         //Reg
                    begin
                        flags[2] = (op_1_reg_value[31] | op_2_reg_value[31]) ^ result[31];    //Carry
                    end
                else                    //Immediate  
                    begin
                        flags[2] = (op_1_reg_value[31] | extended_immediate[31]) ^ result[31];    //Carry
                    end
               
                if(result[31:0] == 32'b0)
                    begin
                    flags[1] = 1;    //Zero
                    end
                else
                    begin
                    flags[1] = 0;
                    end

                flags[0] = result[32];  //Overflow
                //end
        end
        else if (First_LD == 2'b00) begin
            // Non-ALU functions with REG
            case (ALU_OC[2:0])
                3'b000: begin
                    // Implement MOV operation
                   result=extended_immediate;
                end
                3'b001: begin
                    // Implement MOVT command
                    result[31:16]=immediate[15:0];
                end
                3'b100: begin
                    // Implement LSL (Logical Shift Left)
                    result = op_1_reg_value<<immediate;
                    result[32] = 'b0;
                    

                       
                end
                3'b101: begin
                    // Implement LSR (Logical Shift Right)
                    result = op_1_reg_value>>immediate;
                    result[32] = 0;

                end
                3'b010: begin
                    // Implement CLR (Clear)
                    result[31:0] = 'h00000000;
                end
                3'b011: begin
                    // Implement SET
                 result[31:0] = 'h11111111;
                end
                default: result = 32'b0;
            endcase
        end
        else begin
            // Branching and System calls default
            case (ALU_OC[2:0])
                3'b000: begin
                    //branch
                    //updated_pc = 
                end
                3'b001: begin
                    // Implement branch conditional

                    case (flags[3:0])              //N, C, Z, V
                        4'b0000: begin             //beq
                        if(flags[1])
                            begin
                          //branch  
                            end
                        end
                        4'b0001:begin             //bne
                        if(!flags[1])
                            begin
                            //branch
                            end
                        end                       
                        4'b0010:begin             // branch carry set
                        if(flags[2])
                            begin
                            //branch
                            end
                        end
                        4'b0011: begin            // branch carry clear
                        if(!flags[2])
                            begin
                            //branch
                            end
                        end
                        4'b0100: begin             // branch negative
                         if(flags[3])
                            begin
                            //branch
                            end
                        end
                        4'b0101: begin            // branch positive
                         if(!flags[3])
                            begin
                            //branch
                            end
                        end
                        4'b0110: begin           // branch overflow set
                        if(flags[0])
                            begin
                            //branch
                            end
                        end
                        4'b0111: begin             // branch overflow clear
                        if(!flags[0])
                            begin
                            //branch
                            end
                        end
                        4'b1000: begin           // branch unsigned higher aka carry = 1 z==0
                        if(flags[2] && (!flags[1]))
                            begin
                            //branch
                            end
                        end
                        4'b1001: begin            // branch unsigned lower or same aka !(c==1 && z==0)
                        if(!(flags[2] &&(!flags[1])))
                            begin
                            //branch
                            end
                        end
                        4'b1010: begin            // branch signed greater than or equal
                        if(flags[3]==flags[0])
                            begin
                            //branch
                            end
                        end
                        4'b1011: begin             // branch signed less than or equal
                        if(flags[3]!=flags[0])
                            begin
                            //branch
                            end
                        end
                        
                        4'b1100: begin            // branch greater than
                        if((flags[1] == 0) && (flags[3]==flags[0]))
                            begin
                            //branch
                            end
                        end
                        4'b1101:             // branch less than or equal
                        if(!((flags[1] == 0) && (flags[3]==flags[0])))
                            begin
                            //branch
                            end
                        4'b1110: begin            // branch always
                            //branch
                        end
                        4'b1111: begin            // b
                            //nop
                        end
                    endcase
                end
                default: 
                begin
                result = result; // NOP
                end
            endcase
        end
    end
endmodule