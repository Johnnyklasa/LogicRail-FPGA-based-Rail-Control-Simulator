module top_fpga(
    input  wire clk_100mhz,
    input  wire btnC,          
    input  wire [7:0] JB,      // Track sliders and switches
    input  wire [0:0] JC,      // Confirmation button
    output logic [2:0] JA,     // 74HC595 bus
    output wire Vsync, Hsync,
    output wire [3:0] vgaRed, vgaGreen, vgaBlue
);

    logic clk_40mhz, locked;
    clk_wiz_0 u_clock_wiz (.clk_in1(clk_100mhz), .clk_out1(clk_40mhz), .locked(locked), .reset(btnC));

    // --- 1. Mapping physical ports to the panel ---
    logic [1:0] slider_L = JB[1:0]; // Slider (00, 01, 10)
    logic switch_L       = JB[2];   // Switch (0=odd, 1=even)
    logic active_L       = JB[3];   // Activation switch (1=Upper, 0=Lower)
    
    logic [1:0] slider_P = JB[5:4];
    logic switch_P       = JB[6];  
    logic active_P       = JB[7];  

    logic btn_raw, btn_confirm, btn_prev, confirm_pulse;
    Debouncer u_Debouncer (.clk(clk_40mhz), .btn_in(JC[0]), .btn_out(btn_confirm));
    
    // Rising edge detector (generates 1 pulse per click)
    always_ff @(posedge clk_40mhz) btn_prev <= btn_confirm;
    assign confirm_pulse = btn_confirm & ~btn_prev;

    // --- 2. Mathematical decoders (Live Route) ---
    logic [2:0] live_route_L, live_route_P;
    assign live_route_L = (slider_L < 3) ? (slider_L * 2 + switch_L + 1) : 3'd0;
    assign live_route_P = (slider_P < 3) ? (slider_P * 2 + switch_P + 1) : 3'd0;

    // --- 3. System memory registers (Latches) ---
    logic [2:0] route_L1, route_L2, route_P1, route_P2;
    logic sem_L1_go, sem_L2_go, sem_P1_go, sem_P2_go;

    always_ff @(posedge clk_40mhz) begin
        if (btnC) begin
            route_L1 <= 0; route_L2 <= 0; route_P1 <= 0; route_P2 <= 0;
            sem_L1_go <= 0; sem_L2_go <= 0; sem_P1_go <= 0; sem_P2_go <= 0;
        end else begin
            // Dynamic route tracking for the ACTIVE track
            // Inactive track "freezes" in memory
            if (active_L) route_L1 <= live_route_L;
            else          route_L2 <= live_route_L;

            if (active_P) route_P1 <= live_route_P;
            else          route_P2 <= live_route_P;

            // Confirmation button "lights up" the semaphore for the active direction
            if (confirm_pulse) begin
                if (active_L) sem_L1_go <= 1'b1; else sem_L2_go <= 1'b1;
                if (active_P) sem_P1_go <= 1'b1; else sem_P2_go <= 1'b1;
            end
            
            // Optional protection: changing the physical switch drops the proceed signal to Stop
            if (active_L && live_route_L != route_L1) sem_L1_go <= 1'b0;
            if (!active_L && live_route_L != route_L2) sem_L2_go <= 1'b0;
            if (active_P && live_route_P != route_P1) sem_P1_go <= 1'b0;
            if (!active_P && live_route_P != route_P2) sem_P2_go <= 1'b0;
        end
    end

    // --- 4. Translation to physical semaphore colors ---
    logic [1:0] sem_signals [0:15];
    logic [47:0] flat_leds;

    always_comb begin
        for (int i = 0; i < 16; i++) sem_signals[i] = 2'h1; // Default Red

        if (sem_L1_go && route_L1 != 0) sem_signals[12] = (route_L1 == 3) ? 2'h3 : 2'h2;
        if (sem_L2_go && route_L2 != 0) sem_signals[13] = (route_L2 == 4) ? 2'h3 : 2'h2;
        if (sem_P1_go && route_P1 != 0) sem_signals[14] = (route_P1 == 3) ? 2'h3 : 2'h2;
        if (sem_P2_go && route_P2 != 0) sem_signals[15] = (route_P2 == 4) ? 2'h3 : 2'h2;

        for (int j = 0; j < 16; j++) begin
            flat_leds[j*3]     = (sem_signals[j] == 2'h1);
            flat_leds[j*3 + 1] = (sem_signals[j] == 2'h2);
            flat_leds[j*3 + 2] = (sem_signals[j] == 2'h3);
        end
    end

    // --- 5. External interfaces ---
    LED_Serializer u_Serializer (.clk(clk_40mhz), .rst(btnC), .led_data(flat_leds), .ds(JA[0]), .shcp(JA[1]), .stcp(JA[2]));

    TopVga u_TopVga (
        .clk(clk_40mhz), .rst(btnC),
        .route_L1(route_L1), .route_L2(route_L2),
        .route_P1(route_P1), .route_P2(route_P2),
        .select_L_upper(active_L), .select_P_upper(active_P),
        .signals(sem_signals), 
        .vs(Vsync), .hs(Hsync), .r(vgaRed), .g(vgaGreen), .b(vgaBlue)
    );
endmodule