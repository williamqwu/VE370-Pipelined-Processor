`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/02 00:22:34
// Design Name: 
// Module Name: CLA32
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


module CLA32(a,b,ci,s,co);
    input   [31:0]  a,b;
    input  ci;
    output   [31:0]   s;
    output co;
    wire  g_out,p_out;
    cla_32  cla   (a,b, ci,g_out,p_out, s); 
    assign  co  =  g_out| p_out &  ci;
endmodule




module add(a,b,c,g,p,s);
    input a,b,c;
    output g,p,s;
    assign s = a^b^c;
    assign g = a & b;
    assign p = a | b;
endmodule



module g_p  (g,p,c_in,g_out,p_out,c_out);
    input  [1:0]  g,p;
    input  c_in;
    output g_out, p_out, c_out;
    assign g_out = g[1]|p[1] & g[0];
    assign p_out = p[1]  & p[0];
    assign c_out = g[0]   |  p[0]  &  c_in;
endmodule

module cla_2 (a,b,c_in,g_out,p_out,s) ;
    input  [1:0]  a,b;
    input c_in;
    output g_out, p_out;
    output  [1:0]  s;
    wire  [1:0]  g,p;
    wire c_out;
    add add0 (a[0],b[0],c_in, g[0],p[0],s[0]);
    add add1 (a[1],b[1],c_out, g[1],p[1],s[1]);
    g_p g_p0 (g,p,c_in,  g_out,p_out,c_out);
endmodule

module cla_4 (a,b, c_in,g_out,p_out,s);
    input  [3:0]  a,b;
    input  c_in;
    output g_out, p_out;
    output  [3:0]  s;
    wire  [1:0]  g,p;
    wire c_out;
    cla_2 cla0 (a[1:0],b[1:0],c_in, g[0],p[0],s[1:0]);
    cla_2 clal (a[3:2],b[3:2],c_out,g[1],p[1],s[3:2]);
    g_p    g_p0  (g,p,c_in, g_out,p_out,c_out);
endmodule

module  cla_8   (a,b, c_in,g_out,p_out, s);
    input   [7:0]  a,b;
    input  c_in;
    output  g_out, p_out;
    output   [7:0]   s;
    wire   [1:0]   g,p;
    wire  c_out;
    cla_4  cla0  (a[3:0],b[3:0],c_in, g[0],p[0],s[3:0]);
    cla_4  c1a1  (a[7:4],b[7:4],c_out,g[1],p[1],s[7:4]);
    g_p   g_p0  (g,p,c_in,  g_out,p_out,c_out);
endmodule

module cla_16 (a,b, c_in,g_out,p_out, s);
    input   [15:0]  a,b;
    input  c_in;
    output  g_out, p_out;
    output   [15:0]  s;
    wire  [1:0]  g,p;
    wire  c_out;
    cla_8  cla0   (a[7:0],b[7:0],c_in,g[0],p[0],s[7:0]);
    cla_8  cla1   (a[15:8],b[15:8],c_out,g[1],p[1],s[15:8]);
    g_p    g_p0  (g,p,c_in,  g_out,p_out,c_out);
endmodule

module cla_32  (a,b,c_in,g_out,p_out, s);
    input  [31:0]  a,b;
    input c_in;
    output  g_out, p_out;
    output  [31:0]  s;
    wire  [1:0]  g,p;
    wire c_out;
    cla_16 c1a0 (a[15:0],b[15:0],c_in,g[0],p[0],s[15:0]);
    cla_16 c1a1 (a[31:16],b[31:16],c_out,g[1],p[1],s[31:16]);
    g_p    g_p0  (g,p,c_in, g_out,p_out,c_out);
endmodule
