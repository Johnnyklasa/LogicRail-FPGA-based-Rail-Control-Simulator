module Track(
    input logic clk,
    input logic rst_n,
    input logic [7:0] train_id,
    input logic [1:0] entry_semafor_signal,
    input logic [1:0] output_semafor_signal,
    input logic train_arrive,
    input logic train_leave,
    output logic isTaken,
    output logic [7:0] train_id_stored
);

assign isTaken = (train_id_stored != 0);
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        train_id_stored <= 0;
    end
    else if(train_arrive) begin
        train_id_stored <= train_id;
    end
    else if(train_leave)begin
        train_id_stored <= 8'd0;
    end

end





endmodule
