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
  input RegDst_in, // EX, only used here
  output reg Jump, 
  output reg Branch, 
  output reg Bne,
  output reg MemRead,
  output reg MemtoReg,
  output reg MemWrite,
  output reg RegWrite,

  input zero_in,
  input [31:0] ALUresult_in,
  input [31:0] instru_in, // receive instru and transf to WriteReg (w.b. to Reg)
  input [31:0] regData2_in,
  output reg zero,
  output reg [31:0] ALUresult,
  output reg [4:0] WriteReg,
  output reg [31:0] instru,
  output reg [31:0] regData2
);

  // TODO: add support for EX.Flush

  initial begin
    Jump = 0;
    Branch = 0;
    Bne = 0;
    MemRead = 0;
    MemtoReg = 0;
    MemWrite = 0;
    RegWrite = 0;
  end

  always @(posedge clk) begin
    Jump = Jump_in;
    Branch = Branch_in;
    Bne = Bne_in;
    MemRead = MemRead_in;
    MemtoReg = MemtoReg_in;
    MemWrite = MemWrite_in;
    RegWrite = RegWrite_in;
    instru = instru_in;

    zero = zero_in;
    ALUresult = ALUresult_in;
    regData2 = regData2_in;
    if (RegDst_in == 1'b0) begin
      WriteReg = instru_in[20:16];
    end else begin
      WriteReg = instru_in[15:11];
    end
  end

endmodule
