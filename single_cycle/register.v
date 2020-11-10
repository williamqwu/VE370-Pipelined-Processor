`timescale 1ns / 1ps

module register(
  input clk,
  input [31:0] instru, // the raw 32-bit instruction
  input RegWrite,
  input RegDst,
  input [31:0] WriteData, // from WB stage
  // input [4:0] WriteReg,
  output [31:0] ReadData1,
  output [31:0] ReadData2
);

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
    if (RegWrite == 1'b1) begin // FIXME: timing issue?
      // $display("Reg_WriteData: 0x%H",WriteData);
      if (RegDst == 1'b0) begin
        RegData[instru[20:16]] = WriteData;
      end else begin
        RegData[instru[15:11]] = WriteData;
      end
    end
  end

endmodule
