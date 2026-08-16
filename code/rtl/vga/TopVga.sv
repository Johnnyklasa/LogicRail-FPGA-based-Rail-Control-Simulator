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
    
    logic mouse_left_s1, mouse_left_s2;
    logic mouse_middle_s1, mouse_middle_s2;
    logic mouse_right_s1, mouse_right_s2;

    logic [4:0] hours;
    logic [5:0] minutes;
    logic minute_tick;
    logic train_tick;

    logic [1:0] signals [0:15];
    logic [2:0] turnout_pos [0:3];
    logic [3:0] turnout_taken;
    logic [7:0] turnout_train_id [0:3];
    logic [9:0] track_taken;
    logic [7:0] track_train_id [0:9];
    
    logic select_L_upper = 1'b1;
    logic select_P_upper = 1'b1;

    logic [7:0] gen_train_id [0:3];
    logic gen_train_waiting [0:3];
    
    logic req_sem [0:15];
    logic fsm_lock [0:15];
    logic fsm_ack [0:15];
    logic fsm_target [0:15];

    logic [7:0] train_to_plat_L [2:7];
    logic [7:0] train_to_plat_R [2:7];
    logic [7:0] train_to_turnout_L1;
    logic [7:0] train_to_turnout_L2;
    logic [7:0] train_to_turnout_P1;
    logic [7:0] train_to_turnout_P2;

    logic L1_moving_right, L2_moving_right;
    logic P1_moving_left, P2_moving_left;
    logic P1_moving_right, P2_moving_right;

    assign L1_moving_right = fsm_lock[0];
    assign L2_moving_right = fsm_lock[1];
    assign P1_moving_left  = fsm_lock[14];
    assign P2_moving_left  = fsm_lock[15];

    assign P1_moving_right = fsm_lock[2] | fsm_lock[4] | fsm_lock[6] | fsm_lock[8] | fsm_lock[10] | fsm_lock[12];
    assign P2_moving_right = fsm_lock[2] | fsm_lock[4] | fsm_lock[6] | fsm_lock[8] | fsm_lock[10] | fsm_lock[12];

    assign gen_train_id[1] = 8'd0;
    assign gen_train_id[2] = 8'd0;
    assign gen_train_id[3] = 8'd0;

    vga_if vga_tim();
    vga_if vga_map();
    vga_if vga_mouse();

    assign vs = vga_mouse.vsync;
    assign hs = vga_mouse.hsync;
    assign {r,g,b} = vga_mouse.rgb;
    assign vga_tim.rgb = 12'h0_0_0;

    // Semafory wjazdowe
    assign fsm_target[0]  = turnout_taken[0] | ((turnout_pos[0]==3'd1)&track_taken[2]) | ((turnout_pos[0]==3'd2)&track_taken[3]) | ((turnout_pos[0]==3'd3)&track_taken[4]) | ((turnout_pos[0]==3'd4)&track_taken[5]) | ((turnout_pos[0]==3'd5)&track_taken[6]) | ((turnout_pos[0]==3'd6)&track_taken[7]);
    assign fsm_target[1]  = turnout_taken[1] | ((turnout_pos[1]==3'd1)&track_taken[2]) | ((turnout_pos[1]==3'd2)&track_taken[3]) | ((turnout_pos[1]==3'd3)&track_taken[4]) | ((turnout_pos[1]==3'd4)&track_taken[5]) | ((turnout_pos[1]==3'd5)&track_taken[6]) | ((turnout_pos[1]==3'd6)&track_taken[7]);
    assign fsm_target[14] = turnout_taken[2] | ((turnout_pos[2]==3'd1)&track_taken[2]) | ((turnout_pos[2]==3'd2)&track_taken[3]) | ((turnout_pos[2]==3'd3)&track_taken[4]) | ((turnout_pos[2]==3'd4)&track_taken[5]) | ((turnout_pos[2]==3'd5)&track_taken[6]) | ((turnout_pos[2]==3'd6)&track_taken[7]);
    assign fsm_target[15] = turnout_taken[3] | ((turnout_pos[3]==3'd1)&track_taken[2]) | ((turnout_pos[3]==3'd2)&track_taken[3]) | ((turnout_pos[3]==3'd3)&track_taken[4]) | ((turnout_pos[3]==3'd4)&track_taken[5]) | ((turnout_pos[3]==3'd5)&track_taken[6]) | ((turnout_pos[3]==3'd6)&track_taken[7]);
    
    // Semafory peronowe
    assign fsm_target[2]  = (turnout_pos[2]==3'd1) ? turnout_taken[2] : ((turnout_pos[3]==3'd1) ? turnout_taken[3] : 1'b1);
    assign fsm_target[3]  = (turnout_pos[0]==3'd1) ? turnout_taken[0] : ((turnout_pos[1]==3'd1) ? turnout_taken[1] : 1'b1);
    assign fsm_target[4]  = (turnout_pos[2]==3'd2) ? turnout_taken[2] : ((turnout_pos[3]==3'd2) ? turnout_taken[3] : 1'b1);
    assign fsm_target[5]  = (turnout_pos[0]==3'd2) ? turnout_taken[0] : ((turnout_pos[1]==3'd2) ? turnout_taken[1] : 1'b1);
    assign fsm_target[6]  = (turnout_pos[2]==3'd3) ? turnout_taken[2] : ((turnout_pos[3]==3'd3) ? turnout_taken[3] : 1'b1);
    assign fsm_target[7]  = (turnout_pos[0]==3'd3) ? turnout_taken[0] : ((turnout_pos[1]==3'd3) ? turnout_taken[1] : 1'b1);
    assign fsm_target[8]  = (turnout_pos[2]==3'd4) ? turnout_taken[2] : ((turnout_pos[3]==3'd4) ? turnout_taken[3] : 1'b1);
    assign fsm_target[9]  = (turnout_pos[0]==3'd4) ? turnout_taken[0] : ((turnout_pos[1]==3'd4) ? turnout_taken[1] : 1'b1);
    assign fsm_target[10] = (turnout_pos[2]==3'd5) ? turnout_taken[2] : ((turnout_pos[3]==3'd5) ? turnout_taken[3] : 1'b1);
    assign fsm_target[11] = (turnout_pos[0]==3'd5) ? turnout_taken[0] : ((turnout_pos[1]==3'd5) ? turnout_taken[1] : 1'b1);
    assign fsm_target[12] = (turnout_pos[2]==3'd6) ? turnout_taken[2] : ((turnout_pos[3]==3'd6) ? turnout_taken[3] : 1'b1);
    assign fsm_target[13] = (turnout_pos[0]==3'd6) ? turnout_taken[0] : ((turnout_pos[1]==3'd6) ? turnout_taken[1] : 1'b1);
    
    // Kontrola rozjazdów od lewej (wjazd na peron)
    assign train_to_plat_L[2] = (turnout_pos[0]==3'd1 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd1 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    assign train_to_plat_L[3] = (turnout_pos[0]==3'd2 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd2 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    assign train_to_plat_L[4] = (turnout_pos[0]==3'd3 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd3 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    assign train_to_plat_L[5] = (turnout_pos[0]==3'd4 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd4 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    assign train_to_plat_L[6] = (turnout_pos[0]==3'd5 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd5 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    assign train_to_plat_L[7] = (turnout_pos[0]==3'd6 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd6 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    
    // Kontrola wjazdu na peron OD PRAWEJ (Tylko jeśli FSM 14/15 zezwala na ruch w LEWO)
    assign train_to_plat_R[2] = (turnout_pos[2]==3'd1 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd1 && P2_moving_left) ? turnout_train_id[3] : 8'd0);
    assign train_to_plat_R[3] = (turnout_pos[2]==3'd2 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd2 && P2_moving_left) ? turnout_train_id[3] : 8'd0);
    assign train_to_plat_R[4] = (turnout_pos[2]==3'd3 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd3 && P2_moving_left) ? turnout_train_id[3] : 8'd0);
    assign train_to_plat_R[5] = (turnout_pos[2]==3'd4 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd4 && P2_moving_left) ? turnout_train_id[3] : 8'd0);
    assign train_to_plat_R[6] = (turnout_pos[2]==3'd5 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd5 && P2_moving_left) ? turnout_train_id[3] : 8'd0);
    assign train_to_plat_R[7] = (turnout_pos[2]==3'd6 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd6 && P2_moving_left) ? turnout_train_id[3] : 8'd0);

    // Wyjazdy z peronów w prawo
    assign train_to_turnout_P1 = 
        (turnout_pos[2]==3'd1 && signals[2]==2'b01) ? track_train_id[2] : 
        (turnout_pos[2]==3'd2 && signals[4]==2'b01) ? track_train_id[3] : 
        (turnout_pos[2]==3'd3 && signals[6]==2'b01) ? track_train_id[4] : 
        (turnout_pos[2]==3'd4 && signals[8]==2'b01) ? track_train_id[5] : 
        (turnout_pos[2]==3'd5 && signals[10]==2'b01)? track_train_id[6] : 
        (turnout_pos[2]==3'd6 && signals[12]==2'b01)? track_train_id[7] : 8'd0;

    assign train_to_turnout_P2 = 
        (turnout_pos[3]==3'd1 && signals[2]==2'b01) ? track_train_id[2] : 
        (turnout_pos[3]==3'd2 && signals[4]==2'b01) ? track_train_id[3] : 
        (turnout_pos[3]==3'd3 && signals[6]==2'b01) ? track_train_id[4] : 
        (turnout_pos[3]==3'd4 && signals[8]==2'b01) ? track_train_id[5] : 
        (turnout_pos[3]==3'd5 && signals[10]==2'b01)? track_train_id[6] : 
        (turnout_pos[3]==3'd6 && signals[12]==2'b01)? track_train_id[7] : 8'd0;

    // Wyjazdy z peronów w lewo
    assign train_to_turnout_L1 = 
        (turnout_pos[0]==3'd1 && signals[3]==2'b01) ? track_train_id[2] : 
        (turnout_pos[0]==3'd2 && signals[5]==2'b01) ? track_train_id[3] : 
        (turnout_pos[0]==3'd3 && signals[7]==2'b01) ? track_train_id[4] : 
        (turnout_pos[0]==3'd4 && signals[9]==2'b01) ? track_train_id[5] : 
        (turnout_pos[0]==3'd5 && signals[11]==2'b01)? track_train_id[6] : 
        (turnout_pos[0]==3'd6 && signals[13]==2'b01)? track_train_id[7] : 8'd0;

    assign train_to_turnout_L2 = 
        (turnout_pos[1]==3'd1 && signals[3]==2'b01) ? track_train_id[2] : 
        (turnout_pos[1]==3'd2 && signals[5]==2'b01) ? track_train_id[3] : 
        (turnout_pos[1]==3'd3 && signals[7]==2'b01) ? track_train_id[4] : 
        (turnout_pos[1]==3'd4 && signals[9]==2'b01) ? track_train_id[5] : 
        (turnout_pos[1]==3'd5 && signals[11]==2'b01)? track_train_id[6] : 
        (turnout_pos[1]==3'd6 && signals[13]==2'b01)? track_train_id[7] : 8'd0;

    // =======================================================
    // DETEKTORY ZBOCZA (Puls 1-taktowy)
    // =======================================================
    logic minute_tick_prev;
    logic train_tick_pulse;
    logic mouse_click_pulse;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            minute_tick_prev <= 1'b0;
        end else begin
            minute_tick_prev <= minute_tick;
        end
    end

    // TUTAJ BYŁ BRAK! OTO DWA KLUCZOWE PRZYPISANIA:
    assign train_tick_pulse = minute_tick & ~minute_tick_prev;
    assign mouse_click_pulse = mouse_left_s1 & ~mouse_left_s2;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x_s1 <= '0; x_s2 <= '0;
            y_s1 <= '0; y_s2 <= '0;
            mouse_left_s1 <= 1'b0; mouse_left_s2 <= 1'b0;
            mouse_middle_s1 <= 1'b0; mouse_middle_s2 <= 1'b0;
            mouse_right_s1 <= 1'b0; mouse_right_s2 <= 1'b0;
        end else begin
            x_s1 <= x_mouse; x_s2 <= x_s1;
            y_s1 <= y_mouse; y_s2 <= y_s1;
            mouse_left_s1   <= mouse_left;
            mouse_left_s2   <= mouse_left_s1;
            mouse_middle_s1 <= mouse_middle;
            mouse_middle_s2 <= mouse_middle_s1;
            mouse_right_s1  <= mouse_right;
            mouse_right_s2  <= mouse_right_s1;
        end
    end

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
        .isTaken(track_taken),
        .turnout_taken(turnout_taken),
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

    RealClock u_RealClock (
        .clk(clk),
        .rst_n(rst_n),
        .hours(hours),
        .minutes(minutes),
        .minute_tick(minute_tick)
    );

    TrainGenerator u_TrainGen_0 (
        .clk(clk),
        .rst_n(rst_n),
        .hours(hours),
        .minutes(minutes),
        .minute_tick(minute_tick),
        .train_tick(train_tick_pulse),
        .approach_track_taken(track_taken[0]),
        .train_waiting(gen_train_waiting[0]),
        .TrainID(gen_train_id[0])
    );
   
    Turnout #(.TURNOUT_ID(0)) u_Turnout_L1 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_click_pulse), .X_POS(x_s2), .Y_POS(y_s2), .route_locked(fsm_lock[0]),  .move_R(1'b1), .move_L(1'b1), .train_tick(train_tick_pulse), .track_R_taken(track_taken[turnout_pos[0]+1]), .track_L_taken(track_taken[0]), .train_id_in_L((signals[0] == 2'b01) ? track_train_id[0] : 8'd0),  .train_id_in_R(train_to_turnout_L1), .current_train_id(turnout_train_id[0]), .position(turnout_pos[0]), .isTaken(turnout_taken[0]));
    Turnout #(.TURNOUT_ID(1)) u_Turnout_L2 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_click_pulse), .X_POS(x_s2), .Y_POS(y_s2), .route_locked(fsm_lock[1]),  .move_R(1'b1), .move_L(1'b1), .train_tick(train_tick_pulse), .track_R_taken(track_taken[turnout_pos[1]+1]), .track_L_taken(track_taken[1]), .train_id_in_L((signals[1] == 2'b01) ? track_train_id[1] : 8'd0),  .train_id_in_R(train_to_turnout_L2), .current_train_id(turnout_train_id[1]), .position(turnout_pos[1]), .isTaken(turnout_taken[1]));
    Turnout #(.TURNOUT_ID(2)) u_Turnout_P1 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_click_pulse), .X_POS(x_s2), .Y_POS(y_s2), .route_locked(fsm_lock[14]), .move_R(1'b1), .move_L(1'b1), .train_tick(train_tick_pulse), .track_R_taken(track_taken[8]),                 .track_L_taken(track_taken[turnout_pos[2]+1]), .train_id_in_L(train_to_turnout_P1), .train_id_in_R((signals[14] == 2'b01) ? track_train_id[8] : 8'd0), .current_train_id(turnout_train_id[2]), .position(turnout_pos[2]), .isTaken(turnout_taken[2]));
    Turnout #(.TURNOUT_ID(3)) u_Turnout_P2 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_click_pulse), .X_POS(x_s2), .Y_POS(y_s2), .route_locked(fsm_lock[15]), .move_R(1'b1), .move_L(1'b1), .train_tick(train_tick_pulse), .track_R_taken(track_taken[9]),                 .track_L_taken(track_taken[turnout_pos[3]+1]), .train_id_in_L(train_to_turnout_P2), .train_id_in_R((signals[15] == 2'b01) ? track_train_id[9] : 8'd0), .current_train_id(turnout_train_id[3]), .position(turnout_pos[3]), .isTaken(turnout_taken[3]));

    Track u_Track_0 (.clk(clk), .rst_n(rst_n), .train_tick(train_tick_pulse), .move_R(signals[0] == 2'b01),  .move_L(1'b0),                 .track_R_taken(turnout_taken[0]),               .track_L_taken(1'b0),                            .train_id_in_L(gen_train_id[0]),       .train_id_in_R(8'd0),                  .current_train_id(track_train_id[0]), .isTaken(track_taken[0]));
    Track u_Track_1 (.clk(clk), .rst_n(rst_n), .train_tick(train_tick_pulse), .move_R(signals[1] == 2'b01),  .move_L(1'b0),                 .track_R_taken(turnout_taken[1]),               .track_L_taken(1'b0),                            .train_id_in_L(gen_train_id[1]),       .train_id_in_R(8'd0),                  .current_train_id(track_train_id[1]), .isTaken(track_taken[1]));
    
    Track u_Track_2 (.clk(clk), .rst_n(rst_n), .train_tick(train_tick_pulse), .move_R(signals[2] == 2'b01),  .move_L(signals[3] == 2'b01),  .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[2]),    .train_id_in_R(train_to_plat_R[2]),    .current_train_id(track_train_id[2]), .isTaken(track_taken[2]));
    Track u_Track_3 (.clk(clk), .rst_n(rst_n), .train_tick(train_tick_pulse), .move_R(signals[4] == 2'b01),  .move_L(signals[5] == 2'b01),  .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[3]),    .train_id_in_R(train_to_plat_R[3]),    .current_train_id(track_train_id[3]), .isTaken(track_taken[3]));
    Track u_Track_4 (.clk(clk), .rst_n(rst_n), .train_tick(train_tick_pulse), .move_R(signals[6] == 2'b01),  .move_L(signals[7] == 2'b01),  .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[4]),    .train_id_in_R(train_to_plat_R[4]),    .current_train_id(track_train_id[4]), .isTaken(track_taken[4]));
    Track u_Track_5 (.clk(clk), .rst_n(rst_n), .train_tick(train_tick_pulse), .move_R(signals[8] == 2'b01),  .move_L(signals[9] == 2'b01),  .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[5]),    .train_id_in_R(train_to_plat_R[5]),    .current_train_id(track_train_id[5]), .isTaken(track_taken[5]));
    Track u_Track_6 (.clk(clk), .rst_n(rst_n), .train_tick(train_tick_pulse), .move_R(signals[10] == 2'b01), .move_L(signals[11] == 2'b01), .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[6]),    .train_id_in_R(train_to_plat_R[6]),    .current_train_id(track_train_id[6]), .isTaken(track_taken[6]));
    Track u_Track_7 (.clk(clk), .rst_n(rst_n), .train_tick(train_tick_pulse), .move_R(signals[12] == 2'b01), .move_L(signals[13] == 2'b01), .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[7]),    .train_id_in_R(train_to_plat_R[7]),    .current_train_id(track_train_id[7]), .isTaken(track_taken[7]));

    Track u_Track_8 (.clk(clk), .rst_n(rst_n), .train_tick(train_tick_pulse), .move_R(1'b0),                 .move_L(signals[14] == 2'b01), .track_R_taken(1'b0),                           .track_L_taken(turnout_taken[2]),               .train_id_in_L(turnout_train_id[2]),                  .train_id_in_R(gen_train_id[2]),       .current_train_id(track_train_id[8]), .isTaken(track_taken[8]));
    Track u_Track_9 (.clk(clk), .rst_n(rst_n), .train_tick(train_tick_pulse), .move_R(1'b0),                 .move_L(signals[15] == 2'b01), .track_R_taken(1'b0),                           .track_L_taken(turnout_taken[3]),               .train_id_in_L(turnout_train_id[3]),                  .train_id_in_R(gen_train_id[3]),       .current_train_id(track_train_id[9]), .isTaken(track_taken[9]));

    // Moduły Semaforów dostają mouse_left_s2, ponieważ mają w środku własny ClickDetector!
    Semafor #(.SEMAFOR_ID(0))  u_Sem_0  (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[0]),  .route_req_out(req_sem[0]),  .OutSignal());
    Semafor #(.SEMAFOR_ID(1))  u_Sem_1  (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[1]),  .route_req_out(req_sem[1]),  .OutSignal());
    Semafor #(.SEMAFOR_ID(2))  u_Sem_2  (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[2]),  .route_req_out(req_sem[2]),  .OutSignal());
    Semafor #(.SEMAFOR_ID(3))  u_Sem_3  (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[3]),  .route_req_out(req_sem[3]),  .OutSignal());
    Semafor #(.SEMAFOR_ID(4))  u_Sem_4  (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[4]),  .route_req_out(req_sem[4]),  .OutSignal());
    Semafor #(.SEMAFOR_ID(5))  u_Sem_5  (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[5]),  .route_req_out(req_sem[5]),  .OutSignal());
    Semafor #(.SEMAFOR_ID(6))  u_Sem_6  (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[6]),  .route_req_out(req_sem[6]),  .OutSignal());
    Semafor #(.SEMAFOR_ID(7))  u_Sem_7  (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[7]),  .route_req_out(req_sem[7]),  .OutSignal());
    Semafor #(.SEMAFOR_ID(8))  u_Sem_8  (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[8]),  .route_req_out(req_sem[8]),  .OutSignal());
    Semafor #(.SEMAFOR_ID(9))  u_Sem_9  (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[9]),  .route_req_out(req_sem[9]),  .OutSignal());
    Semafor #(.SEMAFOR_ID(10)) u_Sem_10 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[10]), .route_req_out(req_sem[10]), .OutSignal());
    Semafor #(.SEMAFOR_ID(11)) u_Sem_11 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[11]), .route_req_out(req_sem[11]), .OutSignal());
    Semafor #(.SEMAFOR_ID(12)) u_Sem_12 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[12]), .route_req_out(req_sem[12]), .OutSignal());
    Semafor #(.SEMAFOR_ID(13)) u_Sem_13 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[13]), .route_req_out(req_sem[13]), .OutSignal());
    Semafor #(.SEMAFOR_ID(14)) u_Sem_14 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[14]), .route_req_out(req_sem[14]), .OutSignal());
    Semafor #(.SEMAFOR_ID(15)) u_Sem_15 (.clk(clk), .rst_n(rst_n), .MouseLeftClick(mouse_left_s2), .X_POS(x_s2), .Y_POS(y_s2), .color_from_fsm(signals[15]), .route_req_out(req_sem[15]), .OutSignal());

    RouteFSM u_FSM_0  (.clk(clk), .rst_n(rst_n), .route_req(req_sem[0]),  .target_track_taken(fsm_target[0]),            .train_passed(!track_taken[0] && !turnout_taken[0]), .route_locked(fsm_lock[0]),  .semafor_sig(signals[0]),  .train_spawn_ack(fsm_ack[0]));
    RouteFSM u_FSM_1  (.clk(clk), .rst_n(rst_n), .route_req(req_sem[1]),  .target_track_taken(fsm_target[1]),            .train_passed(!track_taken[1] && !turnout_taken[1]), .route_locked(fsm_lock[1]),  .semafor_sig(signals[1]),  .train_spawn_ack(fsm_ack[1]));
    RouteFSM u_FSM_2  (.clk(clk), .rst_n(rst_n), .route_req(req_sem[2]),  .target_track_taken(fsm_target[2]|fsm_lock[3]),   .train_passed(!track_taken[2] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[2]),  .semafor_sig(signals[2]),  .train_spawn_ack(fsm_ack[2]));
    RouteFSM u_FSM_3  (.clk(clk), .rst_n(rst_n), .route_req(req_sem[3]),  .target_track_taken(fsm_target[3]|fsm_lock[2]),   .train_passed(!track_taken[2] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[3]),  .semafor_sig(signals[3]),  .train_spawn_ack(fsm_ack[3]));
    RouteFSM u_FSM_4  (.clk(clk), .rst_n(rst_n), .route_req(req_sem[4]),  .target_track_taken(fsm_target[4]|fsm_lock[5]),   .train_passed(!track_taken[3] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[4]),  .semafor_sig(signals[4]),  .train_spawn_ack(fsm_ack[4]));
    RouteFSM u_FSM_5  (.clk(clk), .rst_n(rst_n), .route_req(req_sem[5]),  .target_track_taken(fsm_target[5]|fsm_lock[4]),   .train_passed(!track_taken[3] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[5]),  .semafor_sig(signals[5]),  .train_spawn_ack(fsm_ack[5]));
    RouteFSM u_FSM_6  (.clk(clk), .rst_n(rst_n), .route_req(req_sem[6]),  .target_track_taken(fsm_target[6]|fsm_lock[7]),   .train_passed(!track_taken[4] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[6]),  .semafor_sig(signals[6]),  .train_spawn_ack(fsm_ack[6]));
    RouteFSM u_FSM_7  (.clk(clk), .rst_n(rst_n), .route_req(req_sem[7]),  .target_track_taken(fsm_target[7]|fsm_lock[6]),   .train_passed(!track_taken[4] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[7]),  .semafor_sig(signals[7]),  .train_spawn_ack(fsm_ack[7]));
    RouteFSM u_FSM_8  (.clk(clk), .rst_n(rst_n), .route_req(req_sem[8]),  .target_track_taken(fsm_target[8]|fsm_lock[9]),   .train_passed(!track_taken[5] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[8]),  .semafor_sig(signals[8]),  .train_spawn_ack(fsm_ack[8]));
    RouteFSM u_FSM_9  (.clk(clk), .rst_n(rst_n), .route_req(req_sem[9]),  .target_track_taken(fsm_target[9]|fsm_lock[8]),   .train_passed(!track_taken[5] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[9]),  .semafor_sig(signals[9]),  .train_spawn_ack(fsm_ack[9]));
    RouteFSM u_FSM_10 (.clk(clk), .rst_n(rst_n), .route_req(req_sem[10]), .target_track_taken(fsm_target[10]|fsm_lock[11]), .train_passed(!track_taken[6] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[10]), .semafor_sig(signals[10]), .train_spawn_ack(fsm_ack[10]));
    RouteFSM u_FSM_11 (.clk(clk), .rst_n(rst_n), .route_req(req_sem[11]), .target_track_taken(fsm_target[11]|fsm_lock[10]), .train_passed(!track_taken[6] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[11]), .semafor_sig(signals[11]), .train_spawn_ack(fsm_ack[11]));
    RouteFSM u_FSM_12 (.clk(clk), .rst_n(rst_n), .route_req(req_sem[12]), .target_track_taken(fsm_target[12]|fsm_lock[13]), .train_passed(!track_taken[7] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[12]), .semafor_sig(signals[12]), .train_spawn_ack(fsm_ack[12]));
    RouteFSM u_FSM_13 (.clk(clk), .rst_n(rst_n), .route_req(req_sem[13]), .target_track_taken(fsm_target[13]|fsm_lock[12]), .train_passed(!track_taken[7] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[13]), .semafor_sig(signals[13]), .train_spawn_ack(fsm_ack[13]));
    RouteFSM u_FSM_14 (.clk(clk), .rst_n(rst_n), .route_req(req_sem[14]), .target_track_taken(fsm_target[14]),           .train_passed(!track_taken[8] && !turnout_taken[2]), .route_locked(fsm_lock[14]), .semafor_sig(signals[14]), .train_spawn_ack(fsm_ack[14]));
    RouteFSM u_FSM_15 (.clk(clk), .rst_n(rst_n), .route_req(req_sem[15]), .target_track_taken(fsm_target[15]),           .train_passed(!track_taken[9] && !turnout_taken[3]), .route_locked(fsm_lock[15]), .semafor_sig(signals[15]), .train_spawn_ack(fsm_ack[15]));

endmodule
