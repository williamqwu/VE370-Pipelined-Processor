`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/02 00:29:45
// Design Name: 
// Module Name: instruct_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module instruct_mem(Addr,Clk,Inst);//指令存储器
    input[31:0]Addr;
    input Clk;
    //input InsMemRW;//状态为'0'，写指令寄存器，否则为读指令寄存器
    output[31:0]Inst;
    reg [7:0]Rom[255:0];
    //assign Inst=Rom[Addr[6:2]];
    
    always @(posedge Clk)
    begin
        //initial begin
            $readmemb("InstructionMem_for_P2_Demo.mem", Rom);
        //end
    end
    
    assign Inst[31:0] = {Rom[Addr], Rom[Addr+1], Rom[Addr+2], Rom[Addr+3]};

endmodule
