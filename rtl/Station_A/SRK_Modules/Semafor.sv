module Semafor #(
    parameter int SEMAFOR_ID = 0 
)(
    input logic clk,
    input logic rst_n,
    input logic MouseLeftClick,
    input logic [11:0] X_POS,
    input logic [11:0] Y_POS, 
    
    input  logic [1:0] color_from_fsm,
    output logic route_req_out,        
    
   
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

assign OutSignal = color_from_fsm;

    
    always_comb begin
        route_req_out = 1'b0;
        
        if (MouseClick && 
           (X_POS >= SemaforXPos[SEMAFOR_ID]) && (X_POS <= SemaforXPos[SEMAFOR_ID] + SemaforWidth) &&
           (Y_POS >= SemaforYPos[SEMAFOR_ID]) && (Y_POS <= SemaforYPos[SEMAFOR_ID] + SemaforHeight)) 
        begin
            route_req_out = 1'b1; 
    end
    end
endmodule
