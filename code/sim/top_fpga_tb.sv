`timescale 1ns / 1ps

module top_fpga_tb;
    logic clk_100mhz;
    logic btnC;
    logic [7:0] JB;
    logic [0:0] JC;
    wire [2:0] JA;
    wire Vsync, Hsync;
    wire [3:0] vgaRed, vgaGreen, vgaBlue;

    
    top_fpga dut (.*);

   
    initial clk_100mhz = 0;
    always #5 clk_100mhz = ~clk_100mhz;

    initial begin
        
        $dumpfile("/tmp/przebiegi_pulpit.vcd");
        $dumpvars(0, top_fpga_tb);

        
        btnC = 1; JB = 0; JC = 0;
        #100 btnC = 0;
        #100;

       
        JB[3:0] = 4'b1001; 

        
        #500 JC[0] = 1; 
        
        
        #1000 JC[0] = 0; 

        
        #80000;

        $display("Zakończono symulację. Zapisano przebiegi do /tmp/przebiegi_pulpit.vcd");
        $finish;
    end
endmodule


module clk_wiz_0 (
    input clk_in1,
    input reset,
    output clk_out1,
    output locked
);
    assign clk_out1 = clk_in1;
    assign locked = ~reset;
endmodule