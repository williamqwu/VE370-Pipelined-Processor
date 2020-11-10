// testbench for simulation of the single-cycle processor

`timescale 1ns / 1ps
`include "main.v"

module testbench;
  integer currTime;
  reg clk;

  main uut(
    .clk (clk)
  );

  initial begin
    #0
    clk = 0;
    currTime = -10;
    uut.asset_pc.out = -4;
    $display("=========================================================");

    #988 $display("=========================================================");
    #989 $stop;
  end

  always @(posedge clk) begin
    // indicating a posedge clk triggered
    $display("---------------------------------------------------------");
    #1; // wait for writing back
    $display("Time: %d, CLK = %d, PC = 0x%H",currTime, clk, uut.asset_pc.out);
    $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H",uut.asset_reg.RegData[16],uut.asset_reg.RegData[17],uut.asset_reg.RegData[18]);
    $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H",uut.asset_reg.RegData[19],uut.asset_reg.RegData[20],uut.asset_reg.RegData[21]);
    $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H",uut.asset_reg.RegData[22],uut.asset_reg.RegData[23],uut.asset_reg.RegData[8]);
    $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H",uut.asset_reg.RegData[9],uut.asset_reg.RegData[10],uut.asset_reg.RegData[11]);
    $display("[$t4] = 0x%H, [$t5] = 0x%H, [$t6] = 0x%H",uut.asset_reg.RegData[12],uut.asset_reg.RegData[13],uut.asset_reg.RegData[14]);
    $display("[$t7] = 0x%H, [$t8] = 0x%H, [$t9] = 0x%H",uut.asset_reg.RegData[15],uut.asset_reg.RegData[24],uut.asset_reg.RegData[25]);
  end

  always #10 begin
    clk = ~clk;
    currTime = currTime + 10;
  end

endmodule
