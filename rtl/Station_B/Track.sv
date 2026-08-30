//Autor: Jan Rutkowski
module Track #(
    parameter int TRACK_ID = 0
)(
    input  logic clk,
    input  logic rst_n,
    input  logic train_tick,         
    
    
    input  logic move_R,      
    input  logic move_L,      
    
  
    input  logic track_R_taken,
    input  logic track_L_taken,
    
    
    input  logic [7:0] train_id_in_L, 
    input  logic [7:0] train_id_in_R, 
    
    output logic [7:0] current_train_id,
    output logic       isTaken
);

    assign isTaken = (current_train_id != 8'd0);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_train_id <= 8'd0;
        end 
        else if (train_tick) begin
           
            if (isTaken && move_R && !track_R_taken) begin
                current_train_id <= 8'd0; 
            end
            else if (isTaken && move_L && !track_L_taken) begin
                current_train_id <= 8'd0; 
            end
            
         
            else if (!isTaken) begin
               
                if (train_id_in_L != 8'd0) begin
                    current_train_id <= train_id_in_L; 
                end
                
                else if (train_id_in_R != 8'd0) begin
                    current_train_id <= train_id_in_R;
                end
            end
        end
    end
endmodule









