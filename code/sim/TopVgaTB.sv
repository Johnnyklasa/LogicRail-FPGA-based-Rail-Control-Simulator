
`timescale 1ns / 1ps

module TopVgaTB;

logic clk, rst;
wire vs, hs;
wire [3:0] r, g, b;
logic [11:0] X_POS, Y_POS;
logic [1:0] Semafor1Signal;

TopVga dut (
    .clk(clk),
    .rst(rst),
    .X_POS(X_POS),
    .Y_POS(Y_POS),
    .Semafor1Signal(Semafor1Signal),
    .vs(vs),
    .hs(hs),
    .r(r),
    .g(g),
    .b(b)
);

always begin
    #1 clk =~clk;
end

always begin 
    #20000
    if (Semafor1Signal==  2'h3) begin
        Semafor1Signal = 2'h1;
    end
    else begin
        Semafor1Signal = Semafor1Signal + 2'h1;
    end
end


initial begin
 X_POS = 12'd44;
 Y_POS = 12'd44;
 rst = 1'b1;
 clk =1'b0;
 Semafor1Signal = 2'h1;
 #40
 rst =1'b0;
#50000;
 X_POS = 12'd250;
 Y_POS = 12'd250;
#50000;
 $finish;
end




endmodule
