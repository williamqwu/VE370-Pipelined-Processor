`timescale 1ns / 1ps

module data_memory(
  input clk,
  input [31:0] addr,
  input [31:0] wData,
  input [31:0] ALUresult,
  input MemWrite,
  input MemRead,
  input MemtoReg,
  output reg [31:0] rData
);

  parameter SIZE_DM = 128; // size of this memory, by default 128*32
  reg [31:0] mem [SIZE_DM-1:0]; // instruction memory

  // initially set default data to 0
  integer i;
  initial begin
    for(i=0; i<SIZE_DM-1; i=i+1) begin
      mem[i] = 32'b0;
    end
  end

  always @(addr or MemRead or MemtoReg or ALUresult) begin
    if (MemRead == 1) begin
      if (MemtoReg == 1) begin
        rData = mem[addr];
        // $display("lw data: 0x%H @addr: 0x%H",rData,addr);
      end else begin
        rData = ALUresult; // X ?
      end
    end else begin
      rData = ALUresult;
    end
  end

  always @(posedge clk) begin // MemWrite, wData, addr
    if (MemWrite == 1) begin
      // $display("MemWrite: 0x%H @addr: 0x%H",wData,addr);
      mem[addr] = wData;
    end
  end

endmodule
