module Turnout #(parameter int TURNOUT_ID = 0) (
    input  logic clk,
    input  logic rst_n,
    input  logic MouseLeftClick,
    input  logic [11:0] X_POS,
    input  logic [11:0] Y_POS, 
    output logic [2:0] position,
    output logic isTaken
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
    
    
    assign isTaken = 1'b0;

    always_ff @(posedge clk or negedge rst_n) begin  
        if(!rst_n) begin 
            state <= ROUTE1;
        end
        else begin
            state <= state_nxt;
        end
    end

    always_comb begin
        state_nxt = state;
        position  = 3'h1;

      
        case (state) 
            ROUTE1: position = 3'h1;
            ROUTE2: position = 3'h2;
            ROUTE3: position = 3'h3;
            ROUTE4: position = 3'h4;
            ROUTE5: position = 3'h5;
            ROUTE6: position = 3'h6;
            default: position = 3'h1;
        endcase

        
        if (MouseClick && 
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

