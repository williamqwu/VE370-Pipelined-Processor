// forwarding unit

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