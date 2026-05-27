
module Semafor (
    input logic clk,
    input logic rst,
    input logic MouseLeftClick,
    input logic [11:0] X_POS,
    input logic [11:0] Y_POS, 
    output logic [1:0] OutSignal
);

import Map_pkg::*;
import SRK_pkg::*;


logic [11:0] x_mouse, y_mouse;
logic [11:0] x_s1, x_s2, y_s1, y_s2;



logic MouseClick;

ClickDetector u_ClickDetector(
    .clk(clk),
    .Signal(MouseLeftClick),
    .pos_edge(MouseClick),
    .neg_edge()
);


typedef enum logic [1:0] { 
    OFF, 
    RED_S1,
    ORANGE_S5,
    GREEN_S2
} STATE;

STATE state_nxt;
STATE state;

always_ff @(posedge clk) begin  
    if(rst) begin 
        state <= RED_S1;
    end
    else begin
        state <=state_nxt;
        x_s1 <= X_POS;
        x_s2 <= x_s1;
        y_s1 <= Y_POS;
        y_s2 <= y_s1;
    end
end
     
always_comb begin  
    state_nxt = state;
    case (state) 
        RED_S1: OutSignal = 2'h1;
        ORANGE_S5: OutSignal = 2'h2;
        GREEN_S2 : OutSignal = 2'h3;
        OFF: OutSignal = 2'h0;
        default : state_nxt = OFF;
    endcase

    if (MouseClick && 
    ((X_POS >= Semafor1XPos )&& (X_POS <= Semafor1XPos + SemaforWidth))&&
    ((Y_POS >= Semafor1YPos )&& (Y_POS <= Semafor1YPos + SemaforHeight)))
     begin
        case(state)
            RED_S1: state_nxt = ORANGE_S5;
            ORANGE_S5: state_nxt = GREEN_S2;
            GREEN_S2 : state_nxt = RED_S1;
            OFF: state_nxt = RED_S1;
        endcase
    end
end
endmodule
