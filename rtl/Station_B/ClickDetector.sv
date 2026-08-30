//Autor: Jan Rutkowski
module ClickDetector(
    input logic clk,
    input logic Signal,
    output logic pos_edge,
    output logic neg_edge
);

logic sig_last;

always_ff @(posedge clk) begin
    sig_last <= Signal;
end

assign pos_edge = (Signal & ~sig_last);
assign neg_edge = (~Signal & sig_last);

endmodule



