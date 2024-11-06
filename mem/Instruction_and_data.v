`timescale 1ns/1ps

module Instruction_and_data
(
  input mem_Clk,
  input instruction_memory_en,
  input [31:0] instruction_memory_a,
  input [31:0] data_memory_a,
  input data_memory_read, 
  input data_memory_write,
  input [31:0] data_memory_out_v,
  output reg [31:0] instruction_memory_v,
  output reg [31:0] data_memory_in_v
);
reg [7:0] memory [0:(2**16)-1] ; //Maximum array to hold both instruction and data memory
integer i;
integer file;

initial begin
  for (i = 0; i < (2**16)-1; i = i + 1) begin
    memory[i] = 8'b00000000; //initialize zero
  end
  $readmemh("output.mem", memory);
  end
always @(*) begin
    if(instruction_memory_en)begin //Grabs 32 bit instruction
    instruction_memory_v[31:24] <= memory[instruction_memory_a];
    instruction_memory_v[23:16] <= memory[instruction_memory_a+1];
    instruction_memory_v[15:8] <= memory[instruction_memory_a+2];
    instruction_memory_v[7:0] <= memory[instruction_memory_a+3];
    #2;
    end
    else if (~instruction_memory_en) begin //When low the SCC program pauses until set back to high which continues fetching instructions
    instruction_memory_v <= 'hFFFFFFFF;
    end
  if(data_memory_read) begin //Load instruction
    data_memory_in_v[31:24] <=memory[data_memory_a];
    data_memory_in_v[23:16] <=memory[data_memory_a+1];
    data_memory_in_v[15:8] <=memory[data_memory_a+2];
    data_memory_in_v[7:0] <=memory[data_memory_a+3];
  end
  if(data_memory_write) begin //Store instruction
    memory[data_memory_a] <= data_memory_out_v[31:24];
    memory[data_memory_a+1] <= data_memory_out_v[23:16];
    memory[data_memory_a+2] <= data_memory_out_v[15:8];
    memory[data_memory_a+3] <= data_memory_out_v[7:0];
    data_memory_in_v <= 'bx;
  end
end
always @(negedge instruction_memory_en) begin
  // Open a file for writing
  file = $fopen("scc_dump.csv", "w");
  if (file == 0) begin
    $display("Error: Could not open file.");
    $finish;
  end

  // Write header for CSV file
  $fwrite(file, "Address,Value\n");

  // Write memory contents to the CSV file
  for (i = 0; i < (2**16)-1; i = i + 4) begin
    $fwrite(file, "0x%8h,0x%2h%2h%2h%2h\n", i, memory[i], memory[i+1], memory[i+2], memory[i+3]);
  end

  // Close the file
  $fclose(file);

  $display("Memory contents dumped to memory_dump.csv");
  $finish;
end
endmodule

