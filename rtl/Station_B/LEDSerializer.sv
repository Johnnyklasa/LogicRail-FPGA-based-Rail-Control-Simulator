module LEDSerializer (
    input  logic clk,           // Zegar systemowy
    input  logic rst,           // Reset
    input  logic [47:0] led_data, // Wektor danych do wysłania
    output logic ds,            // Data Serial
    output logic shcp,          // Shift Clock
    output logic stcp           // Latch Clock
);
    logic [5:0] clk_div;
    logic shift_tick;
    
    always_ff @(posedge clk) begin
        if (rst) clk_div <= 0;
        else clk_div <= clk_div + 1;
    end
    assign shift_tick = (clk_div == 0); 

    typedef enum logic [1:0] {IDLE, SHIFT, LATCH} state_t;
    state_t state;

    logic [5:0] bit_cnt;
    logic [47:0] shift_reg;

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            bit_cnt <= 0;
            shift_reg <= 0;
            ds <= 0;
            shcp <= 0;
            stcp <= 0;
        end else if (shift_tick) begin
            case (state)
                IDLE: begin
                    shift_reg <= led_data;
                    bit_cnt <= 47;
                    state <= SHIFT;
                    stcp <= 0;
                end
                SHIFT: begin
                    shcp <= ~shcp;
                    if (~shcp) ds <= shift_reg[bit_cnt];
                    else begin 
                        if (bit_cnt == 0) state <= LATCH;
                        else bit_cnt <= bit_cnt - 1;
                    end
                end
                LATCH: begin
                    stcp <= 1;
                    shcp <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
