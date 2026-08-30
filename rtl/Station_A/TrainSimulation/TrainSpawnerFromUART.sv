//Autor:Karol Sitko
module TrainSpawnerFromUART (
    input  logic clk,
    input  logic rst_n,
    
    
    input  logic train_tick,          
    input  logic approach_track_taken, 
    
    
    input  logic [7:0] rx_train_id,
    input  logic rx_train_req,

    output logic train_waiting,        
    output logic [7:0] TrainID
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            TrainID <= 8'd0;
            train_waiting <= 1'b0;
        end 
        else begin
            
            if (rx_train_req && !train_waiting) begin
                TrainID <= rx_train_id;
                train_waiting <= 1'b1; 
            end 
            
            else if (train_waiting) begin
                if (!approach_track_taken && train_tick) begin
                    train_waiting <= 1'b0; 
                    TrainID <= 8'd0;       
                end
            end
        end
    end

endmodule
