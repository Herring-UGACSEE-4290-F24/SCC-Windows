module InstrMem(clk, address, instruction)
begin
    input           clk             // clock signal
    input wire [31:0]   address         // 32-bit instruction address
    output reg [31:0]   instruction     // instruction to be executed

    //Defining instruction memory, although there is address space for 2^32 locations, here we have 255 for simplicity
    reg [31:0] memory [0:255];

    // Initialize the memory with instructions (in hexadecimal format)
    initial begin
        memory[0] = 32'h22000005; // ADD R0, R0, #5
        memory[1] = 32'24400003; // SUB R1, R0, #3
        memory[2] = 32'A8000000; // NOP
        memory[3] = 32'A000FFFD; // B #0
        memory[4] = 32'A8000000; // NOP

        // Initialize the rest of memory to zero
        for (int i = 5; i < 256; i = i + 1) memory[i] = 32'h00000000;
    end

    // Read instruction from memory based on the address input
    always @(posedge clk) begin
        instruction = memory[address[7:0]];  // Memory contains 255 locations, so use bits [7:0] from the address
    end
end