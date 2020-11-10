`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/02 00:47:53
// Design Name: 
// Module Name: shiftLeft
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


module shiftLeft(X,Sh);
    input [31:0] X;
    output [31:0] Sh;
    parameter z=2'b00;
    assign Sh={X[29:0],z};
endmodule
