`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/02 00:42:03
// Design Name: 
// Module Name: sign_ext
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


module sign_ext(X, Se, Y);
    input [15:0] X;
    input Se;               // 0 for zero extension, 1 for sign extension
    output [31:0] Y;
    wire [31:0] E0, E1;
    wire [15:0] e = {16{X[15]}};
    parameter z = 16'b0;
    assign E0 = {z, X};
    assign E1 = {e, X};
    mux2x32 i(E0, E1, Se, Y);
endmodule   
