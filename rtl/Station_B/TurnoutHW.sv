module TurnoutHW #(
    parameter int TURNOUT_ID = 0
) (
    input  logic clk,
    input  logic rst_n,
    input  logic switch_pos,      // 0 lub 1 (bezpośrednio z fizycznego przycisku)
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
    assign isTaken = (current_train_id != 8'd0);

    always_ff @(posedge clk or negedge rst_n) begin  
        if(!rst_n) begin 
            position <= 3'd1;
            current_train_id <= 8'd0; 
        end
        else begin
            // 1. ZMIANA KIERUNKU TYLKO GDY NIE ZABLOKOWANY I PUSTY
            if (!route_locked && !isTaken) begin
                // Tłumaczenie switch_pos na pozycję rozjazdu
                // Zależnie od mapy Stacji B możesz to zmienić na np. 3'd1 do 3'd6
                position <= switch_pos ? 3'd2 : 3'd1; 
            end
            
            // 2. RUCH POCIĄGÓW
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
endmodule
