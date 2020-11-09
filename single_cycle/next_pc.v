`timescale 1ns / 1ps

module next_pc(
  input [31:0] old, // the original program addr.
  input [31:0] instru, // the original instruction
    // [15-0] used for sign-extention
    // [25-0] used for shift-left-2
  input Jump,
  input Branch,
  input zero,
  output reg [31:0] next
);

  reg [31:0] sign_ext;
  reg [31:0] old_alter; // pc+4
  reg [31:0] jump; // jump addr.

  always @(old) begin
    old_alter = old + 4;
  end

  always @(instru) begin
    // jump-shift-left
    jump = {4'b0,instru[25:0],2'b0};

    // sign-extension
    if (instru[15] == 1'b0) begin
      sign_ext = {16'b0,instru[15:0]};
    end else begin
      sign_ext = {16'b1,instru[15:0]};
    end
    sign_ext = {instru[29:0],2'b0}; // shift left
  end

  always @(instru or old_alter or jump) begin
    jump = {old_alter[31:28],jump[27:0]};
  end
  
  always @(old_alter,sign_ext,jump,Branch,zero,Jump) begin
    // assign next program counter value
    if (Branch == 1 & zero == 1) begin
      next = old_alter + sign_ext;
    end else begin
      next = old_alter;
    end
    if (Jump == 1) begin 
      next = jump;
    end
  end

endmodule
