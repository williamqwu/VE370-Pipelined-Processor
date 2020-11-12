// hazard detection unit

module hazard_det(
  input id_ex_memRead, // ID/EX.MemRead
  input [31:0] if_id_instru, // IF/ID.instru
  input [31:0] id_ex_instru, // ID/EX.instru
  output reg c_PCWrite, // -> PC
  output reg c_IFIDWrite, // -> IF/ID pipelined reg
  output reg c_clearControl // -> control (ID/EX.Flush) 
  // FIXME: bool convention
);
  // id_ex_instru[20:16]: ID/EX.Rt
  // if_id_instru[25:21]: IF/ID.Rs
  // if_id_instru[20:16]: IF/ID.Rt

  initial begin
    c_PCWrite = 1;
    c_IFIDWrite = 1;
    c_clearControl = 0;
  end

  always @(*) begin
    if (id_ex_memRead==1 && ((id_ex_instru[20:16] == if_id_instru[25:21]) || (id_ex_instru[20:16] == if_id_instru[20:16]))) begin
      c_PCWrite = 0; // if PCWrite==0, don't write in new instruction, IM decode the current instruction again
      c_IFIDWrite = 0; // if IF_ID_Write==0, IF/ID register keeps the current instruction
      c_clearControl = 1; // if ID_EX_Flush=1, all control signals in ID/EX are 0
    end else begin
      c_PCWrite = 1;
      c_IFIDWrite = 1;
      c_clearControl = 0;
    end
  end

endmodule


module Hazard_bonus( // TODO: [bonus] consider control hazard: branch
  // created by lyr
    input [4:0] IF_ID_Rs,IF_ID_Rt,ID_EX_Rt,EX_MEM_Rt,ID_EX_Rd,
    input ID_EX_MemRead,EX_MEM_MemRead,ID_beq,ID_bne,ID_EX,RegWrite,ID_jump,ID_equal,ID_EX_RegWrite,
    output PCWrite,IF_ID_Write,ID_EX_Flush,IF_Flush
);

wire PCHold; // if PCHold==1, hold PC and IF/ID

assign PCHold = ( (ID_EX_MemRead) && (ID_EX_Rt == IF_ID_Rs || ID_EX_Rt == IF_ID_Rt) ) // lw hazard
                || ( (ID_beq || ID_bne) && (ID_EX_MemRead) && (ID_EX_Rt == IF_ID_Rs || ID_EX_Rt == IF_ID_Rt) ) // lw followed by branch
                || ( (ID_beq || ID_bne) && (EX_MEM_MemRead) && (EX_MEM_Rt == IF_ID_Rs || EX_MEM_Rt == IF_ID_Rt) ) // lw followed by nop and then branch
                || ( (ID_beq || ID_bne) && (ID_EX_RegWrite) && (ID_EX_Rd != 5'b0) && (ID_EX_Rd == IF_ID_Rs || ID_EX_Rd == IF_ID_Rt) ) // R-format followed by branch
                || ( (ID_beq || ID_bne) && (ID_EX_RegWrite) && (ID_EX_Rd == 5'b0) && (ID_EX_Rt == IF_ID_Rs || ID_EX_Rt == IF_ID_Rt) ); // addi followed by branch

// note we leave out the case that R-format followed by a nop then a branch, because that is solved by forwarding path
assign PCWrite=~PCHold; // if PCWrite==0, don't write in new instruction, IM decode the current instruction again

assign IF_ID_Write=~PCHold; // if IF_ID_Write==0, IF/ID register keeps the current instruction

assign ID_EX_Flush=PCHold; // if ID_EX_Flush=1, all control signals in ID/EX are 0 (implemented in ID/EX register later)
 
assign IF_Flush = (PCHold==0) && ( (ID_jump) || (ID_beq && ID_equal) || (ID_bne && ID_equal)); 

endmodule
