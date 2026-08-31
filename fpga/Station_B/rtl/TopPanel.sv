//Autor:Jan Rutkowski
module TopPanel(
    input  logic clk,               
    input  logic btnC,              
    input  logic [15:0] sw,                
    input  logic [3:0]  custom_sw_turnout, 

    output logic ds,
    output logic shcp,
    output logic stcp,
    
    input  logic rx_uart,
    output logic tx_uart
);

  
    logic system_rst_n;
    assign system_rst_n = ~btnC;

 
    logic [4:0] hours;
    logic [5:0] minutes;
    logic minute_tick;
    logic minute_tick_prev;
    logic train_tick_pulse;

    logic [1:0] signals [0:15];
    logic [2:0] turnout_pos [0:3];
    logic [3:0] turnout_taken;
    logic [7:0] turnout_train_id [0:3];
    logic [9:0] track_taken;
    logic [7:0] track_train_id [0:9];
    
    logic [7:0] gen_train_id [0:3];
    
    logic req_sem [0:15];
    logic fsm_lock [0:15];
    logic fsm_ack [0:15];
    logic fsm_target [0:15];

    logic [7:0] train_to_plat_L [2:7];
    logic [7:0] train_to_plat_R [2:7];
    logic [7:0] train_to_turnout_L1, train_to_turnout_L2;
    logic [7:0] train_to_turnout_P1, train_to_turnout_P2;

    logic L1_moving_right, L2_moving_right;
    logic P1_moving_left,  P2_moving_left;
    logic P1_moving_right, P2_moving_right;
    logic L_moving_left;

    wire sync_en;
    wire [4:0] sync_hours;
    wire [5:0] sync_minutes;
    wire [7:0] rx_byte, tx_byte;
    wire       rx_ready, tx_start, tx_busy;
    wire [7:0] rx_train_id;
    wire       rx_train_req;
    logic [7:0] spawned_train_id;
    logic incoming_train_waiting;

    logic [15:0] sw_prev;
    logic [47:0] mapped_data; 

   
    assign L1_moving_right = fsm_lock[0];
    assign L2_moving_right = fsm_lock[1];
    assign P1_moving_left  = fsm_lock[14];
    assign P2_moving_left  = fsm_lock[15];

    assign P1_moving_right = fsm_lock[2] | fsm_lock[4] | fsm_lock[6] | fsm_lock[8] | fsm_lock[10] | fsm_lock[12];
    assign P2_moving_right = fsm_lock[2] | fsm_lock[4] | fsm_lock[6] | fsm_lock[8] | fsm_lock[10] | fsm_lock[12];
    assign L_moving_left   = fsm_lock[3] | fsm_lock[5] | fsm_lock[7] | fsm_lock[9] | fsm_lock[11] | fsm_lock[13];

    assign gen_train_id[1] = 8'd0;
    assign gen_train_id[2] = 8'd0;
    assign gen_train_id[3] = 8'd0;

    assign train_tick_pulse = minute_tick & ~minute_tick_prev;

    always_ff @(posedge clk or negedge system_rst_n) begin
        if (!system_rst_n) begin
            sw_prev <= '0;
            minute_tick_prev <= 1'b0;
        end else begin
            sw_prev <= sw;
            minute_tick_prev <= minute_tick;
        end
    end

    always_comb begin
        for (int i = 0; i < 16; i++) begin
            req_sem[i] = sw[i] & ~sw_prev[i];
        end
    end
    
  
    UartController u_UartController (
        .clk(clk),
        .rst_n(system_rst_n),
        .rx_data(rx_byte),
        .rx_ready(rx_ready),
        .sync_en_out(sync_en),
        .sync_hours_out(sync_hours),
        .sync_minutes_out(sync_minutes),
        .rx_train_id(rx_train_id),       
        .rx_train_req(rx_train_req),     
        .tx_start(tx_start),
        .tx_data(tx_byte),
        .tx_busy(tx_busy),
        .send_time_req(1'b0),            
        .current_hours(5'd0), 
        .current_minutes(6'd0),
        .send_train_req(1'b0),           
        .tx_train_id_in(8'd0)
    );

    RealClock #(
        .CLK_FREQ(100_000_000) 
    ) u_RealClock (
        .clk(clk),
        .rst_n(system_rst_n),
        .sync_en(sync_en),         
        .sync_hours(sync_hours),   
        .sync_minutes(sync_minutes),
        .hours(hours),
        .minutes(minutes),
        .minute_tick(minute_tick)
    );

    TrainSpawnerFromUART u_TrainSpawner (
        .clk(clk),
        .rst_n(system_rst_n),
        .train_tick(train_tick_pulse),
        .approach_track_taken(track_taken[0]), 
        .rx_train_id(rx_train_id),
        .rx_train_req(rx_train_req),
        .train_waiting(incoming_train_waiting),
        .TrainID(spawned_train_id)
    );

    UartRx #( .CLK_FREQ(100_000_000), .BAUD_RATE(115200) ) u_UartRx (
        .clk(clk), 
        .rst_n(system_rst_n), 
        .rx(rx_uart), 
        .rx_data(rx_byte), 
        .rx_ready(rx_ready)
    );

    UartTx #( .CLK_FREQ(100_000_000), .BAUD_RATE(115200) ) u_UartTx (
        .clk(clk), 
        .rst_n(system_rst_n), 
        .tx_start(tx_start), 
        .tx_data(tx_byte), 
        .tx(tx_uart), 
        .tx_busy(tx_busy)
    );

    assign fsm_target[0]  = turnout_taken[0] | ((turnout_pos[0]==3'd1)&track_taken[2]) | ((turnout_pos[0]==3'd2)&track_taken[3]) | ((turnout_pos[0]==3'd3)&track_taken[4]) | ((turnout_pos[0]==3'd4)&track_taken[5]) | ((turnout_pos[0]==3'd5)&track_taken[6]) | ((turnout_pos[0]==3'd6)&track_taken[7]);
    assign fsm_target[1]  = turnout_taken[1] | ((turnout_pos[1]==3'd1)&track_taken[2]) | ((turnout_pos[1]==3'd2)&track_taken[3]) | ((turnout_pos[1]==3'd3)&track_taken[4]) | ((turnout_pos[1]==3'd4)&track_taken[5]) | ((turnout_pos[1]==3'd5)&track_taken[6]) | ((turnout_pos[1]==3'd6)&track_taken[7]);
    assign fsm_target[14] = turnout_taken[2] | ((turnout_pos[2]==3'd1)&track_taken[2]) | ((turnout_pos[2]==3'd2)&track_taken[3]) | ((turnout_pos[2]==3'd3)&track_taken[4]) | ((turnout_pos[2]==3'd4)&track_taken[5]) | ((turnout_pos[2]==3'd5)&track_taken[6]) | ((turnout_pos[2]==3'd6)&track_taken[7]);
    assign fsm_target[15] = turnout_taken[3] | ((turnout_pos[3]==3'd1)&track_taken[2]) | ((turnout_pos[3]==3'd2)&track_taken[3]) | ((turnout_pos[3]==3'd3)&track_taken[4]) | ((turnout_pos[3]==3'd4)&track_taken[5]) | ((turnout_pos[3]==3'd5)&track_taken[6]) | ((turnout_pos[3]==3'd6)&track_taken[7]);
    
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
    
    assign train_to_plat_L[2] = (turnout_pos[0]==3'd1 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd1 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    assign train_to_plat_L[3] = (turnout_pos[0]==3'd2 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd2 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    assign train_to_plat_L[4] = (turnout_pos[0]==3'd3 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd3 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    assign train_to_plat_L[5] = (turnout_pos[0]==3'd4 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd4 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    assign train_to_plat_L[6] = (turnout_pos[0]==3'd5 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd5 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    assign train_to_plat_L[7] = (turnout_pos[0]==3'd6 && L1_moving_right) ? turnout_train_id[0] : ((turnout_pos[1]==3'd6 && L2_moving_right) ? turnout_train_id[1] : 8'd0);
    
    assign train_to_plat_R[2] = (turnout_pos[2]==3'd1 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd1 && P2_moving_left) ? turnout_train_id[3] : 8'd0);
    assign train_to_plat_R[3] = (turnout_pos[2]==3'd2 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd2 && P2_moving_left) ? turnout_train_id[3] : 8'd0);
    assign train_to_plat_R[4] = (turnout_pos[2]==3'd3 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd3 && P2_moving_left) ? turnout_train_id[3] : 8'd0);
    assign train_to_plat_R[5] = (turnout_pos[2]==3'd4 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd4 && P2_moving_left) ? turnout_train_id[3] : 8'd0);
    assign train_to_plat_R[6] = (turnout_pos[2]==3'd5 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd5 && P2_moving_left) ? turnout_train_id[3] : 8'd0);
    assign train_to_plat_R[7] = (turnout_pos[2]==3'd6 && P1_moving_left) ? turnout_train_id[2] : ((turnout_pos[3]==3'd6 && P2_moving_left) ? turnout_train_id[3] : 8'd0);

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

    TurnoutHW #(.TURNOUT_ID(0)) u_Turnout_L1 (.clk(clk), .rst_n(system_rst_n), .switch_pos(custom_sw_turnout[0]), .route_locked(fsm_lock[0] | L_moving_left),  .move_R(1'b1), .move_L(1'b1), .train_tick(train_tick_pulse), .track_R_taken(track_taken[turnout_pos[0]+1]), .track_L_taken(track_taken[0]), .train_id_in_L((signals[0] == 2'b01) ? track_train_id[0] : 8'd0),  .train_id_in_R(train_to_turnout_L1), .current_train_id(turnout_train_id[0]), .position(turnout_pos[0]), .isTaken(turnout_taken[0]));
    TurnoutHW #(.TURNOUT_ID(1)) u_Turnout_L2 (.clk(clk), .rst_n(system_rst_n), .switch_pos(custom_sw_turnout[1]), .route_locked(fsm_lock[1] | L_moving_left),  .move_R(1'b1), .move_L(1'b1), .train_tick(train_tick_pulse), .track_R_taken(track_taken[turnout_pos[1]+1]), .track_L_taken(track_taken[1]), .train_id_in_L((signals[1] == 2'b01) ? track_train_id[1] : 8'd0),  .train_id_in_R(train_to_turnout_L2), .current_train_id(turnout_train_id[1]), .position(turnout_pos[1]), .isTaken(turnout_taken[1]));
    TurnoutHW #(.TURNOUT_ID(2)) u_Turnout_P1 (.clk(clk), .rst_n(system_rst_n), .switch_pos(custom_sw_turnout[2]), .route_locked(fsm_lock[14] | P1_moving_right), .move_R(1'b1), .move_L(1'b1), .train_tick(train_tick_pulse), .track_R_taken(track_taken[8]),                .track_L_taken(track_taken[turnout_pos[2]+1]), .train_id_in_L(train_to_turnout_P1), .train_id_in_R((signals[14] == 2'b01) ? track_train_id[8] : 8'd0), .current_train_id(turnout_train_id[2]), .position(turnout_pos[2]), .isTaken(turnout_taken[2]));
    TurnoutHW #(.TURNOUT_ID(3)) u_Turnout_P2 (.clk(clk), .rst_n(system_rst_n), .switch_pos(custom_sw_turnout[3]), .route_locked(fsm_lock[15] | P2_moving_right), .move_R(1'b1), .move_L(1'b1), .train_tick(train_tick_pulse), .track_R_taken(track_taken[9]),                .track_L_taken(track_taken[turnout_pos[3]+1]), .train_id_in_L(train_to_turnout_P2), .train_id_in_R((signals[15] == 2'b01) ? track_train_id[9] : 8'd0), .current_train_id(turnout_train_id[3]), .position(turnout_pos[3]), .isTaken(turnout_taken[3]));

    Track u_Track_0 (.clk(clk), .rst_n(system_rst_n), .train_tick(train_tick_pulse), .move_R(signals[0] == 2'b01),  .move_L(1'b0),                 .track_R_taken(turnout_taken[0]),               .track_L_taken(1'b0),                           .train_id_in_L(spawned_train_id),      .train_id_in_R(8'd0),                  .current_train_id(track_train_id[0]), .isTaken(track_taken[0]));
    Track u_Track_1 (.clk(clk), .rst_n(system_rst_n), .train_tick(train_tick_pulse), .move_R(signals[1] == 2'b01),  .move_L(1'b0),                 .track_R_taken(turnout_taken[1]),               .track_L_taken(1'b0),                           .train_id_in_L(gen_train_id[1]),       .train_id_in_R(8'd0),                  .current_train_id(track_train_id[1]), .isTaken(track_taken[1]));
    Track u_Track_2 (.clk(clk), .rst_n(system_rst_n), .train_tick(train_tick_pulse), .move_R(signals[2] == 2'b01),  .move_L(signals[3] == 2'b01),  .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[2]),    .train_id_in_R(train_to_plat_R[2]),    .current_train_id(track_train_id[2]), .isTaken(track_taken[2]));
    Track u_Track_3 (.clk(clk), .rst_n(system_rst_n), .train_tick(train_tick_pulse), .move_R(signals[4] == 2'b01),  .move_L(signals[5] == 2'b01),  .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[3]),    .train_id_in_R(train_to_plat_R[3]),    .current_train_id(track_train_id[3]), .isTaken(track_taken[3]));
    Track u_Track_4 (.clk(clk), .rst_n(system_rst_n), .train_tick(train_tick_pulse), .move_R(signals[6] == 2'b01),  .move_L(signals[7] == 2'b01),  .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[4]),    .train_id_in_R(train_to_plat_R[4]),    .current_train_id(track_train_id[4]), .isTaken(track_taken[4]));
    Track u_Track_5 (.clk(clk), .rst_n(system_rst_n), .train_tick(train_tick_pulse), .move_R(signals[8] == 2'b01),  .move_L(signals[9] == 2'b01),  .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[5]),    .train_id_in_R(train_to_plat_R[5]),    .current_train_id(track_train_id[5]), .isTaken(track_taken[5]));
    Track u_Track_6 (.clk(clk), .rst_n(system_rst_n), .train_tick(train_tick_pulse), .move_R(signals[10] == 2'b01), .move_L(signals[11] == 2'b01), .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[6]),    .train_id_in_R(train_to_plat_R[6]),    .current_train_id(track_train_id[6]), .isTaken(track_taken[6]));
    Track u_Track_7 (.clk(clk), .rst_n(system_rst_n), .train_tick(train_tick_pulse), .move_R(signals[12] == 2'b01), .move_L(signals[13] == 2'b01), .track_R_taken(turnout_taken[2]|turnout_taken[3]), .track_L_taken(turnout_taken[0]|turnout_taken[1]), .train_id_in_L(train_to_plat_L[7]),    .train_id_in_R(train_to_plat_R[7]),    .current_train_id(track_train_id[7]), .isTaken(track_taken[7]));
    Track u_Track_8 (.clk(clk), .rst_n(system_rst_n), .train_tick(train_tick_pulse), .move_R(1'b0),                 .move_L(signals[14] == 2'b01), .track_R_taken(1'b0),                           .track_L_taken(turnout_taken[2]),               .train_id_in_L(P1_moving_right ? turnout_train_id[2] : 8'd0), .train_id_in_R(gen_train_id[2]),       .current_train_id(track_train_id[8]), .isTaken(track_taken[8]));
    Track u_Track_9 (.clk(clk), .rst_n(system_rst_n), .train_tick(train_tick_pulse), .move_R(1'b0),                 .move_L(signals[15] == 2'b01), .track_R_taken(1'b0),                           .track_L_taken(turnout_taken[3]),               .train_id_in_L(P2_moving_right ? turnout_train_id[3] : 8'd0), .train_id_in_R(gen_train_id[3]),       .current_train_id(track_train_id[9]), .isTaken(track_taken[9]));

    RouteFSM u_FSM_0  (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[0]),  .target_track_taken(fsm_target[0]),            .train_passed(!track_taken[0] && !turnout_taken[0]), .route_locked(fsm_lock[0]),  .semafor_sig(signals[0]),  .train_spawn_ack(fsm_ack[0]));
    RouteFSM u_FSM_1  (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[1]),  .target_track_taken(fsm_target[1]),            .train_passed(!track_taken[1] && !turnout_taken[1]), .route_locked(fsm_lock[1]),  .semafor_sig(signals[1]),  .train_spawn_ack(fsm_ack[1]));
    RouteFSM u_FSM_2  (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[2]),  .target_track_taken(fsm_target[2]|fsm_lock[3]),   .train_passed(!track_taken[2] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[2]),  .semafor_sig(signals[2]),  .train_spawn_ack(fsm_ack[2]));
    RouteFSM u_FSM_3  (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[3]),  .target_track_taken(fsm_target[3]|fsm_lock[2]),   .train_passed(!track_taken[2] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[3]),  .semafor_sig(signals[3]),  .train_spawn_ack(fsm_ack[3]));
    RouteFSM u_FSM_4  (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[4]),  .target_track_taken(fsm_target[4]|fsm_lock[5]),   .train_passed(!track_taken[3] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[4]),  .semafor_sig(signals[4]),  .train_spawn_ack(fsm_ack[4]));
    RouteFSM u_FSM_5  (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[5]),  .target_track_taken(fsm_target[5]|fsm_lock[4]),   .train_passed(!track_taken[3] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[5]),  .semafor_sig(signals[5]),  .train_spawn_ack(fsm_ack[5]));
    RouteFSM u_FSM_6  (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[6]),  .target_track_taken(fsm_target[6]|fsm_lock[7]),   .train_passed(!track_taken[4] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[6]),  .semafor_sig(signals[6]),  .train_spawn_ack(fsm_ack[6]));
    RouteFSM u_FSM_7  (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[7]),  .target_track_taken(fsm_target[7]|fsm_lock[6]),   .train_passed(!track_taken[4] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[7]),  .semafor_sig(signals[7]),  .train_spawn_ack(fsm_ack[7]));
    RouteFSM u_FSM_8  (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[8]),  .target_track_taken(fsm_target[8]|fsm_lock[9]),   .train_passed(!track_taken[5] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[8]),  .semafor_sig(signals[8]),  .train_spawn_ack(fsm_ack[8]));
    RouteFSM u_FSM_9  (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[9]),  .target_track_taken(fsm_target[9]|fsm_lock[8]),   .train_passed(!track_taken[5] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[9]),  .semafor_sig(signals[9]),  .train_spawn_ack(fsm_ack[9]));
    RouteFSM u_FSM_10 (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[10]), .target_track_taken(fsm_target[10]|fsm_lock[11]), .train_passed(!track_taken[6] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[10]), .semafor_sig(signals[10]), .train_spawn_ack(fsm_ack[10]));
    RouteFSM u_FSM_11 (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[11]), .target_track_taken(fsm_target[11]|fsm_lock[10]), .train_passed(!track_taken[6] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[11]), .semafor_sig(signals[11]), .train_spawn_ack(fsm_ack[11]));
    RouteFSM u_FSM_12 (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[12]), .target_track_taken(fsm_target[12]|fsm_lock[13]), .train_passed(!track_taken[7] && !turnout_taken[2] && !turnout_taken[3]), .route_locked(fsm_lock[12]), .semafor_sig(signals[12]), .train_spawn_ack(fsm_ack[12]));
    RouteFSM u_FSM_13 (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[13]), .target_track_taken(fsm_target[13]|fsm_lock[12]), .train_passed(!track_taken[7] && !turnout_taken[0] && !turnout_taken[1]), .route_locked(fsm_lock[13]), .semafor_sig(signals[13]), .train_spawn_ack(fsm_ack[13]));
    RouteFSM u_FSM_14 (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[14]), .target_track_taken(fsm_target[14]),          .train_passed(!track_taken[8] && !turnout_taken[2]), .route_locked(fsm_lock[14]), .semafor_sig(signals[14]), .train_spawn_ack(fsm_ack[14]));
    RouteFSM u_FSM_15 (.clk(clk), .rst_n(system_rst_n), .route_req(req_sem[15]), .target_track_taken(fsm_target[15]),          .train_passed(!track_taken[9] && !turnout_taken[3]), .route_locked(fsm_lock[15]), .semafor_sig(signals[15]), .train_spawn_ack(fsm_ack[15]));

   
    LedMapper u_Mapper (
        .signals(signals),
        .track_taken(track_taken), 
        .led_data(mapped_data)
    );

    LEDSerializer u_Serializer (
        .clk(clk),
        .rst(!system_rst_n),
        .led_data(mapped_data),
        .ds(ds),
        .shcp(shcp),
        .stcp(stcp)
    );

endmodule