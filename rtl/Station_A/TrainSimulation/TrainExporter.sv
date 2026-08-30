//Autor:Jan Rutkowski
module TrainExporter (
    input  logic clk,
    input  logic rst_n,
    input  logic train_tick_pulse,
    input  logic tx_busy,
    
    input  logic track8_taken,
    input  logic [7:0] track8_train_id,
    
    output logic send_train_req,
    output logic [7:0] tx_train_id_out
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            send_train_req <= 1'b0;
            tx_train_id_out <= 8'd0;
        end else begin
            if (send_train_req && !tx_busy) begin
                send_train_req <= 1'b0;
            end
            else if (track8_taken && train_tick_pulse) begin
                tx_train_id_out <= track8_train_id; 
                send_train_req  <= 1'b1;           
            end
        end
    end
endmodule
