module RouteFSM(
    input logic clk,
    input logic rst_n,
    input  logic route_req,          

    input  logic target_track_taken,  
    input  logic train_passed,        

    output logic route_locked,        
    output logic [1:0] semafor_sig, 

    output logic train_spawn_ack     
);

typedef enum logic {IDLE, CHECK_ROUTE, LOCK_ROUTE, OPEN_SIGNAL, TRAIN_PASSING, RELEASE_ROUTE} state_t;
state_t state, nxt_state;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= IDLE;
    else        state <= state_nxt;
end

always_comb begin
    state_nxt = state;
    route_locked = 1'b0;
    semafor_sig = 2'b00; 
    train_spawn_ack = 1'b0;
    case (state) 
        IDLE : 
            if(route_req)begin
                state_nxt = CHECK_ROUTE;
            end
            else begin
                state_nxt = IDLE;
            end
        CHECK_ROUTE : 
            if(!target_track_taken) begin
                state_nxt = LOCK_ROUTE;
            end 
            else begin 
                state_nxt =IDLE;
            end
        LOCK_ROUTE:
            route_locked =1'b1;
            state_nxt = OPEN_SIGNAL;
        OPEN_SIGNAL: 
            semafor_sig = 2'b1;
            route_locked =1'b1;
            train_spawn_ack = 1'b1;
            state_nxt = TRAIN_PASSING;
            if (target_track_taken) begin 
                state_nxt = TRAIN_PASSING;
            end
        TRAIN_PASSING:
            if(!train_passed) begin 
                semafor_sig = 2'b0;
            end
            else begin
                state_nxt = RELEASE_ROUTE;
            end
        RELEASE_ROUTE:
            state_nxt = IDLE;

    endcase  
end
endmodule
