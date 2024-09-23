module InstrMem_Wrapper.v()
begin
    input           clk             // clock signal
    input [31:0]    address         // register location

    output [31:0]   instruction     // instruction to be executed
end