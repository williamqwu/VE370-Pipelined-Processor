`timescale 1ns / 1ps
`include "main.v"

module driver(
  input clk,
  input reset,
  input [3:0] switch,
  output [3:0] A,
  output [6:0] ssd
);

  reg [15:0] data;
  reg clock;

  initial begin
    clock = 0;
  end

  always @(*) begin
    data = uut.asset_reg.RegData[switch][15:0]; // FIXME: separate reg?
  end

  always @(*) begin
    clock = ~reset;
  end

  io asset_io(clk, reset, data, A, ssd);

  main uut(
    .clk (clk)
  );

endmodule

module io(
  input clk, reset,
  input [15:0] data,
  output [3:0] A, // anode
  output reg [6:0] ssd // cathod
);

  wire d500;
  wire [6:0] o1,o2,o3,o4;  
  // reg [6:0] ssd;

  // reg [15:0] const = 16'b0000000100100011;
  
  divider500 di500(clk,reset,d500);
  ring_cnt_4 rt(reset,d500,A);

  tssd outssd1(data[3:0],o1); // left-most
  tssd outssd2(data[7:4],o2);
  tssd outssd3(data[11:8],o3);
  tssd outssd4(data[15:12],o4); // right-most
  
  // always @(*) begin
  //   const = {{4{switch[0]}},{4{switch[1]}},{4{switch[2]}},{4{switch[3]}}};
  // end
  always @(posedge clk) begin
    case (A)
      4'b1110: ssd = o1;
      4'b1101: ssd = o2;
      4'b1011: ssd = o3;
      4'b0111: ssd = o4;
    endcase
  end
endmodule


module divider500(clock, reset, clk_500);
  parameter MAXN = 200000;
  input clock, reset;
  output clk_500;
  reg [17:0] cnt = 18'b0;
  reg clk_500 = 0;
  
  always @(posedge clock or posedge reset)
  begin
    if (reset == 1)
      begin
        // clk_500 <= 0;
        // cnt <= 18'b0;
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


module ring_cnt_4(reset, clk_500, A);
  input reset, clk_500;
  output [3:0] A;
  reg [3:0] A = 4'b1110;
  
  always @(posedge clk_500 or posedge reset)
  begin
    if (reset) ; //  A <= 4'b1110
    else begin
      A[1] <= A[0];
      A[2] <= A[1];
      A[3] <= A[2];
      A[0] <= A[3];
    end
  end
endmodule

module tssd(number, ssd); // to ssd
  input [3:0] number;
  output [6:0] ssd;
  reg [6:0] ssd;
  
  always @(*) begin
    case (number)
      0: ssd <= 7'b0000001;
      1: ssd <= 7'b1001111;
      2: ssd <= 7'b0010010;
      3: ssd <= 7'b0000110;
      4: ssd <= 7'b1001100;
      5: ssd <= 7'b0100100;
      6: ssd <= 7'b0100000;
      7: ssd <= 7'b0001111;
      8: ssd <= 7'b0000000;
      9: ssd <= 7'b0000100;
      4'b1010: ssd <= 7'b0001000; // A
      4'b1011: ssd <= 7'b1100000;
      4'b1100: ssd <= 7'b0110001;
      4'b1101: ssd <= 7'b1000010;
      4'b1110: ssd <= 7'b0110000;
      4'b1111: ssd <= 7'b0111000;
    endcase  
  end
endmodule