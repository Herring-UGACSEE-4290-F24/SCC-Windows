`timescale 1ns/1ps

module SCC_tb;
    // Testbench signals
    wire clk;
    wire reset;

    wire [31:0]   in_mem_addr;     // address pointed to in instruction memory
    wire          in_mem_en;       // enable instruction memory fetch
    wire [31:0]   data_addr;       // address pointed to in data memory
    wire [31:0]   data_out;        // data to write to memory
    wire          data_read;       // control reading data
    wire          data_write;      // control writing data


    // Instantiate the SCC module
    SCC single_cycle_computer (
        .clk(clk),
        .reset(reset), 
        .in_mem_addr(in_mem_addr),
        .data_addr(data_addr),
        .data_out(data_out),
        .data_read(data_read),
        .data_write(data_write)    
    );

     always begin
        clk_s <= 0;
        #10;
        clk_s <= 1;
        #10;
    end

    initial 
        begin
        $dumpvars(0,SCC_tb;
        // Initialize signals
        clk = 0;
        reset = 1;  // Start with reset active

        @(posedge clk_s);

        end
    endmodule