
module Semafor (
    input logic clk,
    input logic rst,
    input logic SignalIn, 
    output logic [1:0] OutSignal
);



logic MouseClick;

ClickDetector u_ClickDetector(
    .clk(clk),
    .Signal(SignalIn),
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
    end
end
     
always_comb begin  
    state_nxt = state;
    case (state) 
        RED_S1: OutSignal = 2'h1;
        ORANGE_S5: OutSignal = 2'h2;
        GREEN_S2 : OutSignal = 2'h3;
        OFF: OutSignal = 2'h0;
        default state_nxt = OFF;
    endcase

    if (MouseClick) begin
        case(state)
            RED_S1: state_nxt = ORANGE_S5;
            ORANGE_S5: state_nxt = GREEN_S2;
            GREEN_S2 : state_nxt = RED_S1;
            OFF: state_nxt = RED_S1;
        endcase
    end
end
endmodule
