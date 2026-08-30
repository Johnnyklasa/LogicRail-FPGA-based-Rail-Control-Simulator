//Autor: Jan Rutkowskis
module RouteFSM(
    input  logic clk,
    input  logic rst_n,
    input  logic route_req,          
    input  logic target_track_taken,  
    input  logic train_passed,        

    output logic route_locked,        
    output logic [1:0] semafor_sig, 
    output logic train_spawn_ack     
);

    typedef enum logic [2:0] {
        IDLE, 
        CHECK_ROUTE, 
        LOCK_ROUTE, 
        OPEN_SIGNAL, 
        TRAIN_PASSING, 
        RELEASE_ROUTE
    } state_t;

    state_t state, state_nxt;

   
    logic req_prev;
    logic req_pulse;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            req_prev <= 1'b0;
        end else begin
            state <= state_nxt;
            req_prev <= route_req;
        end
    end

    
    assign req_pulse = route_req & ~req_prev;
    

    always_comb begin
      
        state_nxt = state;
        route_locked = 1'b0;     
        semafor_sig = 2'b00;     
        train_spawn_ack = 1'b0;
        
        case (state) 
            IDLE : begin 
                if (req_pulse) begin  
                    state_nxt = CHECK_ROUTE;
                end
            end
            
            CHECK_ROUTE : begin
                if (!target_track_taken) begin
                    state_nxt = LOCK_ROUTE;
                end 
                else begin 
                    state_nxt = IDLE;
                end
            end
            
            LOCK_ROUTE : begin
                route_locked = 1'b1;
                state_nxt = OPEN_SIGNAL;
            end
            
            OPEN_SIGNAL: begin
                semafor_sig = 2'b01; 
                route_locked = 1'b1;
                train_spawn_ack = 1'b1;
                
                
                if (req_pulse) begin 
                    state_nxt = RELEASE_ROUTE;
                end
                else if (target_track_taken) begin 
                    state_nxt = TRAIN_PASSING;
                end
            end
            
            TRAIN_PASSING: begin
                route_locked = 1'b1; 
                semafor_sig = 2'b00; 
                
                if (train_passed) begin 
                    state_nxt = RELEASE_ROUTE;
                end
                
                else if (req_pulse) begin 
                    state_nxt = RELEASE_ROUTE;
                end
            end
            
            RELEASE_ROUTE: begin
                state_nxt = IDLE;
            end
        endcase  
    end

endmodule
