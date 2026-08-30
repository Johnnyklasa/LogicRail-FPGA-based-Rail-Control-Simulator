//Autor: Karol sitko
module DrawMouse (
    input  logic clk,
    input  logic rst_n,
    input logic [11:0] X_POS,
    input logic [11:0] Y_POS,
    vga_if.in vga_in,
    vga_if.out vga_out

);

timeunit 1ns;
timeprecision 1ps;

vga_if vga_nxt();

logic blank;
assign blank = (vga_in.hblnk||vga_in.vblnk);

MouseDisplay u_Mouse_Display (
    .pixel_clk(clk),
    .xpos(X_POS),
    .ypos(Y_POS),
    .hcount(vga_in.hcount), 
    .vcount(vga_in.vcount),
    .blank(blank),
    .rgb_in(vga_in.rgb),
    .enable_mouse_display_out(),
    .rgb_out(vga_out.rgb)
);  




always_ff @(posedge clk) begin 
    if (!rst_n) begin
        vga_out.vcount <= '0;
        vga_out.vsync  <= '0;
        vga_out.vblnk  <= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk  <= '0;
    end
    else begin
        vga_out.vcount <= vga_in.vcount;
        vga_out.vsync  <= vga_in.vsync;
        vga_out.vblnk  <= vga_in.vblnk;
        vga_out.hcount <= vga_in.hcount;
        vga_out.hsync  <= vga_in.hsync;
        vga_out.hblnk  <= vga_in.hblnk;
    end
end

endmodule
