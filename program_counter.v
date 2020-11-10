`timescale 1ns / 1ps

module program_counter(
  input clk,
  input [31:0] next, // the input address
  output reg [31:0] out // the output address
);
  
  initial begin
    out = -4; // NEVER REACHED ADDRESS
    // $display("Init PC: 0x%H",out);
  end

  // always @(next) begin
  //   $display("Next PC: 0x%H",next);
  // end

  always @(posedge clk) begin
    out = next;
  end

endmodule
