//
// Instruction Fetch Implementation
// Increments Program Counter and handles branching via the taken flag
// Possible future changes -adding relative branching if it isn't handled in SCC
//

module IF(clk,reset, taken, branch_address,pc, Instruction, pc_next, Instruction_next)

    input               clk;                    // main clock 
    input               reset;                  // resets pc to known state
    input               taken;                  // flag to show if  branch is taken
    input       [31:0]   branch_address;        // branch address
    output wire [31:0]   pc;                    // address pointed to in instruction memory
    output      [31:0]   Instruction;           // enable instruction memory fetch
    output wire [31:0]   pc_next;               // address pointed to in instruction memory + 4
    output reg  [31:0]   Instruction_next;      // enable instruction memory fetch
    

    
    always@(posedge clk)  
    begin
        if(reset)
        begin
            assign pc = 0x0000;                    // resets progam counter if reset is high
            assign pc_next = 0x0004;
        end
        else if(taken)
        begin
            assign pc = branch_address;            // changes program counter to branch_address  (abs branch)
            assign pc_next = branch_address + 0x0004;
        end
        else
        begin
            assign pc = pc + 0x0004;                    // default case: Increment PC by four
            assign pc_next = pc_next + 0x0004;
        end
    end

    always @(posedge clk) 
    begin
        Instruction <=              //I am confused with how we should handle the actual access
        Instruction_next <=         //I am confused with how we should handle the actual access
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