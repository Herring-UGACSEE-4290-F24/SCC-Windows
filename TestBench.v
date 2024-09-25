module TestBench(clk, reset, instruction, results)
begin
    wire           clk             // clock signal
    wire           reset          // reset signal

    wire [31:0]    instruction     // instruction to be executed
    reg [31:0]     results         // results of SCC
end