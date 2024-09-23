module DataMem_Wrapper()
begin 
    input           clk             // clock signal
    input           read            // output enable
    input           write           // input enable
    input [31:0]    address         // register location

    output [31:0]   data            // stored data in [address]
end