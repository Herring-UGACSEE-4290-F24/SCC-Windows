//
// Instruction Decode Implementation
// Handles instruction outputted from fetch tied together in the scc
// 


// Instruction Encoding according to class isa
// 31-30 1LD                (First Level Decoding which determines the instruction type)
// 29    Special_encoding                  (Special Encoding for ALU)
// 28-25 2LD                (Second level decode)
// 27-25 ALU   OC           (ALU OC)
// 24-21 B. Cond            
// 24-22 Destination Reg    
// 21-19 op 1 reg
// 18-16 op 2 reg
// 15-0  Immediate

module ID(clk, Instruction)
    input clk;
    input [31:0]     Instruction;        //Instruction that was fetched

    output reg [1:0]        1LD;                    
    output reg              Special_encoding;
    output reg [3:0]        2LD;
    output reg [2:0]        ALU_OC;
    output reg [3:0]        B_cond;
    output reg [2:0]        dest_reg;
    output reg [2:0]        pointer_reg;
    output reg [2:0]        op_1_reg;
    output reg [2:0]        op_2_reg;
    output reg [15:0]       immediate;
    output reg [15:0]       offset;
    output reg [3:0]        flags;
    always@(posedge clk)  
    begin
    1LD[1:0] = Instruction[31:30];                  //Determines Instruction type




    //Data|Immediate
    if(1LD == {0,0})                                 //bit 28 is set flags bit
        begin 
        if(Instruction[29:25] = {0,0,0,0,0})        //Mov Command
            begin
                dest_reg[2:0] = Instruction[24:22];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {0,0,0,0,1})  //Movt command  
            begin 
                dest_reg[2:0] = Instruction[24:22];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {1,0,0,0,1})  //add
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {1,1,0,0,1})  //adds
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {1,0,0,1,0})  //sub
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {1,1,0,1,0})  //subs
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {1,0,0,1,1})  //and
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
       else if (Instruction[29:25] = {1,1,0,1,1})  //ands
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {1,0,1,0,0})  //or 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {1,1,1,0,0})  //ors 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {1,0,1,0,1})  //xor 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0]; 
            end
        else if (Instruction[29:25] = {1,1,1,0,1})  //xors 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {0,0,1,0,0})  //lsl 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {0,0,1,0,1})  //lsr 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {0,0,0,1,0})  //clr 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        else if (Instruction[29:25] = {0,0,0,1,1})  //set
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
            end
        end

    
    //Data|Register 

    else if (1LD == {0,1})              
        begin
    if (Instruction[29:25] = {1,0,0,0,1})  //add
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                op_2_reg[2:0] = Instruction[18:16];
            end
        else if (Instruction[29:25] = {1,1,0,0,1})  //adds
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                op_2_reg[2:0] = Instruction[18:16];
            end
        else if (Instruction[29:25] = {1,0,0,1,0})  //sub
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                op_2_reg[2:0] = Instruction[18:16];
            end
        else if (Instruction[29:25] = {1,1,0,1,0})  //subs
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                op_2_reg[2:0] = Instruction[18:16];
            end
        else if (Instruction[29:25] = {1,0,0,1,1})  //and
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                op_2_reg[2:0] = Instruction[18:16];
            end
       else if (Instruction[29:25] = {1,1,0,1,1})  //ands
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                op_2_reg[2:0] = Instruction[18:16];
            end
        else if (Instruction[29:25] = {1,0,1,0,0})  //or 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                op_2_reg[2:0] = Instruction[18:16];
            end
        else if (Instruction[29:25] = {1,1,1,0,0})  //ors 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                op_2_reg[2:0] = Instruction[18:16];
            end
        else if (Instruction[29:25] = {1,0,1,0,1})  //xor 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                op_2_reg[2:0] = Instruction[18:16];
            end
        else if (Instruction[29:25] = {1,1,1,0,1})  //xors 
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
                op_2_reg[2:0] = Instruction[18:16];
            end
        else if (Instruction[29:25] = {1,0,1,1,0})  //NOT
            begin 
                dest_reg[2:0] = Instruction[24:22];
                op_1_reg[2:0] = Instruction[21:19];
            end
        end



    //Load/Store    (bits 29-26 don't care) 
    else if (1LD == {1,0})                     
        begin
            if(Instruction[25])         //Store instruction since bit 25 high 
                begin
                    dest_reg[2:0] =  Instruction[24:22];          
                    pointer_reg[2:0] =  Instruction[21:19];
                    immediate[15:0] = Instruction[15:0];
                end
            else                        //Load Instruction since bit 25 is low
                begin
                    dest_reg[2:0] =  Instruction[24:22];          
                    pointer_reg[2:0] =  Instruction[21:19];
                    immediate[15:0] = Instruction[15:0];
                end
        end
    
    
    //System|Branch
    else if (1LD == {1,1})             
        begin
            if(Instruction[28:25] == {0,0,0,0})         //branch unconditonal
                begin 
                immediate[15:0] = Instruction[15:0];
                end
            else if (Instruction[28:25] == {0,0,0,1})   //branch conditonal
                begin 
                flags[3:0] = Instruction[24:21];
                immediate[15:0] = Instruction[15:0];
                end
            else if (Instruction[28:25] == {0,0,1,0})   //BR
                begin 
                pointer_reg[2:0] =  Instruction[21:19];
                immediate[15:0] = Instruction[15:0];
                end
            else if (Instruction[27] == 1)              //NOP
               begin 
                //Does nothing, literally!
                end 
            else if (Instruction[28] == 1)              //HALT
                begin
                //Sets a flag to stop the CPU from bit 28
                end
        end

    end
   
  
    
    
endmodule