// pipelined register for IF/ID stage

`timescale 1ns / 1ps

module pr_if_id(
  input clk,
  input c_IFIDWrite,
  input c_if_flush,
  input [5:0] ctr_in,
  input [5:0] funcode_in,
  input [31:0] instru_in,
  input [31:0] nextpc_in, // next pc
  output reg [5:0] ctr, // [31-26]
  output reg [5:0] funcode, // [5-0]
  output reg [31:0] instru, // [31-0]
  output reg [31:0] nextpc, // to next_pc.v
  output reg [31:0] normal_nextpc // pc+4, passing to pc
);

  initial begin
    ctr = 6'b111111;
    funcode = 6'b000000;
    instru = 32'b11111100000000000000000000000000;
    nextpc = 32'b0;
    normal_nextpc = 32'b0;
  end

  always @(posedge clk) begin
    if (c_IFIDWrite == 1) begin
      if (c_if_flush == 0) begin
        ctr = ctr_in;
        funcode = funcode_in;
        instru = instru_in;
        nextpc = nextpc_in;
      end else begin
        ctr = 6'b111111;
        funcode = 6'b000000;
        instru = 32'b11111100000000000000000000000000;
        nextpc = 32'b0;
      end
      // $display("funcode @ if/id: 0x%H",funcode);
    end
  end

  always @(*) begin
    normal_nextpc = nextpc_in + 4;
  end

endmodule
