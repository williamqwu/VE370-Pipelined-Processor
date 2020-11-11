`timescale 1ns / 1ps

module alu(
  input [31:0] data1,
  input [31:0] read2, // candidate for data2
  input [31:0] instru, // candidate for data2; used for sign-extension
  input ALUSrc,
  input [3:0] ALUcontrol,

  input [31:0] ex_mem_fwd, // forwarded data from EX/MEM
  input [31:0] mem_wb_fwd, // forwarded data from MEM/WB
  input [1:0] c_data1_src,
  input [1:0] c_data2_src,

  output reg [31:0] data2_fwd, // connect to DM
  input [31:0] data2_fwd_old,
  output reg zero,
  output reg [31:0] ALUresult
);

  // reg [31:0] data2;
  
  // signextension module for ALU + basic MUX
  // always @(*) begin
  //   if (ALUSrc == 0) begin
  //     data2 = read2;
  //   end else begin
  //     // SignExt[Instru[15:0]]
  //     if (instru[15] == 1'b0) begin
  //       data2 = {16'b0,instru[15:0]};
  //     end else begin
  //       data2 = {{16{1'b1}},instru[15:0]};
  //     end
  //   end
  //   // $display("ALU_data2: 0x%H",data2);
  // end

  reg [31:0] data1_fin;
  reg [31:0] data2_fin;


  always @(*) begin
    case (c_data1_src)
      2'b00: // from current stage
        data1_fin = data1;
      2'b10: // from EX/MEM
        data1_fin = ex_mem_fwd;
      2'b01: // from from MEM/WB
        data1_fin = mem_wb_fwd;
      default:
        $display ("Error: data1_src wrong.");
    endcase
    $display ("FORWARD: SRC1=%d",c_data1_src);
  end

  always @(*) begin
    if (ALUSrc == 0) begin
      case (c_data2_src)
        2'b00: begin// from current stage
          data2_fin = read2;
          data2_fwd = data2_fwd_old;
        end
        2'b10: begin// from EX/MEM
          data2_fin = ex_mem_fwd;
          data2_fwd = data2_fin;
        end
        2'b01: begin// from from MEM/WB
          data2_fin = mem_wb_fwd;
          data2_fwd = data2_fin;
        end
        default:
          $display ("Error: data2_src wrong.");
      endcase
      $display ("FORWARD: SRC2=%d",c_data2_src);
      
    end else begin
      // SignExt[Instru[15:0]]
      if (instru[15] == 1'b0) begin
        data2_fin = {16'b0,instru[15:0]};
      end else begin
        data2_fin = {{16{1'b1}},instru[15:0]};
      end
      // $display("ALU_data2: 0x%H",data2_fin);
      // data2_fwd = data2_fwd_old;
    end
  end

  always @(data1_fin, data2_fin, ALUcontrol) begin
    case (ALUcontrol)
      4'b0000: // AND
        ALUresult = data1_fin & data2_fin;
      4'b0001: // OR
        ALUresult = data1_fin | data2_fin;
      4'b0010: // ADD
        ALUresult = data1_fin + data2_fin;
      4'b0110: // SUB
        ALUresult = data1_fin - data2_fin;
      4'b0111: // SLT
        ALUresult = (data1_fin < data2_fin) ? 1 : 0;
      4'b1100: // NOR
        ALUresult = data1_fin |~ data2_fin;
      default:
        ;
    endcase
    if (ALUresult == 0) begin
      zero = 1;
    end else begin
      zero = 0;
    end
    $display("ALUcontrol | d1 | d2 | ALU_result: 0x%H | 0x%H | 0x%H | 0x%H",ALUcontrol,data1_fin,data2_fin,ALUresult);
  end

endmodule
