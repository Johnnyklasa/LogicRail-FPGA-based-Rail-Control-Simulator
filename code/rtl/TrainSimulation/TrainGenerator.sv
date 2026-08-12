module TrainGenerator (
    input  logic clk,
    input  logic rst_n,
    
    // Zegar czasu rzeczywistego w symulacji
    input  logic [4:0] hours,
    input  logic [5:0] minutes,
    input  logic minute_tick,
    
    // Interfejs komunikacji ze stacją (Handshake)
    input  logic spawn_ack,        // Potwierdzenie z RouteFSM (zielone światło)
    output logic train_waiting,    // Sygnał, że pociąg stoi pod semaforem
    output logic [7:0] TrainID
);

    import Timetable_pkg::*;

    // Zmienne wewnętrzne
    logic [11:0] current_time;
    assign current_time = (hours * 12'd60) + minutes;

 
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            TrainID <= 8'd0;
            train_waiting <= 1'b0;
        end 
        else begin
            
            if (!train_waiting) begin
                if (minute_tick) begin
                    for (int i = 0; i < SCHEDULE_SIZE; i++) begin
                        if (current_time == Scheldue[i].ArrivalTime) begin
                            TrainID <= Scheldue[i].TrainID;
                            train_waiting <= 1'b1; 
                        end
                    end
                end
            end 
            
            else begin
                if (spawn_ack) begin
                    train_waiting <= 1'b0; 
                    TrainID <= 8'd0;       
                end
            end
        end
    end

endmodule
