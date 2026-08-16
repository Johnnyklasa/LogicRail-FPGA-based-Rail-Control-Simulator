module TrainGenerator (
    input  logic clk,
    input  logic rst_n,
    
    // Zegary
    input  logic [4:0] hours,
    input  logic [5:0] minutes,
    input  logic minute_tick,
    input  logic train_tick,          
    
    input  logic approach_track_taken, 
    output logic train_waiting,        
    output logic [7:0] TrainID
);

    import Timetable_pkg::*;

    logic [11:0] current_time;
    assign current_time = (hours * 12'd60) + minutes;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            TrainID <= 8'd0;
            train_waiting <= 1'b0;
        end 
        else begin
            if (!train_waiting) begin
                // Czekamy na pociąg z niezawodnych tablic równoległych
                for (int i = 0; i < SCHEDULE_SIZE; i++) begin
                    if (current_time == Sched_Arrival[i]) begin
                        TrainID <= Sched_TrainID[i];
                        train_waiting <= 1'b1; 
                    end
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
