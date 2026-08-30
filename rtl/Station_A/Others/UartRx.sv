module UartRx #(
    parameter CLK_FREQ = 65_000_000,
    parameter BAUD_RATE = 115200
)(
    input  logic clk,
    input  logic rst_n,
    input  logic rx,
    output logic [7:0] rx_data,
    output logic rx_ready 
);
    localparam BIT_TMR_MAX = CLK_FREQ / BAUD_RATE;
    localparam BIT_TMR_HALF = BIT_TMR_MAX / 2;
    
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state, state_nxt;
    
    logic [15:0] bit_tmr, bit_tmr_nxt;
    logic [2:0]  bit_idx, bit_idx_nxt;
    logic [7:0]  data_reg, data_reg_nxt;
    

    logic rx_sync_1, rx_sync_2;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) {rx_sync_2, rx_sync_1} <= 2'b11;
        else {rx_sync_2, rx_sync_1} <= {rx_sync_1, rx};
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_tmr <= 0;
            bit_idx <= 0;
            data_reg <= 0;
            rx_data <= 0;
            rx_ready <= 0;
        end else begin
            state <= state_nxt;
            bit_tmr <= bit_tmr_nxt;
            bit_idx <= bit_idx_nxt;
            data_reg <= data_reg_nxt;
            

            if (state == STOP && bit_tmr == BIT_TMR_MAX - 1) begin
                rx_data <= data_reg;
                rx_ready <= 1'b1;
            end else begin
                rx_ready <= 1'b0;
            end
        end
    end

    always_comb begin
        state_nxt = state;
        bit_tmr_nxt = bit_tmr;
        bit_idx_nxt = bit_idx;
        data_reg_nxt = data_reg;

        case (state)
            IDLE: begin
                if (rx_sync_2 == 1'b0) begin // Wykryto bit startu
                    bit_tmr_nxt = 0;
                    state_nxt = START;
                end
            end
            START: begin
                if (bit_tmr == BIT_TMR_HALF) begin
                    if (rx_sync_2 == 1'b0) begin 
                        bit_tmr_nxt = bit_tmr + 1;
                    end else state_nxt = IDLE; // Fałszywy alarm (glitch)
                end else if (bit_tmr == BIT_TMR_MAX - 1) begin
                    bit_tmr_nxt = 0;
                    bit_idx_nxt = 0;
                    state_nxt = DATA;
                end else bit_tmr_nxt = bit_tmr + 1;
            end
            DATA: begin
                if (bit_tmr == BIT_TMR_HALF) begin
                    data_reg_nxt[bit_idx] = rx_sync_2; 
                end
                
                if (bit_tmr == BIT_TMR_MAX - 1) begin
                    bit_tmr_nxt = 0;
                    if (bit_idx == 7) state_nxt = STOP;
                    else bit_idx_nxt = bit_idx + 1;
                end else bit_tmr_nxt = bit_tmr + 1;
            end
            STOP: begin
                if (bit_tmr == BIT_TMR_MAX - 1) begin
                    state_nxt = IDLE;
                end else bit_tmr_nxt = bit_tmr + 1;
            end
        endcase
    end
endmodule
