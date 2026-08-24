module UartTx #(
    parameter CLK_FREQ = 65_000_000,
    parameter BAUD_RATE = 115200
)(
    input  logic clk,
    input  logic rst_n,
    input  logic tx_start,
    input  logic [7:0] tx_data,
    output logic tx,
    output logic tx_busy
);
    localparam BIT_TMR_MAX = CLK_FREQ / BAUD_RATE;
    
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state, state_nxt;
    
    logic [15:0] bit_tmr, bit_tmr_nxt;
    logic [2:0]  bit_idx, bit_idx_nxt;
    logic [7:0]  data_reg, data_reg_nxt;
    logic tx_nxt;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_tmr <= 0;
            bit_idx <= 0;
            data_reg <= 0;
            tx <= 1'b1; 
        end else begin
            state <= state_nxt;
            bit_tmr <= bit_tmr_nxt;
            bit_idx <= bit_idx_nxt;
            data_reg <= data_reg_nxt;
            tx <= tx_nxt;
        end
    end

    always_comb begin
        state_nxt = state;
        bit_tmr_nxt = bit_tmr;
        bit_idx_nxt = bit_idx;
        data_reg_nxt = data_reg;
        tx_nxt = tx;
        tx_busy = 1'b1;

        case (state)
            IDLE: begin
                tx_nxt = 1'b1;
                tx_busy = 1'b0;
                if (tx_start) begin
                    data_reg_nxt = tx_data;
                    bit_tmr_nxt = 0;
                    state_nxt = START;
                end
            end
            START: begin
                tx_nxt = 1'b0; // Bit startu (0)
                if (bit_tmr == BIT_TMR_MAX - 1) begin
                    bit_tmr_nxt = 0;
                    bit_idx_nxt = 0;
                    state_nxt = DATA;
                end else bit_tmr_nxt = bit_tmr + 1;
            end
            DATA: begin
                tx_nxt = data_reg[bit_idx];
                if (bit_tmr == BIT_TMR_MAX - 1) begin
                    bit_tmr_nxt = 0;
                    if (bit_idx == 7) state_nxt = STOP;
                    else bit_idx_nxt = bit_idx + 1;
                end else bit_tmr_nxt = bit_tmr + 1;
            end
            STOP: begin
                tx_nxt = 1'b1; // Bit stopu (1)
                if (bit_tmr == BIT_TMR_MAX - 1) begin
                    state_nxt = IDLE;
                end else bit_tmr_nxt = bit_tmr + 1;
            end
        endcase
    end
endmodule