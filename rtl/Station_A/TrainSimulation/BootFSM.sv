//Autor:Jan Rutkowski
module BootFSM(
    input  logic clk,
    input  logic rst_n,
    input  logic enable,
    input  logic [15:0] random_number,
    output logic done,             
    output logic mem_we,          
    output logic [3:0] mem_addr,   
    output logic [11:0] arr_time,
    output logic [11:0] dep_time
);

    typedef enum logic [1:0] {IDLE, GET_STOP, GET_BREAK, DONE} state_t;
    state_t state, state_nxt;

  
    logic [11:0] current_time, current_time_nxt;
    logic [3:0]  train_idx, train_idx_nxt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            current_time <= 12'd240;
            train_idx <= 4'd0;
        end else begin
            state <= state_nxt;
            current_time <= current_time_nxt;
            train_idx <= train_idx_nxt;
        end
    end

    always_comb begin
       
        state_nxt = state;
        current_time_nxt = current_time;
        train_idx_nxt = train_idx;
        
        mem_we = 1'b0;
        mem_addr = train_idx;
        arr_time = 12'd0;
        dep_time = 12'd0;
        done = 1'b0;

        case (state)
            IDLE: begin
                current_time_nxt = 12'd240;
                train_idx_nxt = 4'd0;
                if (enable) state_nxt = GET_STOP;
            end
            
            GET_STOP: begin
                arr_time = current_time;
                dep_time = current_time + 12'(random_number[3:0]) + 12'd5; 
                mem_we = 1'b1; 
                state_nxt = GET_BREAK;
            end
            
            GET_BREAK: begin
                current_time_nxt = current_time + 12'(random_number[5:0]) + 12'd40;
                train_idx_nxt = train_idx + 1'b1;
                
                if (train_idx == 4'd15) state_nxt = DONE;
                else state_nxt = GET_STOP;
            end
            
            DONE: begin
                done = 1'b1;
                if (!enable) state_nxt = IDLE;
            end
        endcase
    end
endmodule
