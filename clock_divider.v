// modified from VE270-Lab5 code

`timescale 1ns / 1ps

// original driver program
module main(clk, reset, A, ssd);
  input clk, reset;
  output [3:0]A;
  output [6:0] ssd;
  wire [3:0] ql, qr;
  wire d500;
  wire d1;
  wire [6:0] sl, sr;  
  reg [6:0] ssd;
  
  divider500 di500(clk,reset,d500);
  divider1 di1(d500,reset,d1);
  ring_cnt_4 rt(reset,d500,A);
  timer tmr(d1,reset,ql,qr);
  tssd outssd1(ql,sl);
  tssd outssd2(qr,sr);
  
  always @(posedge clk) begin
    case (A)
      4'b1110: ssd = sr;
      4'b1101: ssd = sl;
      4'b1011: ssd = 6'b1111111;
      4'b0111: ssd = 6'b1111111;
    endcase
  end
endmodule

module divider500(clock, reset, clk_500);
  parameter MAXN = 200000;
  input clock, reset;
  output clk_500;
//  output [17:0] cnt;
  reg [17:0] cnt = 18'b0;
  reg clk_500 = 0;
  
  always @(posedge clock or posedge reset)
  begin
    if (reset == 1)
      begin
        clk_500 <= 0;
        cnt <= 18'b0;
      end
    else if (cnt == MAXN-1)
      begin
        clk_500 <= 1;
        cnt <= 18'b0;
      end
    else
      begin
        cnt <= cnt + 1;
        clk_500 <= 0;
      end
  end
endmodule

module divider1(clk_500, reset, clk_1);
  parameter MAXN = 500;
  input clk_500, reset;
  output clk_1;
//  output [8:0] cnt;
  reg [8:0] cnt = 9'b0;
  reg clk_1 = 0;
  
  always @(posedge clk_500 or posedge reset)
  begin
    if (reset == 1)
      begin
        clk_1 <= 0;
        cnt <= 9'b0;
      end
    else if (cnt == MAXN-1)
      begin
        clk_1 <= 1;
        cnt <= 9'b0;
      end
    else
      begin
        cnt <= cnt + 1;
        clk_1 <= 0;
      end
  end
endmodule

module ring_cnt_4(reset, clk_500, A);
  input reset, clk_500;
  output [3:0] A;
  reg [3:0] A = 4'b1110;
  
  always @(posedge clk_500 or posedge reset)
  begin
    if (reset) A <= 4'b1110;
    else begin
      A[1] <= A[0];
      A[2] <= A[1];
      A[3] <= A[2];
      A[0] <= A[3];
    end
  end
endmodule

module timer(clk_1,reset,ql,qr);
  input clk_1, reset;
  output [3:0] ql,qr;
  reg [3:0] ql = 4'b0;
  reg [3:0] qr = 4'b0;
  
  always @(posedge clk_1 or posedge reset) begin
    if (reset) begin
      ql <= 4'b0;
      qr <= 4'b0;
    end
    else if(qr == 4'b1001) begin
      if (ql == 4'b0101) begin
        qr <= 0;
        ql <= 0;
      end
      else begin
        qr <= 0;
        ql <= ql + 1;
      end
    end
    else qr <= qr + 1;
  end
endmodule
