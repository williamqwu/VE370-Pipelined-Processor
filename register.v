`timescale 1ns / 1ps

// in stage ID
module register(
  input clk,
  input [31:0] instru, // the raw 32-bit instruction
  input RegWrite,
  input RegDst,
  input [31:0] WriteData, // from WB stage
  input [4:0] WriteReg, // from WB stage
  output [31:0] ReadData1,
  output [31:0] ReadData2
);

  // TODO: deal with the output (next_pc related)`
  

  reg [31:0] RegData [31:0]; // register data
  
  // initialize the regester data
  integer i;
  initial begin
    for(i=0;i<32;i=i+1) begin
      RegData[i] = 32'b0;
    end
  end

  assign ReadData1 = RegData[instru[25:21]];
  assign ReadData2 = RegData[instru[20:16]];

  always @(posedge clk) begin // RegWrite, RegDst, WriteData, instru)
    if (RegWrite == 1'b1) begin
      // $display("Reg_WriteData: 0x%H | WriteReg: %d",WriteData, WriteReg);
      RegData[WriteReg] = WriteData;
    end
  end

  // TODO: add a comparator that handles branch hazard

endmodule
