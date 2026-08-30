module RandomNumber (
    input  logic clk,
    output logic [31:0] rnd 
);
    logic [31:0] lfsr = 32'hDEADBEEF; 
    
    always_ff @(posedge clk) begin
        if (lfsr == 32'd0) begin
            lfsr <= 32'hDEADBEEF; 
        end else begin
            
            lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0]};
        end
    end
    
    assign rnd = lfsr;
endmodule
