// pipelined register for ID/EX stage

`timescale 1ns / 1ps

module pr_id_ex(
  input clk,
  // this can be modified to one 11-bit control signal, but I'm running out of time...
  input RegDst_in, // EX
  input Jump_in, // MEM
  input Branch_in, // MEM
  input Bne_in, // MEM
  input MemRead_in, // MEM
  input MemtoReg_in, // WB
  input [1:0] ALUOp_in, // EX
  input MemWrite_in, // MEM 
  input ALUSrc_in, // EX
  input RegWrite_in, // WB
  output reg RegDst,
  output reg Jump,
  output reg Branch,
  output reg Bne, // 1 indicates bne
  output reg MemRead,
  output reg MemtoReg,
  output reg [1:0] ALUOp,
  output reg MemWrite,
  output reg ALUSrc,
  output reg RegWrite,

  input [31:0] nextPc_in, // from pc
  output reg [31:0] nextPc,
  input [31:0] ReadData1_in, // from reg
  input [31:0] ReadData2_in, 
  input [5:0] funcode_in,
  output reg [31:0] ReadData1,
  output reg [31:0] ReadData2,
  output reg [5:0] funcode,
  input [31:0] instru_in, // raw instruction from IF/ID-reg
  output reg [31:0] instru
);

  initial begin
    RegDst = 0;
    Jump = 0;
    Branch = 0;
    Bne = 0;
    MemRead = 0;
    MemtoReg = 0;
    ALUOp = 2'b00;
    MemWrite = 0;
    ALUSrc = 0;
    RegWrite = 0;
  end

  always @(posedge clk) begin
    RegDst = RegDst_in;
    Jump = Jump_in;
    Branch = Branch_in;
    Bne = Bne_in;
    MemRead = MemRead_in;
    MemtoReg = MemtoReg_in;
    ALUOp = ALUOp_in;
    MemWrite = MemWrite_in;
    ALUSrc = ALUSrc_in;
    RegWrite = RegWrite_in;

    nextPc = nextPc_in;
    ReadData1 = ReadData1_in;
    ReadData2 = ReadData2_in;
    funcode = funcode_in;
    instru = instru_in;
  end

endmodule
