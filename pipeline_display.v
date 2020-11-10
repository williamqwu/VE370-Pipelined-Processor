`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/10 17:02:02
// Design Name: 
// Module Name: pipeline_display
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


module pipeline_display(

    );
    reg [7:0] count_clock = 0;
always @(posedge clock)
 begin
  $display ("TIME = %0d, CLK = %0d, PC = %h", count_clock * 10000, count, PC_out);
  count_clock = count_clock + 1;
        #1 $display (" ");
        #1 $display ("[$s0] = %h, [$s1] = %h, [$s2] = %h", RegData16, RegData17, RegData18);
        #1 $display (" ");
        #1 $display ("[$s3] = %h, [$s4] = %h, [$s5] = %h", RegData19, RegData20, RegData21);
        #1 $display (" ");
        #1 $display ("[$s6] = %h, [$s7] = %h, [$t0] = %h", RegData22, RegData23, RegData8);
        #1 $display (" ");
        #1 $display ("[$t1] = %h, [$t2] = %h, [$t3] = %h", RegData9, RegData10, RegData11);
        #1 $display (" ");
        #1 $display ("[$t4] = %h, [$t5] = %h, [$t6] = %h", RegData12, RegData13, RegData14);
        #1 $display (" ");
        #1 $display ("[$t7] = %h, [$t8] = %h, [$t9] = %h", RegData15, RegData24, RegData25);
        #1 $display (" ");
 end
endmodule
