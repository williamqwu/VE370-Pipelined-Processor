// hazard detection unit

// TODO: bonus (beq detection)

module Hazard_bonus( // consider control hazard: branch
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

module Hazard( // only consider load word data hazard
  // created by lyr 
    input [4:0] IF_ID_Rs,IF_ID_Rt,ID_EX_Rt,
    input ID_EX_MemRead,
    output PCWrite,IF_ID_Write,ID_EX_Flush
);
wire PCHold; // if PCHold==1, hold PC and IF/ID

assign PCHold=(ID_EX_MemRead) && (ID_EX_Rt==IF_ID_Rs || ID_EX_Rt==IF_ID_Rt); // lw hazard

assign PCWrite=~PCHold; // if PCWrite==0, don't write in new instruction, IM decode the current instruction again

assign IF_ID_Write=~PCHold; // if IF_ID_Write==0, IF/ID register keeps the current instruction

assign ID_EX_Flush=PCHold; // if ID_EX_Flush=1, all control signals in ID/EX are 0 (implemented in ID/EX register later)

endmodule