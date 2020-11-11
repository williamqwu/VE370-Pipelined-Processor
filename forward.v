// forwarding unit, in stage EX

module forward(
  input [31:0] ex_instru, // ID/EX.instru
  input [31:0] ex_mem_instru, // EX/MEM.WriteReg
  input [31:0] mem_wb_instru, // MEM/WB.WriteReg
  input c_ex_mem_RegWrite, // EX/MEM.RegWrite
  input c_mem_wb_RegWrite, // MEM/WB.RegWrite
  output reg [1:0] c_data1_src, // ALU.data1.src (A)
  output reg [1:0] c_data2_src // ALU.data2.src (B)
);
  // Note: ex_instru[25:21] == ID/EX.Rs
  //       ex_instru[20:16] == ID/EX.Rt
  reg [4:0] ex_mem_wReg,mem_wb_wReg; // exactly Rd
  
  // if I-type, use Rt; if R-type, use Rd
  always @(*) begin
    if(ex_mem_instru[31:26] == 0) begin
      ex_mem_wReg = ex_mem_instru[15:11];
    end else begin
      ex_mem_wReg = ex_mem_instru[20:16]; // I
    end
    if(mem_wb_instru[31:26] == 0) begin
      mem_wb_wReg = mem_wb_instru[15:11];
    end else begin
      mem_wb_wReg = mem_wb_instru[20:16]; // I
    end
  end

  always @(ex_instru,ex_mem_wReg,mem_wb_wReg,c_ex_mem_RegWrite,c_mem_wb_RegWrite) begin
    // $display("ex_mem: 0x%H | mem_wb: 0x%H ",ex_mem_instru,mem_wb_instru);
    if(c_ex_mem_RegWrite==1 & (ex_mem_wReg != 0) & (ex_mem_wReg == ex_instru[25:21])) begin
      c_data1_src = 2'b10; // from EX/MEM
    end else if (c_mem_wb_RegWrite==1 & (mem_wb_wReg != 0) & (mem_wb_wReg == ex_instru[25:21]) &
    !(c_ex_mem_RegWrite==1 & (ex_mem_wReg != 0) & (ex_mem_wReg == ex_instru[25:21]))) begin
      c_data1_src = 2'b01; // from from MEM/WB
    end else begin
      c_data1_src = 2'b00; // from current stage
    end
  end

  always @(ex_instru,ex_mem_wReg,mem_wb_wReg,c_ex_mem_RegWrite,c_mem_wb_RegWrite) begin
    if(c_ex_mem_RegWrite==1 & (ex_mem_wReg != 0) & (ex_mem_wReg == ex_instru[20:16])) begin
      c_data2_src = 2'b10; // from EX/MEM
    end else if (c_mem_wb_RegWrite==1 & (mem_wb_wReg != 0) & (mem_wb_wReg == ex_instru[20:16]) &
    !(c_ex_mem_RegWrite==1 & (ex_mem_wReg != 0) & (ex_mem_wReg == ex_instru[20:16]))) begin
      c_data2_src = 2'b01; // from from MEM/WB
    end else begin
      c_data2_src = 2'b00; // from current stage
    end
  end
  
endmodule


// TODO: [bonus] merge from LYR: beq hazard (forwarding)
module Forwarding_bonus( // created by lyr
    input [4:0] IF_ID_Rs,IF_ID_Rt,ID_EX_Rs,ID_EX_Rt,EX_MEM_Rd,MEM_WB_Rd,
    // note: MEM_WB_Rd is destination of MEM/WB register, for lw & addi: rt, add: rd
    input EX_MEM_RegWrite,MEM_WB_RegWrite,ID_beq,ID_bne,
    output reg [1:0] FullFwdA,FullFwdB,
    output reg BranFwdA,BranFwdB
);

initial begin
    FullFwdA=2'b00;
    FullFwdB=2'b00;
    BranFwdA=1'b0;
    BranFwdB=1'b0;
end

always @(*) begin // FullFwdA
if ((ID_EX_Rs == EX_MEM_Rd) && EX_MEM_RegWrite && (EX_MEM_Rd!=5'b0))  // R-format
    FullFwdA=2'b10;

else if ((ID_EX_Rs == MEM_WB_Rd) && MEM_WB_RegWrite && (MEM_WB_Rd!=5'b0))  // lw & R-format
    FullFwdA=2'b01;

else 
    FullFwdA=2'b00;
end

always @(*) begin // FullFwdB
if ((ID_EX_Rt == EX_MEM_Rd) && EX_MEM_RegWrite && (EX_MEM_Rd!=5'b0)) 
    FullFwdB=2'b10;

else if ((ID_EX_Rt == MEM_WB_Rd) && MEM_WB_RegWrite && (MEM_WB_Rd!=5'b0)) 
    FullFwdB=2'b01;

else 
    FullFwdB=2'b00;

end

always @(*) begin //BranFwdA
    if((ID_beq || ID_bne) && (IF_ID_Rs == EX_MEM_Rd) && (EX_MEM_Rd!=5'b0) && EX_MEM_RegWrite) 
        BranFwdA=1'b1;
   
    else
        BranFwdA=1'b0;
   
end


always @(*) begin //BranFwdB
    if((ID_beq || ID_bne) && (IF_ID_Rt == EX_MEM_Rd) && (EX_MEM_Rd!=5'b0) && EX_MEM_RegWrite) 
        BranFwdB=1'b1;
   
    else
        BranFwdB=1'b0;
    
end

endmodule