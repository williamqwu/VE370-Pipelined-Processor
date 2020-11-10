`timescale 1ns / 1ps

module next_pc(
  input [31:0] old, // the original program addr.
  input [31:0] instru, // the original instruction
    // [15-0] used for sign-extention
    // [25-0] used for shift-left-2
  input Jump,
  input Branch,
  input Bne,
  input zero,
  output reg [31:0] next
);

  reg [31:0] sign_ext;
  reg [31:0] old_alter; // pc+4
  reg [31:0] jump; // jump addr.
  reg zero_alter;

  initial begin
    next = 32'b0;
    // $display("NEXT: 0x%H",next);
  end

  always @(old) begin
    old_alter = old + 4;
  end

  always @(zero,Bne) begin
    zero_alter = zero;
    if (Bne == 1) begin
      zero_alter = ! zero_alter;
    end
    // $display("zero: %d | zero_alter: %d",zero,zero_alter);
  end

  always @(instru) begin
    // jump-shift-left
    jump = {4'b0,instru[25:0],2'b0};

    // sign-extension
    // $display("original instru: 0x%H",instru);
    if (instru[15] == 1'b0) begin
      // $display("next_pc:: positive addr_dev");
      sign_ext = {16'b0,instru[15:0]};
    end else begin
      // $display("next_pc:: negative addr_dev");
      sign_ext = {{16{1'b1}},instru[15:0]};
    end
    // $display("sign_ext: 0x%H",sign_ext);
    sign_ext = {sign_ext[29:0],2'b0}; // shift left
    // $display("sign_ext: 0x%H",sign_ext);
  end

  always @(instru or old_alter or jump) begin
    jump = {old_alter[31:28],jump[27:0]};
  end
  
  always @(old_alter,sign_ext,jump,Branch,zero_alter,Jump) begin
    // assign next program counter value
    if (Branch == 1 & zero_alter == 1) begin
      // $display("Taking branch");
      next = old_alter + sign_ext;
    end else begin
      // $display("Normal proceeding");
      next = old_alter;
    end
    if (Jump == 1) begin
      // $display("Taking jump");
      next = jump;
    end
  end

endmodule
