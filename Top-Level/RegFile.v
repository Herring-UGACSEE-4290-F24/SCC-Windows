module RegFile(clk, r_addr_0, r_addr_1, w_addr, w_enable, w_select, w_alu, w_id, r_val_0, r_val_1);

    /===========================================  I/O  ===================================================/
    input                    clk         //Clock signal
    input [2:0]              r_addr_0    //Read port 0 address
    input [2:0]              r_addr_1    //Read port 1 address
    input [2:0]              w_addr      //Write port address
    input                    w_enable    //Enables writing to regs (active high)
    input                    w_select    //Mux select for ALU/ID writing to reg files, 0 = ALU, 1 = ID
    input [31:0]             w_alu       //Write data to reg from ALU stage
    input [31:0]             w_id        //Write data to reg from ID stage

    output wire [31:0]       r_val_0     //Read port 0 output value
    output wire [31:0]       r_val_1     //Read port 1 output value
    /=====================================================================================================/

    //Defining register file, there are 2^3 = 8 registers, each 32 bits wide
    reg [31:0] registers [0:7];

    //Assigns read port 0/1 output the value of the register pointed to by read port 0/1 input address, when the address is updated.
    //(Reads are performed asynchronously)
    always @(r_addr_0) begin
        assign r_val_0 <= registers[r_addr_0[2:0]]; //Read port 0
    end
    
    always @(r_addr_1) begin
        assign r_val_1 <= registers[r_addr_1[2:0]]; //Read port 1
    end

    // Write value from w_alu or w_id, dependent on control line w_select, to register pointed to by w_addr, if w_enable is active.
    //(Writes are performed synchronously) 
    always @(posedge clk) begin
        if (w_enable) begin 
            if (w_select)
                registers[w_addr[2:0]] = w_id;
            else
                registers[w_addr[2:0]] = w_alu;
        end
    end

endmodule