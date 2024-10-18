module InstrMem(clk, address, instruction);

    input               clk;             // clock signal
    input [31:0]        address;         // 32-bit instruction address
    output reg [31:0]   instruction;     // instruction to be executed

    //Defining instruction memory, although there is address space for 2^32 locations, here we have 255 for simplicity
    reg [31:0] memory [0:255];

    // Initialize the memory with instructions (in hex)
    integer i;
    initial begin
        memory[0] = 32'h22000005; // ADD R0, R0, #5
        memory[1] = 32'h24400003; // SUB R1, R0, #3
        memory[2] = 32'hA8000000; // NOP
        memory[3] = 32'hA000FFFD; // B #-3
        memory[4] = 32'hC8000000; // NOP

        // Initialize the rest of memory to zero
        for (i = 5; i < 256; i = i + 1) begin
            memory[i] = 32'h00000000;
        end
    end

    // Read instruction from memory based on the address input
    always @(posedge clk) begin
        instruction = memory[address[7:0]];  // Memory contains 255 locations, so use bits [7:0] from the address
    end
endmodule