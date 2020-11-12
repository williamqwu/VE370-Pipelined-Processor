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

module bonus_hazard(
input branch,IDEXregwrite,IDEXmemread,EXMEMmemread,EXMEMregwrite,jump,equal,
input [4:0] ReadReg1,ReadReg2,
input [4:0] IDEXrd,IDEXrt,IFIDrs,IFIDrt,EXMEMrt,
output reg IDflush,EXflush,PCwrite,IFIDwrite,
output IFflush
    );
initial begin
IDflush=0;
EXflush=0;
PCwrite=1;
IFIDwrite=1;
end

always@(*) begin
if (IDEXmemread==1 && (IDEXrt==IFIDrs || IDEXrt==IFIDrt)) begin // lw 
PCwrite=0;
IFIDwrite=0;
IDflush=1;
end

if (branch) begin
if (IDEXregwrite && IDEXrd!=5'b0 && (IDEXrd==ReadReg1 || IDEXrd==ReadReg2)) begin // r-format 1&2 hazard
PCwrite=0;
IFIDwrite=0;
IDflush=1;
end
if (IDEXregwrite && IDEXrd==5'b0 && (IDEXrt==ReadReg1 || IDEXrt==ReadReg2)) begin // andi 1&2 hazard
PCwrite=0;
IFIDwrite=0;
IDflush=1;
end
if (IDEXmemread && (IDEXrt==ReadReg1 || IDEXrt==ReadReg2)) begin // lw 1&2 hazard
PCwrite=0;
IFIDwrite=0;
IDflush=1;
end
if (EXMEMmemread && (EXMEMrt==ReadReg1 || EXMEMrt==ReadReg2)) begin // lw 1&3 hazard
PCwrite=0;
IFIDwrite=0;
IDflush=1;
EXflush=1;
end
end
end

assign IFflush=(~PCwrite && branch && equal) || jump; // FIXME
endmodule
