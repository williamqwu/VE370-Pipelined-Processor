// pipelined register for EX/MEM stage

`timescale 1ns / 1ps

module pr_ex_mem(
  input clk,
  input Jump_in, // MEM
  input Branch_in, // MEM
  input Bne_in, // MEM
  input MemRead_in, // MEM
  input MemtoReg_in, // WB
  input MemWrite_in, // MEM 
  input RegWrite_in, // WB
  output reg Jump, 
  output reg Branch, 
  output reg Bne,
  output reg MemRead,
  output reg MemtoReg,
  output reg MemWrite,
  output reg RegWrite,

  input zero_in,
  input [31:0] ALUresult_in,
  input [4:0] WriteReg_in, // w.b. to Reg
  output zero,
  output [31:0] ALUresult,
  output [4:0] WriteReg
);

  // TODO: add support for EX.Flush

  initial begin
    // TODO: add initial condition
  end

  always @(posedge clk) begin
    // TODO  
  end

endmodule
