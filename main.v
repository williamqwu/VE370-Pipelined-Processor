// main driver program for pipelined processor

`timescale 1ns / 1ps
`include "program_counter.v"
`include "next_pc.v"
`include "instru_memory.v"
`include "pr_if_id.v"
`include "register.v"
`include "control.v"
`include "hazard_det.v"
`include "pr_id_ex.v"
`include "alu.v"
`include "alu_control.v"
`include "forward.v"
`include "pr_ex_mem.v"
`include "data_memory.v"
`include "pr_mem_wb.v"

module main(
  input clk // clock signal for PC, RD, PRs
);

  wire [31:0] pc_in;
  wire [31:0] normal_next_pc;
 
  wire [5:0]  ctr_a,
              ctr_b,
              funcode_a,
              funcode_b,
              funcode_d;
  wire [31:0] instru_a,
              instru_b,
              nextpc_a,
              nextpc_b;             

  wire c_RegDst_1_a,c_Jump_1_a,c_Branch_1_a,c_Bne_1_a,
       c_MemRead_1_a,c_MemtoReg_1_a,c_MemWrite_1_a,
       c_ALUSrc_1_a,c_RegWrite_1_a;
  wire [1:0] c_ALUOp_1_a;
  wire c_RegDst_1_b,c_Jump_1_b,c_Branch_1_b,c_Bne_1_b,
       c_MemRead_1_b,c_MemtoReg_1_b,c_MemWrite_1_b,
       c_ALUSrc_1_b,c_RegWrite_1_b;
  wire [1:0] c_ALUOp_1_b;
  wire [31:0] nextpc_d;
  wire [31:0] r_read1_a,
              r_read1_b,
              r_read2_a,
              r_read2_b,r_read2_d;
  wire [31:0] instru_d,instru_f,instru_h;

  wire c_if_flush;

  wire c_PCWrite_w;
  wire c_IFIDWrite_w;
  wire c_clearControl_w;

  wire [3:0] ALUcontrol_out;

  wire [1:0] c_data1_src_w; // forward
  wire [1:0] c_data2_src_w;

  wire [31:0] rData2_ex_fwd;

  wire c_Jump_2_b,c_Branch_2_b,c_Bne_2_b,c_MemRead_2_b,
       c_MemtoReg_2_b,c_MemWrite_2_b,c_RegWrite_2_b;
  wire zero_a,zero_b,zero_reg;
  wire [31:0] ALUresult_a, ALUresult_b;
  wire [4:0] WriteReg_b;
  
  wire c_MemtoReg_3_b, c_RegWrite_3_b;
  wire [4:0] WriteReg_d;

  wire [31:0] memWriteData_a,
              memWriteData_b;

  program_counter asset_pc(
    .clk (clk),
    .bj_next (pc_in),
    .normal_next (normal_next_pc),
    .c_if_flush (c_if_flush),
    .c_PCWrite (c_PCWrite_w),
    .out (nextpc_a)
  );

  instru_memory asset_im(
    .addr (nextpc_a),
    .ctr (ctr_a),
    .funcode (funcode_a),
    .instru (instru_a)
  );

  pr_if_id asset_ifid(
    .clk (clk),
    .c_IFIDWrite (c_IFIDWrite_w),
    .c_if_flush (c_if_flush),
    .ctr_in (ctr_a),
    .funcode_in (funcode_a),
    .instru_in (instru_a),
    .nextpc_in (nextpc_a),
    .ctr (ctr_b),
    .funcode (funcode_b),
    .instru (instru_b),
    .nextpc (nextpc_b), // pc instead of pc+4
    .normal_nextpc (normal_next_pc)
  );

  next_pc asset_nextPc(
    .old (nextpc_b),
    .instru (instru_b),
    .Jump (c_Jump_1_a),
    .Branch (c_Branch_1_a),
    .Bne (c_Bne_1_a),
    .zero (zero_reg),
    .next (pc_in),
    .c_if_flush (c_if_flush)
  );

  hazard_det asset_hDet(
    .id_ex_memRead (c_MemRead_1_b),
    .if_id_instru (instru_b),
    .id_ex_instru (instru_d), // TODO
    .c_PCWrite (c_PCWrite_w),
    .c_IFIDWrite (c_IFIDWrite_w),
    .c_clearControl (c_clearControl_w)
  );

  register asset_reg(
    .clk (clk),
    .instru (instru_b),
    .RegWrite (c_RegWrite_3_b), // from WB stage
    .RegDst (c_RegDst_1_a),
    .WriteData (memWriteData_b), 
    .WriteReg (WriteReg_d), 
    .ReadData1 (r_read1_a),
    .ReadData2 (r_read2_a),
    .reg_zero (zero_reg)
  );

  control asset_control(
    .instru (instru_b),
    .c_clearControl (c_clearControl_w),
    .RegDst (c_RegDst_1_a),
    .Jump (c_Jump_1_a),
    .Branch (c_Branch_1_a),
    .Bne (c_Bne_1_a),
    .MemRead (c_MemRead_1_a),
    .MemtoReg (c_MemtoReg_1_a),
    .ALUOp (c_ALUOp_1_a),
    .MemWrite (c_MemWrite_1_a),
    .ALUSrc (c_ALUSrc_1_a),
    .RegWrite (c_RegWrite_1_a)
  );

  pr_id_ex asset_idex(
    .clk (clk),
    .RegDst_in (c_RegDst_1_a),
    .Jump_in (c_Jump_1_a),
    .Branch_in (c_Branch_1_a),
    .Bne_in (c_Bne_1_a),
    .MemRead_in (c_MemRead_1_a),
    .MemtoReg_in (c_MemtoReg_1_a),
    .ALUOp_in (c_ALUOp_1_a),
    .MemWrite_in (c_MemWrite_1_a),
    .ALUSrc_in (c_ALUSrc_1_a),
    .RegWrite_in (c_RegWrite_1_a),
    .RegDst (c_RegDst_1_b),
    .Jump (c_Jump_1_b),
    .Branch (c_Branch_1_b),
    .Bne (c_Bne_1_b),
    .MemRead (c_MemRead_1_b),
    .MemtoReg (c_MemtoReg_1_b),
    .ALUOp (c_ALUOp_1_b),
    .MemWrite (c_MemWrite_1_b),
    .ALUSrc (c_ALUSrc_1_b),
    .RegWrite (c_RegWrite_1_b),

    .nextPc_in (nextpc_b),
    .nextPc (nextpc_d),
    .ReadData1_in (r_read1_a),
    .ReadData2_in (r_read2_a),
    .funcode_in (funcode_b),
    .ReadData1 (r_read1_b),
    .ReadData2 (r_read2_b),
    .instru_in (instru_b),
    .instru (instru_d),
    .funcode (funcode_d)
  );
  
  alu_control asset_aluControl(
    .ALUOp (c_ALUOp_1_b),
    .instru (funcode_d),
    .ALUcontrol (ALUcontrol_out)
  );

  forward asset_forward(
    .ex_instru (instru_d),
    .ex_mem_instru (instru_f), // should be exactly Rd, not wReg
    .mem_wb_instru (instru_h), // same error, fixed
    .c_ex_mem_RegWrite (c_RegWrite_2_b),
    .c_mem_wb_RegWrite (c_RegWrite_3_b),
    .c_data1_src (c_data1_src_w),
    .c_data2_src (c_data2_src_w)
  );

  alu asset_alu(
    .data1 (r_read1_b),
    .read2 (r_read2_b),
    .instru (instru_d),
    .ALUSrc (c_ALUSrc_1_b),
    .ALUcontrol (ALUcontrol_out),
    .ex_mem_fwd (ALUresult_b),
    .mem_wb_fwd (memWriteData_b),
    .c_data1_src (c_data1_src_w),
    .c_data2_src (c_data2_src_w),
    .data2_fwd (rData2_ex_fwd),
    .data2_fwd_old (r_read2_d),
    .zero (zero_a),
    .ALUresult (ALUresult_a)
  );

  pr_ex_mem asset_exmem(
    .clk (clk),
    .Jump_in (c_Jump_1_b),
    .Branch_in (c_Branch_1_b),
    .Bne_in (c_Bne_1_b),
    .MemRead_in (c_MemRead_1_b),
    .MemtoReg_in (c_MemtoReg_1_b),
    .MemWrite_in (c_MemWrite_1_b),
    .RegWrite_in (c_RegWrite_1_b),
    .RegDst_in (c_RegDst_1_b),
    .Jump (c_Jump_2_b),
    .Branch (c_Branch_2_b),
    .Bne (c_Bne_2_b),
    .MemRead (c_MemRead_2_b),
    .MemtoReg (c_MemtoReg_2_b),
    .MemWrite (c_MemWrite_2_b),
    .RegWrite (c_RegWrite_2_b),

    .zero_in (zero_a),
    .ALUresult_in (ALUresult_a),
    .instru_in (instru_d),
    .regData2_in (r_read2_b),
    .zero (zero_b), // no longer necessary
    .ALUresult (ALUresult_b),
    .WriteReg (WriteReg_b),
    .instru (instru_f),
    .regData2 (r_read2_d)
  );
  
  data_memory asset_dm(
    .clk (clk),
    .addr (ALUresult_b),
    .wData (rData2_ex_fwd), // r_read2_d, "reg.read2 | forward"
    .ALUresult (ALUresult_b),
    .MemWrite (c_MemWrite_2_b),
    .MemRead (c_MemRead_2_b),
    .MemtoReg (c_MemtoReg_2_b),
    .rData (memWriteData_a)
  );

  pr_mem_wb asset_memwb(
    .clk (clk),
    .MemtoReg_in (c_MemtoReg_2_b),
    .RegWrite_in (c_RegWrite_2_b),
    .MemtoReg (c_MemtoReg_3_b),
    .RegWrite (c_RegWrite_3_b),

    .wData_in (memWriteData_a), // data to Reg (W.B.)
    .writeReg_in (WriteReg_b),
    .instru_in (instru_f),
    .wData (memWriteData_b), 
    .writeReg (WriteReg_d),
    .instru (instru_h)
  );

endmodule
