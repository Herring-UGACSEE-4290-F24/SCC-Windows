module TestBench(clk, reset, instruction, results)

    wire           clk            // clock signal
    wire           reset          // reset signal

    wire [31:0]    instruction    // instruction to be executed
    reg [31:0]     results        // results of SCC


    // Clock generation (I think every testbench needs one)
    always begin
        clk_s <= 0;
        #10;
        clk_s <= 1;
        #10;
    end

    initial begin
        $dumpvars(0,TestBench);

        




        #10;
        $finish;
    end
endmodule