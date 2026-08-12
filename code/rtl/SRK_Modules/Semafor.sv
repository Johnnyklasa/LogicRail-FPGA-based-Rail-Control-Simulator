module Semafor #(
    parameter int SEMAFOR_ID = 0 
)(
    input logic clk,
    input logic rst_n,
    input logic MouseLeftClick,
    input logic [11:0] X_POS,
    input logic [11:0] Y_POS, 
    output logic [1:0] OutSignal
);

    import Map_pkg::*;
    import SRK_pkg::*;

    logic MouseClick;

    ClickDetector u_ClickDetector(
        .clk(clk),
        .Signal(MouseLeftClick),
        .pos_edge(MouseClick),
        .neg_edge()
    );

    typedef enum logic [1:0] { 
        OFF       = 2'h0, 
        RED_S1    = 2'h1,
        ORANGE_S5 = 2'h2,
        GREEN_S2  = 2'h3
    } STATE;

    STATE state_nxt;
    STATE state;

    always_ff @(posedge clk or negedge rst_n) begin  
        if(!rst_n) begin 
            state <= RED_S1;
        end
        else begin
            state <= state_nxt;
        end
    end
         
    always_comb begin  
       
        state_nxt = state;
        OutSignal = 2'h0; 

        
        case (state) 
            RED_S1:    OutSignal = 2'h1;
            ORANGE_S5: OutSignal = 2'h2;
            GREEN_S2:  OutSignal = 2'h3;
            OFF:       OutSignal = 2'h0;
            default:   state_nxt = OFF;
        endcase

        if (MouseClick && 
           (X_POS >= SemaforXPos[SEMAFOR_ID]) && (X_POS <= SemaforXPos[SEMAFOR_ID] + SemaforWidth) &&
           (Y_POS >= SemaforYPos[SEMAFOR_ID]) && (Y_POS <= SemaforYPos[SEMAFOR_ID] + SemaforHeight))
        begin
            case(state)
                RED_S1:    state_nxt = ORANGE_S5;
                ORANGE_S5: state_nxt = GREEN_S2;
                GREEN_S2:  state_nxt = RED_S1;
                OFF:       state_nxt = RED_S1;
                default:   state_nxt = RED_S1;
            endcase
        end
    end

endmodule
