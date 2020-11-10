`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/02 00:21:52
// Design Name: 
// Module Name: PCAdder
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


module PCAdder(PC_o,PCadd4);
    input [31:0] PC_o;//偏移量
    output [31:0] PCadd4;//新指令地址
    wire Cout;
    CLA32 cla32(PC_o,4,0, PCadd4, Cout);
endmodule
