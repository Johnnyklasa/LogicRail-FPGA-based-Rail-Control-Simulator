//Autor:Jan Rutkowski
module TrainGenerator (
    input  logic clk,
    input  logic rst_n,
    
   
    input  logic [4:0] hours,
    input  logic [5:0] minutes,
    input  logic minute_tick,
    input  logic train_tick,          
    output logic [3:0] addr_read,
    input  logic [7:0] ram_train_id,
    input  logic [11:0] ram_arr_time,
    input  logic approach_track_taken, 
    output logic train_waiting,        
    output logic [7:0] TrainID
);

    logic [11:0] current_time;
    assign current_time = (hours * 12'd60) + minutes;

   
    logic [4:0] next_train_idx;
    
  
    assign addr_read = next_train_idx[3:0];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            TrainID <= 8'd0;
            train_waiting <= 1'b0;
            next_train_idx <= 5'd0; 
        end 
        else begin
            if (!train_waiting) begin
               
                if (next_train_idx < 5'd16 && current_time == ram_arr_time) begin
                    TrainID <= ram_train_id;
                    train_waiting <= 1'b1; 
                    next_train_idx <= next_train_idx + 1'b1; 
                end
            end 
            else begin
                if (!approach_track_taken && train_tick) begin
                    train_waiting <= 1'b0; 
                    TrainID <= 8'd0;       
                end
            end
        end
    end

endmodule
