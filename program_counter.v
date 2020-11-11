`timescale 1ns / 1ps

// Note: this module self-implements a 2-to-1 MUX that handles the next pc address.
//    exception is not required to handle here.

module program_counter(
  input clk,
  input [31:0] bj_next, // the input address; result from next stage
  input [31:0] normal_next, // normal next pc (pc+4)
  input c_if_flush, // if not asserted, pc=pc+4
  input c_PCWrite, // if not asserted, the PC won't move on 
  output reg [31:0] out // the output address
);
  
  initial begin
    out = -4; // NEVER REACHED ADDRESS
    // $display("Init PC: 0x%H",out);
  end

  // always @(next) begin
  //   $display("Next PC: 0x%H",next);
  // end

  always @(posedge clk) begin
    if (c_PCWrite == 1) begin
      if (c_if_flush == 0) begin
        out = normal_next;
      end else begin
        out = bj_next;
      end
    end
  end

endmodule
