// modified from VE270-Lab5 code

`timescale 1ns / 1ps

module ssd(q, ssd);
  input [3:0] q; 
  output [6:0] ssd;
  reg [6:0] ssd;
  
  always @(q) begin
    case (q)
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
      4'b1010: ssd <= 7'b0001000;
      4'b1011: ssd <= 7'b1100000;
      4'b1100: ssd <= 7'b0110001;
      4'b1101: ssd <= 7'b1000010;
      4'b1110: ssd <= 7'b0110000;
      4'b1111: ssd <= 7'b0111000;
    endcase  
  end
endmodule
