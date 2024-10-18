// Instruction Fetch Implementation

module IF(clk, reset, pc, instruction);

    //===========================================  I/O  ===================================================//
    input                   clk;                   //main clock 
    input                   reset;                 //resets pc to known state

    output reg [31:0]       pc;                    // address of next instruction in memory
    output reg [31:0]       instruction;           // fetched instruction

    wire [31:0]             prefetch;              // instruction pre-fetched one ahead 
    reg                     instruction_memory_en; // enables reading from instruction memory
    reg  [31:0]             br_immediate;          // Non-conditional branch immediate
    //=====================================================================================================//

    //Instantiating instruction memory
    Instruction_and_data instr_mem(
        .mem_Clk(clk),
        .instruction_memory_en(instruction_memory_en),
        .instruction_memory_a(pc),
        .instruction_memory_v(prefetch)
    );

    //Instruction fetching logic
    initial begin
        instruction_memory_en = 1'b1;
        pc = 32'h0000;
    end

    always @(posedge clk or posedge reset)
        begin
        instruction <= prefetch;
        if (reset) begin
            pc = 32'h0000;                              // Resets progam counter if reset is high
        end 
        else if (prefetch[31:25] == 7'b1100000)         // Checking if instruction is unconditional branch
            begin
            br_immediate = prefetch[15:0];
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
        else begin
            pc = pc + 32'h0004;                         // Default case: Increment PC by four
        end
    end
endmodule