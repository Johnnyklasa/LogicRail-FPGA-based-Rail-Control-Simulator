module TopVga(
    input logic clk,
    input logic rst,

    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b

);

    vga_if vga_tim();
    vga_if vga_sem();

    assign vs = vga_sem.vsync;
    assign hs = vga_sem.hsync;
    assign {r,g,b} = vga_sem.rgb;
    assign vga_tim.rgb = 12'h0_0_0;


vga_timing u_vga_timing (
        .clk,
        .rst (rst),
        .vcount (vga_tim.vcount),
        .vsync  (vga_tim.vsync),
        .vblnk  (vga_tim.vblnk),
        .hcount (vga_tim.hcount),
        .hsync  (vga_tim.hsync),
        .hblnk  (vga_tim.hblnk)
    );

DrawSemafor u_DrawSemafor(
    .clk(clk),
    .rst(rst),
    .vga_in(vga_tim),
    .vga_out(vga_sem),
    .signal(2'b01)
);




endmodule
