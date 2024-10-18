//
// Instruction Fetch Implementation
// Increments Program Counter and handles branching via the taken flag
// Possible future changes -adding relative branching if it isn't handled in SCC
//

module IF(clk, reset, br_value, offset, pc, instruction);

    /*===========================================  I/O  ===================================================*/
    input                   clk;                   //main clock 
    input                   reset;                 //resets pc to known state
    input wire [31:0]       br_value;              //value of pointer reg
    input wire [31:0]       offset;                //offset used for branching

    output reg [31:0]       pc;                    // address pointed to in instruction memory
    output wire [31:0]      instruction;           // enable instruction memory fetch

    
   
   
    /*=====================================================================================================*/
    

//Instantiating instruction memory
InstrMem instr_mem(
    .clk(clk),
    .address(pc),
    .instruction(instruction)
);

always @(posedge clk or posedge reset)
    begin
    if (reset) begin
        pc = 32'h0000;                 // Resets progam counter if reset is high
        offset = 32'h0000;
        br_value = 32'h0000;
    end else if (offset!=0) begin
        pc = pc + offset;
        offset = 32'h0000;
    end
    else if(br_value !=0) begin
        pc = br_value + offset;
        br_value = 32'h0000;
        offset = 32'h0000;
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