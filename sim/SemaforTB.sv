
module SemaforTB;

logic clk;
logic rst;
logic MouseSignal;
logic [1:0] OutSignal;

Semafor dut(
    .clk(clk),
    .rst(rst),
    .SignalIn(MouseSignal),
    .OutSignal(OutSignal)
);

always  begin
  #1 clk = ~clk; 
end

always  begin
  #10 MouseSignal = ~MouseSignal;
end



initial begin
   rst = 1'b0;
   clk = 1'b0;
   MouseSignal = 1'b0;
   #65;
   rst = 1'b1;
   #4;
   rst =1'b0;  
   #100; 
end

endmodule
