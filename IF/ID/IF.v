//
// Instruction Fetch Implementation
// Increments Program Counter and handles branching via the taken flag
// Possible future changes -adding relative branching if it isn't handled in SCC
//

module IF(clk,reset, taken, branch_address,pc,instruction)

    input               clk             // main clock 
    input               reset           // resets pc to known state
    input               taken           // flag to show if  branch is taken
    input      [31:0]   branch_address  // branch address
    output reg [31:0]   pc              // address pointed to in instruction memory
    output reg [31:0]   instruction     // enable instruction memory fetch

    
    always@(posedge)  
    begin
        if(reset)
        begin
            pc <= 0x0000;                   // resets progam counter if reset is high
        end
        else if(taken)
        begin
            pc <= branch_address            // changes program counter to branch_address  (abs branch)
        end
        else
        begin
            pc <= pc + 4                    // default case: Increment PC by four
        end
    end

    always @(posedge clk) 
    begin
        instruction <=              //I am confused with how we should handle the actual access
    end

endmodule