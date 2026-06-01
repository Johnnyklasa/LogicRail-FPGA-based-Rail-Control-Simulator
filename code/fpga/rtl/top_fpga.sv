module top_fpga(
    input  wire clk_100mhz,    // 100 MHz oscillator from Basys 3
    input  wire btnC,          // Reset button
    input  wire [15:0] sw,     // 16 switches for control
    
    // Outputs to external control panel (48 LEDs via 6x 74HC595)
    output logic [2:0] JA,     // JA[0]=DS, JA[1]=SHCP, JA[2]=STCP
    
    // VGA output ports
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue
);

    // Clock signals
    logic clk_40mhz;
    logic locked;

    // Internal signal bus
    logic [1:0] sem_signals [0:15];
    logic [47:0] flat_leds;


    clk_wiz_0 u_clock_wiz (
        .clk_in1(clk_100mhz),
        .clk_out1(clk_40mhz),
        .locked(locked),
        .reset(btnC)
    );

    // --- 2. Decision Logic 
    always_comb begin
        for (int i = 0; i < 16; i++) sem_signals[i] = 2'h1; 

        // Left side logic
        if (sw[6]) begin 
             if (sw[2:0] != 0) sem_signals[12] = (sw[2:0] == 3) ? 2'h3 : 2'h2;
        end else begin   
             if (sw[5:3] != 0) sem_signals[13] = (sw[5:3] == 4) ? 2'h3 : 2'h2;
        end

        // Right side logic
        if (sw[13]) begin 
             if (sw[9:7] != 0) sem_signals[14] = (sw[9:7] == 3) ? 2'h3 : 2'h2;
        end else begin    
             if (sw[12:10] != 0) sem_signals[15] = (sw[12:10] == 4) ? 2'h3 : 2'h2;
        end
    end

    // --- 3. Color Decoding 
    always_comb begin
        for (int i = 0; i < 16; i++) begin
            flat_leds[i*3]     = (sem_signals[i] == 2'h1); // Bit 0 = Red
            flat_leds[i*3 + 1] = (sem_signals[i] == 2'h2); // Bit 1 = Yellow
            flat_leds[i*3 + 2] = (sem_signals[i] == 2'h3); // Bit 2 = Green
        end
    end

    // --- 4. Serialization to external control panel ---
    LED_Serializer u_Serializer (
        .clk(clk_40mhz), 
        .rst(btnC),
        .led_data(flat_leds),
        .ds(JA[0]), .shcp(JA[1]), .stcp(JA[2])
    );

    // --- 5. VGA Graphics Engine ---
    TopVga u_TopVga (
        .clk(clk_40mhz), 
        .rst(btnC),
        .route_L1(sw[2:0]), 
        .route_L2(sw[5:3]),
        .route_P1(sw[9:7]), 
        .route_P2(sw[12:10]),
        .select_L_upper(sw[6]), 
        .select_P_upper(sw[13]),
        .signals(sem_signals), 
        .vs(Vsync), 
        .hs(Hsync),
        .r(vgaRed), 
        .g(vgaGreen), 
        .b(vgaBlue)
    );

endmodule