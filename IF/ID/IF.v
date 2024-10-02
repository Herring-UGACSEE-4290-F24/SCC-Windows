module IF(clk,reset,in_mem, data_in, in_mem_addr, data_addr, data_out, data_read, data_write)
begin
    input           clk             // main clock signal
    input           reset           // sets all regs to known state
    input [31:0]    in_mem          // instructions being fetched
    input [31:0]    data_in         // data read from memory    

    output [31:0]   in_mem_addr     // address pointed to in instruction memory
    output          in_mem_en       // enable instruction memory fetch

    
    always@(posedge)

    if(in_mem_en)
    begin
    

    end
end