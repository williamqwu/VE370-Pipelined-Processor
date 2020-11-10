`timescale 1ns / 1ps

module instru_memory(
  // input clk,
  input [31:0] addr,
  output reg [5:0] ctr, // [31-26]
  output reg [5:0] funcode, // [5-0]
  // output reg [4:0] read1, // [25-21]
  // output reg [4:0] read2, // [20-16]
  // output reg [4:0] write, // [15-11]
  output reg [31:0] instru // [31-0]
  // output [15:0] num // [15-0]
);

  parameter SIZE_IM = 128; // size of this memory, by default 128*32
  reg [31:0] mem [SIZE_IM-1:0]; // instruction memory

  integer n;
  initial begin
    for(n=0;n<SIZE_IM;n=n+1) begin
      mem[n] = 32'b11111100000000000000000000000000;
    end
    $readmemb("C:\\Users\\William Wu\\Documents\\Mainframe Files\\UMJI-SJTU\\1 Academy\\20 Fall\\VE370\\Project\\p2\\single_cycle\\testcases\\test_beq.txt",mem);
    // for(n=0;n<SIZE_IM;n=n+1) begin
    //   // $display("0x%H",mem[n]);
    // end
    instru = 32'b11111100000000000000000000000000;
  end

  always @(addr) begin
    if (addr == -4) begin // init
      instru = 32'b11111100000000000000000000000000;
    end else begin
      instru = mem[addr >> 2];
    end
    ctr = instru[31:26];
    funcode = instru[5:0];
  end
  // assign num = instru[15:0];

endmodule
