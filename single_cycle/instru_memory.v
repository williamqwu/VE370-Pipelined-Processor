`timescale 1ns / 1ps

module instru_memory(
  // input clk,
  input [31:0] addr,
  output [5:0] ctr, // [31-26]
  // output reg [4:0] read1, // [25-21]
  // output reg [4:0] read2, // [20-16]
  // output reg [4:0] write, // [15-11]
  output [31:0] instru // [31-0]
  // output [15:0] num // [15-0]
);

  parameter SIZE_IM = 128; // size of this memory, by default 128*32
  reg [31:0] mem [SIZE_IM-1:0]; // instruction memory

  // TODO: initially read the text file

  assign instru = mem[addr >> 2]; // FIXME: the interval of mem
  assign ctr = instru[31:26];
  // assign num = instru[15:0];

endmodule
