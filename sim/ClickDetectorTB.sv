
module ClickDetectorTB;

logic pos_edge;
logic neg_edge;
logic Signal;
logic clk;

ClickDetector dut(
    .clk(clk),
    .Signal(Signal),
    .neg_edge(neg_edge),
    .pos_edge(pos_edge)
);


always begin
    #1 clk = ~clk;
end

initial begin
    clk= 1'b0;
    Signal =1'b0;
    #20;
    Signal = 1'b1;
    #20;
    Signal = 1'b0;
    #5;
    $finish;
end

endmodule
