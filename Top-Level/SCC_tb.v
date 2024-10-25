`timescale 1ns/1ps

module SCC_tb;
    // Testbench signals
    reg clk;
    reg reset;


    wire [31:0]   in_mem;
    wire [31:0]   data_in;
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
        .in_mem(in_mem), 
        .data_in(data_in),
        .in_mem_addr(in_mem_addr),
        .data_addr(data_addr),
        .data_out(data_out)   
    );

    initial begin
        $dumpvars(0,SCC_tb);
        clk = 1'b0;
        reset = 1'b1;
        #10 clk = 1'b1;
        #5 reset = 1'b0;
        #5 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        #10 clk = 1'b1;
        #10 clk = 1'b0;
        //forever begin
        //    #10 clk = ~clk;
        //end
    end
endmodule