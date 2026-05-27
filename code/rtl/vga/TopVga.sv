module TopVga(
    input logic clk,
    input logic rst,
    input logic [11:0]  X_POS,
    input logic [11:0]  Y_POS,
    input logic [1:0] Semafor1Signal,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b,
    inout wire PS2Data,
    inout wire PS2Clk
);

logic [11:0] x_mouse, y_mouse;
logic [11:0] x_s1, x_s2, y_s1, y_s2;


always_ff @(posedge clk) begin
    x_s1 <= X_POS;
    x_s2 <= x_s1;
    y_s1 <= Y_POS;
    y_s2 <= y_s1;
end

vga_if vga_tim();
vga_if vga_sem();
vga_if vga_mouse();

assign vs = vga_mouse.vsync;
assign hs = vga_mouse.hsync;
assign {r,g,b} = vga_mouse.rgb;
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
        .signal(Semafor1Signal)
);

DrawMouse u_DrawMouse(
        .clk(clk),
        .rst(rst),
        .X_POS(x_s2),
        .Y_POS(y_s2),
        .vga_in(vga_sem),
        .vga_out(vga_mouse)
);


endmodule
