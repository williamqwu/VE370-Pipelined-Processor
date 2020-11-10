// main driver program for single-cycle processor

`timescale 1ns / 1ps
`include "alu_control.v"
`include "alu.v"
`include "control.v"
`include "data_memory.v"
`include "instru_memory.v"
`include "next_pc.v"
`include "program_counter.v"
`include "register.v"

module main(
  input clk // clock signal for PC and RD
);

  wire [31:0] pc_in,
              pc_out;

  wire [5:0] im_ctr;
  wire [5:0] im_funcode;
  wire [31:0] im_instru;

  wire [31:0] r_wbdata, // dm_out
              r_read1,
              r_read2;

  wire  c_RegDst,
        c_Jump,
        c_Branch,
        c_Bne,
        c_MemRead,
        c_MemtoReg,
        c_MemWrite,
        c_ALUSrc,
        c_RegWrite;
  wire [1:0] c_ALUOp;

  wire [3:0] c_ALUcontrol;

  wire c_zero;
  wire [31:0] alu_result;

  // wire [31:0] dm_out;

program_counter asset_pc(
  .clk (clk),
  .next (pc_in),
  .out (pc_out)
);

instru_memory asset_im(
  .addr (pc_out),
  .ctr (im_ctr),
  .funcode (im_funcode),
  .instru (im_instru)
);

register asset_reg(
  .clk (clk),
  .instru (im_instru),
  .RegWrite (c_RegWrite),
  .RegDst (c_RegDst),
  .WriteData (r_wbdata),
  .ReadData1 (r_read1),
  .ReadData2 (r_read2)
);

alu asset_alu(
  .data1 (r_read1),
  .read2 (r_read2),
  .instru (im_instru),
  .ALUSrc (c_ALUSrc),
  .ALUcontrol (c_ALUcontrol),
  .zero (c_zero),
  .ALUresult (alu_result)
);

alu_control asset_aluControl(
  .ALUOp (c_ALUOp),
  .instru (im_funcode),
  .ALUcontrol (c_ALUcontrol)
);

control asset_control(
  .instru (im_instru),
  .RegDst (c_RegDst),
  .Jump (c_Jump),
  .Branch (c_Branch),
  .Bne (c_Bne),
  .MemRead (c_MemRead),
  .MemtoReg (c_MemtoReg),
  .ALUOp (c_ALUOp),
  .MemWrite (c_MemWrite),
  .ALUSrc (c_ALUSrc),
  .RegWrite (c_RegWrite)
);

data_memory asset_dm(
  .clk (clk),
  .addr (alu_result), // im_instru
  .wData (r_read2),
  .ALUresult (alu_result),
  .MemWrite (c_MemWrite),
  .MemRead (c_MemRead),
  .MemtoReg (c_MemtoReg),
  .rData (r_wbdata)
);

next_pc asset_nextPc(
  .old (pc_out),
  .instru (im_instru),
  .Jump (c_Jump),
  .Branch (c_Branch),
  .Bne (c_Bne),
  .zero (c_zero),
  .next (pc_in)
);

endmodule
