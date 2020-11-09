`timescale 1ns / 1ps

module program_counter(
  input clk,
  input [31:0] next, // the input address
  output reg [31:0] out // the output address
);
  
  // TODO: initial begin of out?

  always @(posedge clk) begin
    out = next;
  end

endmodule
