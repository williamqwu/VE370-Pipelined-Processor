`timescale 1ns / 1ps

module program_counter(
  input clk,
  input [31:0] next, // the input address
  output reg [31:0] out // the output address
);
  
  initial begin
    out = 32'b0;
    // $display("Init PC: 0x%H",out);
  end

  always @(posedge clk) begin
    out = next;
  end

endmodule
