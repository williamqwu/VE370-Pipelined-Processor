`timescale 1ns / 1ps

module alu_control(
  input [1:0] ALUOp,
  input [5:0] instru,
  output reg [3:0] ALUcontrol
);

  always @(ALUOp, instru) begin
    // $display("** ALUOp: 0x%H",ALUOp);
    case (ALUOp) 
      2'b00:
        ALUcontrol = 4'b0010;
      2'b01:
        ALUcontrol = 4'b0110;
      2'b10: begin
        case (instru)
          6'b100000: // add
            ALUcontrol = 4'b0010;
          6'b100010: // sub
            ALUcontrol = 4'b0110;
          6'b100100: // and
            ALUcontrol = 4'b0000;
          6'b100101: // or
            ALUcontrol = 4'b0001;
          6'b101010: // slt
            ALUcontrol = 4'b0111;
          default:
            ;
        endcase
      end
      2'b11: 
        ALUcontrol = 4'b0000;
      default:
        ;
    endcase
  end

endmodule
