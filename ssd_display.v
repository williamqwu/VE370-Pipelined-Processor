`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/10 18:13:16
// Design Name: 
// Module Name: ssd_display
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ssd_display(clock, reset, cathod, annode, switch, PC, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, 
reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31);
    input clock, reset;
    input [5:0] switch;
    input [31:0] PC, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13;
    input [31:0] reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
    output [3:0] annode;
    output [6:0] cathod;
    // reg [3:0] annode;
    // reg [6:0] cathod;
    wire clk;

    
    clock_divider clk_divide(clock, clk);
    select Select(reset, switch, PC,reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, 
reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31, out);
    display Disp(clk, reset, out, cathod, annode);
    
    
endmodule

module clock_divider(clock, clk);
    input clock;
    output clk;
    reg clk;
    reg [18:0] count = 0;
    parameter MAX = 200000;
    
    always @ (posedge clock) begin
        if (count == MAX - 1) begin
            clk <= 1;
            count <= 0;
        end
        else begin
            clk <= 0;
            count <= count + 1;
        end
    end
    
endmodule

module display(clock, reset, value, cathod, annode);
    input clock, reset;
    input [31:0] value;
    output [6:0] cathod;
    output [3:0] annode;
    reg [3:0] annode = 0;
    reg [6:0] cathod = 0;
    wire [6:0] digit3;
    wire [6:0] digit2;
    wire [6:0] digit1;
    wire [6:0] digit0;
    
    ssd SSD0 (value[3:0], digit0);
    ssd SSD1 (value[7:4], digit1);
    ssd SSD2 (value[11:8], digit2);
    ssd SSD4 (value[15:12], digit3);
    
    reg [2:0] ring = 0;
    always @(posedge clock) begin
        if (reset == 1) begin
            annode <= 4'b0000;
            cathod <= 6'b111111;
        end
        else begin
            case(ring)
            0: begin
                annode <= 4'b1000;
                cathod <= digit3;
                ring <= 1;
            end
            1: begin
                annode <= 4'b0100;
                cathod <= digit2;
                ring <= 2;
            end
            2: begin
                annode <= 4'b0010;
                cathod <= digit1;
                ring <= 3;
            end
            3: begin
                annode <= 4'b0001;
                cathod <= digit0;
                ring <= 0;
            end
            default: begin
                annode <= 4'b0000;
                cathod <= 6'b111111;
                ring <= 0;
            end
            endcase
        end
    end        
endmodule

module select(reset, switch, PC,reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13, 
reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31, out);
    input reset;
    input [5:0] switch;
    input [31:0] PC, reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9, reg10, reg11, reg12, reg13;
    input [31:0] reg14, reg15, reg16, reg17, reg18, reg19, reg20, reg21, reg22, reg23, reg24, reg25, reg26, reg27, reg28, reg29, reg30, reg31;
    output [31:0] out;
    reg [31:0] out;
    always @(switch or reset) begin
    if (reset == 1) out <= 0;
    else begin
        case(switch)
            0: out <= PC;
            1: out <= reg1;
            2: out <= reg2;
            3: out <= reg3;
            4: out <= reg4;
            5: out <= reg5;
            6: out <= reg6;
            7: out <= reg7;
            8: out <= reg8;
            9: out <= reg9;
            6'd10: out <= reg10;
            6'd11: out <= reg11;
            6'd12: out <= reg12;
            6'd13: out <= reg13;
            6'd14: out <= reg14;
            6'd15: out <= reg15;
            6'd16: out <= reg16;
            6'd17: out <= reg17;
            6'd18: out <= reg18;
            6'd19: out <= reg19;
            6'd20: out <= reg20;
            6'd21: out <= reg21;
            6'd22: out <= reg22;
            6'd23: out <= reg23;
            6'd24: out <= reg24;
            6'd25: out <= reg25;
            6'd26: out <= reg26;
            6'd27: out <= reg27;
            6'd28: out <= reg28;
            6'd29: out <= reg29;
            6'd30: out <= reg30;
            6'd31: out <= reg31;
            default: out <= 0;
        endcase
    end 
    end
endmodule
        
module ssd(q, ssd);
  input [3:0] q; 
  output [6:0] ssd;
  reg [6:0] ssd;
  
  always @(q) begin
    case (q)
      0: ssd <= 7'b0000001;
      1: ssd <= 7'b1001111;
      2: ssd <= 7'b0010010;
      3: ssd <= 7'b0000110;
      4: ssd <= 7'b1001100;
      5: ssd <= 7'b0100100;
      6: ssd <= 7'b0100000;
      7: ssd <= 7'b0001111;
      8: ssd <= 7'b0000000;
      9: ssd <= 7'b0000100;
      4'b1010: ssd <= 7'b0001000;
      4'b1011: ssd <= 7'b1100000;
      4'b1100: ssd <= 7'b0110001;
      4'b1101: ssd <= 7'b1000010;
      4'b1110: ssd <= 7'b0110000;
      4'b1111: ssd <= 7'b0111000;
    endcase  
  end
endmodule