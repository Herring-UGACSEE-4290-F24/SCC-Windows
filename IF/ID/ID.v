//
// Instruction Decode Implementation
// Handles instruction outputted from fetch tied together in the scc
// 

module ID(Instruction)
    input [31:0]        Instruction

    //R-type
    output reg  [10:0]  opcode      //bits [31:21]  (also utlized in load store)
    output reg  [4:0]   Rm          //bits [20:16]
    output reg  [5:0]   shamt       //bits [15:10]
    output reg  [4:0]   Rn          //bits [9:5]    (also utlized in load store)
    output reg  [4:0]   Rd          //bits [4:0]


    //need I type and D type
    

	

begin
  
    
    
endmodule