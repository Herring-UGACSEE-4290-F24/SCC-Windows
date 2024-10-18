//
// Instruction Fetch Implementation
// Increments Program Counter and handles branching via the taken flag
// Possible future changes -adding relative branching if it isn't handled in SCC
//

module IF(clk, reset, pc, instruction);

    /*===========================================  I/O  ===================================================*/
    input                   clk;                   //main clock 
    input                   reset;                 //resets pc to known state

    output reg [31:0]       pc;                    // address pointed to in instruction memory
    output wire [31:0]      instruction;           // enable instruction memory fetch

    reg instruction_memory_en;
    wire [31:0] data_memory_a;
    wire data_memory_read;
    wire data_memory_write;
    wire [31:0] data_memory_out_v;
    wire [31:0] data_memory_in_v;
   
   
    /*=====================================================================================================*/
    

//Instantiating instruction memory
Instruction_and_data instr_mem(
    .mem_Clk(clk),
    .instruction_memory_en(instruction_memory_en),
    .instruction_memory_a(pc),
    .data_memory_a(data_memory_a),
    .data_memory_read(data_memory_read),
    .data_memory_write(data_memory_write),
    .data_memory_out_v(data_memory_out_v),
    .instruction_memory_v(instruction),
    .data_memory_in_v(data_memory_in_v)
);

initial begin
    instruction_memory_en = 1'b1;
    pc = 32'h0000;
end

always @(posedge clk or posedge reset)
    begin
    if (reset) begin
        pc = 32'h0000;                 // Resets progam counter if reset is high
    end 
    else begin
        pc = pc + 32'h0004;            // Default case: Increment PC by four
    end
end

endmodule

// For IF:
// No muxes in these files, they will be in their own separate files
// Memory file is outside the SCC (instruction mem and data mem)

// For ID:
// Cases would be cleaner/better than else/if statements to turn into hardware
// Cases also make debugging easier
// Cannot be multiple registers in the path, single cycle computer means only one at a time
// The register will be in the memory file or testbench (most things will be wires to transmit data)