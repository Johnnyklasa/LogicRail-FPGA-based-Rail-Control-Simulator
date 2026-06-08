`timescale 1ns / 1ps

module top_fpga_tb;
    logic clk_100mhz;
    logic btnC;
    logic [15:0] sw;
    wire [2:0] JA;
    wire Vsync, Hsync;
    wire [3:0] vgaRed, vgaGreen, vgaBlue;

    
    top_fpga dut (.*);

    
    initial clk_100mhz = 0;
    always #12.5 clk_100mhz = ~clk_100mhz; 

    initial begin
        
        $dumpfile("/tmp/przebiegi_srk.vcd");
        $dumpvars(0, top_fpga_tb);

        
        btnC = 1; sw = 0;
        #100 btnC = 0;
        
      
        #100 sw[6] = 1; sw[2:0] = 3'd3;
        
          #80000;
        
        $display("Zakończono symulację. Zapisano przebiegi do /tmp/przebiegi_srk.vcd");
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