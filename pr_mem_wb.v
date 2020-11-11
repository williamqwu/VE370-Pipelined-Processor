// pipelined register for MEM/WB stage

`timescale 1ns / 1ps

module pr_mem_wb(
  input clk,
  input MemtoReg_in, // WB
  input RegWrite_in, // WB
  output reg MemtoReg,
  output RegWrite,

  input [31:0] wData_in,
  input [4:0] writeReg_in,
  output reg [31:0] wData,
  output reg [4:0] writeReg
);

  initial begin
    // TODO: add initial condition
  end

  always @(posedge clk) begin
    // TODO  
  end

endmodule
