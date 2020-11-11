// pipelined register for MEM/WB stage

`timescale 1ns / 1ps

module pr_mem_wb(
  input clk,
  input MemtoReg_in, // WB
  input RegWrite_in, // WB
  output reg MemtoReg,
  output reg RegWrite,

  input [31:0] wData_in,
  input [4:0] writeReg_in,
  output reg [31:0] wData,
  output reg [4:0] writeReg
);

  initial begin
    MemtoReg = 0;
    RegWrite = 0;
  end

  always @(posedge clk) begin
    MemtoReg = MemtoReg_in;
    RegWrite = RegWrite_in;

    wData = wData_in;
    writeReg = writeReg_in;
  end

endmodule
