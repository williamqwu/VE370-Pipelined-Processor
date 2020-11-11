`timescale 1ns / 1ps

// in stage ID
module register(
  input clk,
  input [31:0] instru, // the raw 32-bit instruction
  input RegWrite, // from WB stage!
  input RegDst,
  input [31:0] WriteData, // from WB stage
  input [4:0] WriteReg, // from WB stage
  output reg [31:0] ReadData1,
  output reg [31:0] ReadData2,
  output reg reg_zero // comparator result
);
 
  reg [31:0] RegData [31:0]; // register data
  
  // initialize the register data
  integer i;
  initial begin
    for(i=0;i<32;i=i+1) begin
      RegData[i] = 32'b0;
    end
  end

  always @(*) begin
    if(WriteReg==instru[25:21] && RegWrite==1) begin
      ReadData1 = WriteData;
    end else begin
      ReadData1 = RegData[instru[25:21]];
    end
    
    if(WriteReg==instru[20:16] && RegWrite==1) begin
      ReadData2 = WriteData;
    end else begin
      ReadData2 = RegData[instru[20:16]];
    end
  end

  always @(posedge clk) begin // RegWrite, RegDst, WriteData, instru)
    if (RegWrite == 1'b1) begin
      $display("Reg_WriteData: 0x%H | WriteReg: %d",WriteData, WriteReg);
      RegData[WriteReg] = WriteData;
    end
  end

  always @(*) begin
    if (ReadData1 == ReadData2) begin 
      reg_zero = 1;
    end else begin
      reg_zero = 0;
    end
  end

endmodule
