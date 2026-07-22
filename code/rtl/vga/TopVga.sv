module TopVga(
    input logic clk,
    input logic rst,
    input logic [11:0]  X_POS,
    input logic [11:0]  Y_POS,
    input logic [2:0] route_L1,
    input logic [2:0] route_L2,
    input logic [2:0] route_P1,
    input logic [2:0] route_P2,
    input logic select_L_upper,
    input logic select_P_upper,
    input logic [1:0] signals [0:15],
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b,
    inout wire PS2Data,
    inout wire PS2Clk
);

logic [11:0] x_s1, x_s2, y_s1, y_s2;

always_ff @(posedge clk) begin
    x_s1 <= X_POS;
    x_s2 <= x_s1;
    y_s1 <= Y_POS;
    y_s2 <= y_s1;
end

vga_if vga_tim();
vga_if vga_map();
vga_if vga_mouse();

assign vs = vga_mouse.vsync;
assign hs = vga_mouse.hsync;
assign {r,g,b} = vga_mouse.rgb;
assign vga_tim.rgb = 12'h0_0_0;

vga_timing u_vga_timing (
        .clk(clk),
        .rst(rst),
        .vcount(vga_tim.vcount),
        .vsync(vga_tim.vsync),
        .vblnk(vga_tim.vblnk),
        .hcount(vga_tim.hcount),
        .hsync(vga_tim.hsync),
        .hblnk(vga_tim.hblnk)
);


MapRenderer u_MapRenderer (
        .clk(clk), 
        .rst(rst),
        .route_L1(route_L1), 
        .route_L2(route_L2), 
        .route_P1(route_P1), 
        .route_P2(route_P2),
        .select_L_upper(select_L_upper), 
        .select_P_upper(select_P_upper),
        .signals(signals),
        .vga_in(vga_tim),
        .vga_out(vga_map)
);


DrawMouse u_DrawMouse(
        .clk(clk),
        .rst(rst),
        .X_POS(x_s2),
        .Y_POS(y_s2),
        .vga_in(vga_map),
        .vga_out(vga_mouse)
);

endmodule