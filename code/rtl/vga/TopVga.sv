module TopVga(
    input logic clk,
    input logic rst,
    
    
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
    output logic [3:0] b
);

// VGA interfaces
vga_if vga_tim();
vga_if vga_map();
vga_if vga_sem();
vga_if vga_mouse(); 

assign vs = vga_sem.vsync;
assign hs = vga_sem.hsync;
assign {r,g,b} = vga_sem.rgb;
assign vga_tim.rgb = 12'h0_0_0;

// VGA timing generation instance
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

// Map drawing
DrawMap u_DrawMap (
    .clk(clk),
    .rst(rst),
    .route_L1(route_L1),
    .route_L2(route_L2),
    .route_P1(route_P1),
    .route_P2(route_P2),
    .select_L_upper(select_L_upper),
    .select_P_upper(select_P_upper),
    .vga_in(vga_tim),   
    .vga_out(vga_map)   
);

// Semaphore drawing
DrawSemafor u_DrawSemafor(
        .clk(clk),
        .rst(rst),
        .vga_in(vga_map),
        .vga_out(vga_sem),
        .signals(signals) 
);

endmodule