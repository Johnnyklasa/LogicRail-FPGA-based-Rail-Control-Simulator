module TopVga(
    input logic clk,               
    input logic clk100MHz,         
    input logic rst_n,
    input logic [2:0] route_L1,
    input logic [2:0] route_L2,
    input logic [2:0] route_P1,
    input logic [2:0] route_P2,
    input logic select_L_upper,
    input logic select_P_upper,
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
    logic [3:0] mouse_z;
    logic mouse_left, mouse_middle, mouse_right, mouse_new_event;
    logic [1:0] signals [0:15];
    
    // Zaślepka dla zajętości torów (ponieważ nie mamy jeszcze FSM i pociągów)
    // Zależnie od tego, jakiej szerokości oczekuje MapRenderer (np. 10 bitów dla 10 torów), 
    // podajemy same zera, by tory rysowały się na biało.
    logic [9:0] isTaken = '0; 

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_s1 <= '0;
            x_s2 <= '0;
            y_s1 <= '0;
            y_s2 <= '0;
        end else begin
            x_s1 <= x_mouse; 
            x_s2 <= x_s1;
            y_s1 <= y_mouse; 
            y_s2 <= y_s1;
        end
    end

    vga_if vga_tim();
    vga_if vga_map();
    vga_if vga_mouse();

    assign vs = vga_mouse.vsync;
    assign hs = vga_mouse.hsync;
    assign {r,g,b} = vga_mouse.rgb;
    assign vga_tim.rgb = 12'h0_0_0;

    MouseCtl #(
        .SYSCLK_FREQUENCY_HZ(100000000),
        .CHECK_PERIOD_MS(500),
        .TIMEOUT_PERIOD_MS(100)
    ) u_MouseCtl (
        .clk(clk100MHz),      
        .rst(!rst_n), // MouseCtl prawdopodobnie oczekuje resetu aktywnego 1
        .xpos(x_mouse),       
        .ypos(y_mouse),       
        .zpos(mouse_z),
        .left(mouse_left),
        .middle(mouse_middle),
        .right(mouse_right),
        .new_event(mouse_new_event),
        .value(12'b0),
        .setx(1'b0),
        .sety(1'b0),
        .setmax_x(1'b0),
        .setmax_y(1'b0),
        .ps2_clk(PS2Clk),
        .ps2_data(PS2Data)
    );

    vga_timing u_vga_timing (
        .clk(clk),
        .rst_n(rst_n),
        .vcount(vga_tim.vcount),
        .vsync(vga_tim.vsync),
        .vblnk(vga_tim.vblnk),
        .hcount(vga_tim.hcount),
        .hsync(vga_tim.hsync),
        .hblnk(vga_tim.hblnk)
    );

    MapRenderer u_MapRenderer (
        .clk(clk), 
        .rst_n(rst_n),
        .route_L1(route_L1), 
        .route_L2(route_L2), 
        .route_P1(route_P1), 
        .route_P2(route_P2),
        .select_L_upper(select_L_upper), 
        .select_P_upper(select_P_upper),
        .signals(signals),
        .isTaken(isTaken), // Tory są na razie puste
        .vga_in(vga_tim),
        .vga_out(vga_map)
    );

    DrawMouse u_DrawMouse(
        .clk(clk),
        .rst_n(rst_n),
        .X_POS(x_s2),        
        .Y_POS(y_s2),        
        .vga_in(vga_map),
        .vga_out(vga_mouse)
    );

    // --- RĘCZNE INSTANCJE 16 SEMAFORÓW ---
    // (Brak zmian, wszystkie semafory gotowe na nasłuchiwanie kliknięć)
    Semafor #(.SEMAFOR_ID(0)) u_Semafor_0 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[0]));
    Semafor #(.SEMAFOR_ID(1)) u_Semafor_1 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[1]));
    Semafor #(.SEMAFOR_ID(2)) u_Semafor_2 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[2]));
    Semafor #(.SEMAFOR_ID(3)) u_Semafor_3 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[3]));
    Semafor #(.SEMAFOR_ID(4)) u_Semafor_4 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[4]));
    Semafor #(.SEMAFOR_ID(5)) u_Semafor_5 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[5]));
    Semafor #(.SEMAFOR_ID(6)) u_Semafor_6 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[6]));
    Semafor #(.SEMAFOR_ID(7)) u_Semafor_7 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[7]));
    Semafor #(.SEMAFOR_ID(8)) u_Semafor_8 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[8]));
    Semafor #(.SEMAFOR_ID(9)) u_Semafor_9 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[9]));
    Semafor #(.SEMAFOR_ID(10)) u_Semafor_10 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[10]));
    Semafor #(.SEMAFOR_ID(11)) u_Semafor_11 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[11]));
    Semafor #(.SEMAFOR_ID(12)) u_Semafor_12 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[12]));
    Semafor #(.SEMAFOR_ID(13)) u_Semafor_13 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[13]));
    Semafor #(.SEMAFOR_ID(14)) u_Semafor_14 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[14]));
    Semafor #(.SEMAFOR_ID(15)) u_Semafor_15 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[15]));

endmodule
