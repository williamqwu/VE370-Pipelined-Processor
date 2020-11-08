`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/02 00:42:43
// Design Name: 
// Module Name: mux2x32
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


module mux2x32(A0,A1,S,Y);
    input [31:0] A0,A1;
    input S;
    output [31:0] Y;
    function [31:0] select;
        input [31:0] A0,A1;
        input S;
        case(S)
            0:select=A0;
            1:select=A1;
        endcase
    endfunction
    assign Y=select(A0,A1,S);
endmodule