`timescale 1ns / 1ps

module alu_control(
  input [1:0] ALUOp,
  input [5:0] instru,
  output reg [3:0] ALUcontrol
);

  always @(ALUOp, instru) begin
    case (ALUOp) 
      2'b00:
        ALUcontrol = 4'b0010;
      2'b01:
        ALUcontrol = 4'b0110;
      2'b10: 
        // FIXME: check completenesss
        case (instru)
          6'b100000:
            ALUcontrol = 4'b0010;
          6'b100010:
            ALUcontrol = 4'b0110;
          6'b100100:
            ALUcontrol = 4'b0000;
          6'b100101:
            ALUcontrol = 4'b0001;
          6'b101010:
            ALUcontrol = 4'b0111;
          default:
            ;
        endcase
      default:
        ;
    endcase
  end

endmodule
