module ringCounter(
    input clk,
    output reg [3:0] SSDring
);

always@(posedge clk)begin
    if (SSDring==4'b1110) SSDring<=4'b1101;
    else if (SSDring==4'b1101) SSDring<=4'b1011;
    else if (SSDring==4'b1011) SSDring<=4'b0111;
    else  // SSDring==4'b0111
    SSDring<=4'b1110;
end
endmodule
