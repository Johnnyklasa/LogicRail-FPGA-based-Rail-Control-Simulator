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

// Test signals for the signaling system
logic [1:0] test_signals [0:15];
    always_comb begin
        test_signals[0] = 2'h1; test_signals[1] = 2'h1;
        test_signals[2] = 2'h1; test_signals[3] = 2'h1;
        test_signals[4] = 2'h1; test_signals[5] = 2'h1;
        test_signals[6] = 2'h1; test_signals[7] = 2'h1;
        test_signals[8] = 2'h1; test_signals[9] = 2'h1;
        test_signals[10] = 2'h1; test_signals[11] = 2'h1;
        test_signals[12] = 2'h2; test_signals[13] = 2'h2;
        test_signals[14] = 2'h3; test_signals[15] = 2'h3;
    end

// Input synchronization registers for mouse coordinates
always_ff @(posedge clk) begin
    x_s1 <= X_POS;
    x_s2 <= x_s1;
    y_s1 <= Y_POS;
    y_s2 <= y_s1;
end

// VGA interfaces
vga_if vga_tim();
vga_if vga_map();
vga_if vga_sem();
vga_if vga_mouse();

assign vs = vga_mouse.vsync;
assign hs = vga_mouse.hsync;
assign {r,g,b} = vga_mouse.rgb;
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

logic [2:0] route_L1 = 3'd1;
logic [2:0] route_L2 = 3'd4;
logic [2:0] route_P1 = 3'd3;
logic [2:0] route_P2 = 3'd5;

// DIRECTIONAL LEVER STATES:
logic select_L_upper = 1'b1; // Left side: Upper route active (L1 bright, L2 grey)
logic select_P_upper = 1'b0; // Right side: Lower route active (P2 bright, P1 grey)

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

// Drawing semaphore layer
DrawSemafor u_DrawSemafor(
        .clk(clk),
        .rst(rst),
        .vga_in(vga_map),
        .vga_out(vga_sem),
        .signals(test_signals)
);

// Drawing mouse cursor layer
DrawMouse u_DrawMouse(
        .clk(clk),
        .rst(rst),
        .X_POS(x_s2),
        .Y_POS(y_s2),
        .vga_in(vga_sem),
        .vga_out(vga_mouse)
);

endmodule