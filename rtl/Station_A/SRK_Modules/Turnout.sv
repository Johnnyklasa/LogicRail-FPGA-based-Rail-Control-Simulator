//Autor:Jan Rutkowski
module Turnout #(
    parameter int TURNOUT_ID = 0
) (
    input  logic clk,
    input  logic rst_n,
    input  logic MouseLeftClick,
    input  logic [11:0] X_POS,
    input  logic [11:0] Y_POS, 
    input  logic route_locked, 
    input  logic move_R,      
    input  logic move_L,       
    input  logic train_tick,       
    input  logic track_R_taken,   
    input  logic track_L_taken,    
    input  logic [7:0] train_id_in_L, 
    input  logic [7:0] train_id_in_R, 

    output logic [7:0] current_train_id,
    output logic [2:0] position,
    output logic       isTaken
);
    import Map_pkg::*;

    logic MouseClick;

    ClickDetector u_ClickDetector(
        .clk(clk),
        .Signal(MouseLeftClick),
        .pos_edge(MouseClick),
        .neg_edge()
    );

    typedef enum logic [2:0] { 
        ROUTE1 = 3'h1, 
        ROUTE2 = 3'h2,
        ROUTE3 = 3'h3,
        ROUTE4 = 3'h4,
        ROUTE5 = 3'h5,
        ROUTE6 = 3'h6
    } STATE;

    STATE state_nxt;
    STATE state;
    
    assign isTaken = (current_train_id != 8'd0);

  
    always_ff @(posedge clk or negedge rst_n) begin  
        if(!rst_n) begin 
            state <= ROUTE1;
            current_train_id <= 8'd0; 
        end
        else begin
            state <= state_nxt;
            
          
            if (train_tick) begin
               
                if (isTaken && move_R && !track_R_taken) begin
                    current_train_id <= 8'd0; 
                end
                else if (isTaken && move_L && !track_L_taken) begin
                    current_train_id <= 8'd0; 
                end
                
               
                else if (!isTaken) begin
                    if (move_R && train_id_in_L != 8'd0) begin
                        current_train_id <= train_id_in_L; 
                    end
                    else if (move_L && train_id_in_R != 8'd0) begin
                        current_train_id <= train_id_in_R; 
                    end
                end
            end
        end
    end

    always_comb begin
        state_nxt = state;
        
        case (state) 
            ROUTE1: position = 3'h1;
            ROUTE2: position = 3'h2;
            ROUTE3: position = 3'h3;
            ROUTE4: position = 3'h4;
            ROUTE5: position = 3'h5;
            ROUTE6: position = 3'h6;
            default: position = 3'h1;
        endcase
        
        
        if (MouseClick && !isTaken && !route_locked &&
           (X_POS >= TurnoutXPos[TURNOUT_ID]) && (X_POS <= TurnoutXPos[TURNOUT_ID] + TURNOUT_WIDTH) &&
           (Y_POS >= TurnoutYPos[TURNOUT_ID]) && (Y_POS <= TurnoutYPos[TURNOUT_ID] + TURNOUT_HEIGHT))
        begin
            case(state)
                ROUTE1:  state_nxt = ROUTE2;
                ROUTE2:  state_nxt = ROUTE3;
                ROUTE3:  state_nxt = ROUTE4;
                ROUTE4:  state_nxt = ROUTE5;
                ROUTE5:  state_nxt = ROUTE6;
                ROUTE6:  state_nxt = ROUTE1;
                default: state_nxt = ROUTE1;
            endcase
        end
    end
endmodule
