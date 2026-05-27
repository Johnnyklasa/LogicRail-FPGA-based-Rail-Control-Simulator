module top_fpga(
        input  wire clk,
        input  wire btnC,
        output wire Vsync,
        output wire Hsync,
        output wire [3:0] vgaRed,
        output wire [3:0] vgaGreen,
        output wire [3:0] vgaBlue,
        output wire JA1,
        inout  wire PS2Clk,
        inout  wire PS2Data
    );

wire clk40Mhz, clk100Mhz;
wire pclk;
 wire pclk_mirror;


endmodule
