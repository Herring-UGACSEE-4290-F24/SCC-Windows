module IF(clk,reset, taken, branch_address,pc,instruction)
begin
    input               clk             // main clock 
    input               reset           // resets pc to known state
    input               taken           // flag to show if unconditonal branch is taken
    input      [31:0]   branch_address  // branch address
    output reg [31:0]   pc              // address pointed to in instruction memory
    output reg [31:0]   instruction     // enable instruction memory fetch


    always@(posedge)  
    begin

    if(reset)
    begin
        pc <= 0x0000;
    end
    else if(taken)
    begin
        pc <= branch_address
    end
    else
    begin
        pc <= pc + 4
    end
    end

    always @(posedge clk) begin
        instruction <=              //I am confused with this part currently
    end

end