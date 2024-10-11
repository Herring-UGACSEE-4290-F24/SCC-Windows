module RegFile(clk, address, register)
begin
    input               clk             // clock signal
    input wire [2:0]   address         // 32-bit instruction address
    output reg [31:0]   register     // instruction to be executed

    //Defining register file, there are 2^3 = 8 registers, each 32 bits wide
    reg [31:0] registers [0:7];

    initial begin
        // Initialize all registers to zero
        for (int i = 0; i < 7; i = i + 1) registers[i] = 32'h00000000;
    end

    // Read instruction from memory based on the address input
    always @(posedge clk) begin
        register = registers[address[2:0]];  // 8 register locations, accessed by 3 address bits
    end
end