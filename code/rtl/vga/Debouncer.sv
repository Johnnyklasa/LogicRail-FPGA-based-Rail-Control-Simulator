module Debouncer (
    input  logic clk,
    input  logic btn_in,
    output logic btn_out
);
    logic [19:0] counter = 0;
    logic state = 0;

    always_ff @(posedge clk) begin
        if (btn_in !== state) begin
            counter <= counter + 1;
            if (counter == 20'hFFFFF) begin 
                state <= btn_in;
                counter <= 0;
            end
        end else begin
            counter <= 0;
        end
    end
    assign btn_out = state;
endmodule