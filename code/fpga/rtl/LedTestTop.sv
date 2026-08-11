module LedTestTop (
    input  logic clk,  
    input  logic rst,
    output logic ds,
    output logic shcp,
    output logic stcp
);
    
    logic [26:0] counter = 0;
    logic tick_1Hz;

    always_ff @(posedge clk) begin
        if (rst) counter <= 0;
        else if (counter == 100_000_000 - 1) counter <= 0;
        else counter <= counter + 1;
    end
    assign tick_1Hz = (counter == 0);
    
   
    logic [23:0] fast_counter = 0;
    logic tick_10Hz;
    always_ff @(posedge clk) begin
        if (rst) fast_counter <= 0;
        else if (fast_counter == 10_000_000 - 1) fast_counter <= 0;
        else fast_counter <= fast_counter + 1;
    end
    assign tick_10Hz = (fast_counter == 0);

    // Automat sekwencji
    logic [1:0] signals [0:15];
    logic [1:0] state = 0;
    logic [5:0] chase_idx = 0; // Od 0 do 47

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= 0;
            chase_idx <= 0;
            foreach (signals[i]) signals[i] <= 2'h0;
        end else begin
            
            if (tick_1Hz && state != 2'd3) begin
                state <= state + 1;
                case (state)
                    2'd0: foreach (signals[i]) signals[i] <= 2'h1; // Wszystkie Czerwone
                    2'd1: foreach (signals[i]) signals[i] <= 2'h2; // Wszystkie Zielone
                    2'd2: foreach (signals[i]) signals[i] <= 2'h3; // Wszystkie Żółte
                endcase
            end
            
            
            if (state == 2'd3 && tick_10Hz) begin
                if (chase_idx < 47) chase_idx <= chase_idx + 1;
                else begin
                    chase_idx <= 0;
                    state <= 0; 
                end
            end
        end
    end

    
    logic [47:0] mapped_data, final_led_data;
    
    LedMapper u_Mapper (
        .signals(signals),
        .led_data(mapped_data)
    );

    always_comb begin
        if (state == 2'd3) begin
            final_led_data = 48'b0;
            final_led_data[chase_idx] = 1'b1; 
        end else begin
            final_led_data = mapped_data;     
        end
    end

    
    LED_Serializer u_Serializer (
        .clk(clk),
        .rst(rst),
        .led_data(final_led_data),
        .ds(ds),
        .shcp(shcp),
        .stcp(stcp)
    );
endmodule