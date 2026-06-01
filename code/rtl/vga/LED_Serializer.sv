module LED_Serializer (
    input  logic clk,           // System clock (40 MHz)
    input  logic rst,           // System reset
    input  logic [47:0] led_data, // 48-bit bus of LEDs 
    
    // Outputs to physical PMOD pins
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

    // Finite State Machine (FSM)
    typedef enum logic [1:0] {IDLE, SHIFT, LATCH} state_t;
    state_t state;

    logic [5:0] bit_cnt;     // Bit counter (0-47)
    logic [47:0] shift_reg;  // Internal buffer

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
                    shift_reg <= led_data; // Latch current colors
                    bit_cnt <= 47;         // Start from the most significant bit
                    state <= SHIFT;
                    stcp <= 0;
                end
                
                SHIFT: begin
                    shcp <= ~shcp; // Toggle shift clock for registers
                    if (~shcp) begin 
                        // On clock falling edge 
                        ds <= shift_reg[bit_cnt];
                    end else begin 
                        // On clock rising edge 
                        if (bit_cnt == 0) begin
                            state <= LATCH;
                        end else begin
                            bit_cnt <= bit_cnt - 1;
                        end
                    end
                end
                
                LATCH: begin
                    stcp <= 1;  // Latch pulse
                    shcp <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule