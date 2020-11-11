// pipelined register for IF/ID stage

`timescale 1ns / 1ps

module pr_if_id(
  input clk,
  input [5:0] ctr_in,
  input [5:0] funcode_in,
  input [31:0] instru_in,
  input [31:0] nextpc_in, // next pc
  output reg [5:0] ctr, // [31-26]
  output reg [5:0] funcode, // [5-0]
  output reg [31:0] instru, // [31-0]
  output reg [31:0] nextpc
);

  initial begin
    ctr = 6'b111111;
    funcode = 6'b000000;
    instru = 32'b11111100000000000000000000000000;
    nextpc = 32'b0;
  end

  always @(posedge clk) begin
    ctr = ctr_in;
    funcode = funcode_in;
    instru = instru_in;
    nextpc = nextpc_in;
  end

endmodule
