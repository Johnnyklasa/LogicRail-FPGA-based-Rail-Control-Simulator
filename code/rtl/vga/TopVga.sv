module TopVga(
    input logic clk,               
    input logic clk100MHz,         
    input logic rst_n,
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
    
  
    logic [2:0] turnout_pos [0:3];
    logic turnout_taken [0:3];
    
    logic [9:0] isTaken = '0; 
    logic select_L_upper = 1'b1;
    logic select_P_upper = 1'b1;

   logic mouse_left_s1, mouse_left_s2;
    logic mouse_middle_s1, mouse_middle_s2;
    logic mouse_right_s1, mouse_right_s2;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_s1 <= '0;
            x_s2 <= '0;
            y_s1 <= '0;
            y_s2 <= '0;
            
           
            mouse_left_s1 <= 1'b0;
            mouse_left_s2 <= 1'b0;
            mouse_middle_s1 <= 1'b0;
            mouse_middle_s2 <= 1'b0;
            mouse_right_s1 <= 1'b0;
            mouse_right_s2 <= 1'b0;
        end else begin
           
            x_s1 <= x_mouse; 
            x_s2 <= x_s1;
            y_s1 <= y_mouse; 
            y_s2 <= y_s1;
            
           
            mouse_left_s1   <= mouse_left;
            mouse_left_s2   <= mouse_left_s1;
            
            mouse_middle_s1 <= mouse_middle;
            mouse_middle_s2 <= mouse_middle_s1;
            
            mouse_right_s1  <= mouse_right;
            mouse_right_s2  <= mouse_right_s1;
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
        .rst(!rst_n), 
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
        .route_L1(turnout_pos[0]), 
        .route_L2(turnout_pos[1]), 
        .route_P1(turnout_pos[2]), 
        .route_P2(turnout_pos[3]),
        .select_L_upper(select_L_upper), 
        .select_P_upper(select_P_upper),
        .signals(signals),
        .isTaken(isTaken),
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

    // --- INSTANCJE 4 ROZJAZDÓW (TURNOUTS) ---
    Turnout #(.TURNOUT_ID(0)) u_Turnout_L1 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .position(turnout_pos[0]), .isTaken(turnout_taken[0]));
    Turnout #(.TURNOUT_ID(1)) u_Turnout_L2 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .position(turnout_pos[1]), .isTaken(turnout_taken[1]));
    Turnout #(.TURNOUT_ID(2)) u_Turnout_P1 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .position(turnout_pos[2]), .isTaken(turnout_taken[2]));
    Turnout #(.TURNOUT_ID(3)) u_Turnout_P2 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .position(turnout_pos[3]), .isTaken(turnout_taken[3]));

    // --- INSTANCJE 16 SEMAFORÓW ---
    Semafor #(.SEMAFOR_ID(0)) u_Semafor_0 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[0]));
    Semafor #(.SEMAFOR_ID(1)) u_Semafor_1 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[1]));
    Semafor #(.SEMAFOR_ID(2)) u_Semafor_2 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[2]));
    Semafor #(.SEMAFOR_ID(3)) u_Semafor_3 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[3]));
    Semafor #(.SEMAFOR_ID(4)) u_Semafor_4 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[4]));
    Semafor #(.SEMAFOR_ID(5)) u_Semafor_5 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[5]));
    Semafor #(.SEMAFOR_ID(6)) u_Semafor_6 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[6]));
    Semafor #(.SEMAFOR_ID(7)) u_Semafor_7 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[7]));
    Semafor #(.SEMAFOR_ID(8)) u_Semafor_8 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[8]));
    Semafor #(.SEMAFOR_ID(9)) u_Semafor_9 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[9]));
    Semafor #(.SEMAFOR_ID(10)) u_Semafor_10 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[10]));
    Semafor #(.SEMAFOR_ID(11)) u_Semafor_11 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[11]));
    Semafor #(.SEMAFOR_ID(12)) u_Semafor_12 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[12]));
    Semafor #(.SEMAFOR_ID(13)) u_Semafor_13 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[13]));
    Semafor #(.SEMAFOR_ID(14)) u_Semafor_14 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[14]));
    Semafor #(.SEMAFOR_ID(15)) u_Semafor_15 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .OutSignal(signals[15]));

endmodule
