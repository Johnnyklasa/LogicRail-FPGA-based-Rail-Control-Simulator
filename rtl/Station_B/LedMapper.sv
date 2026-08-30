module LedMapper (
    input  logic [1:0] signals [0:15],
    input  logic [9:0] track_taken, 
    output logic [47:0] led_data
);
    always_comb begin
        led_data = 48'b0;

        // Kodowanie FSM: 0=Czerwony, 1=Zielony
        // Zamiast żółtego (2'h2) wstawiamy fizyczną flagę zajętości toru (track_taken)

        // 1. TORY WJAZDOWE LEWE (Q0 - Q5)
        led_data[0] = (signals[12] == 2'h1); 
        led_data[1] = (signals[12] == 2'h0); 
        led_data[2] = track_taken[0];        // Zajętość szlaku L1
        
        led_data[3] = (signals[13] == 2'h1); 
        led_data[4] = (signals[13] == 2'h0); 
        led_data[5] = track_taken[1];        // Zajętość szlaku L2

        // 2. LEWA STRONA STACJI (Perony Q6 - Q23)
        led_data[6] = (signals[0] == 2'h1);  
        led_data[7] = (signals[0] == 2'h0);  
        led_data[8] = track_taken[2];        // Tor 1L (Tor wewn. nr 2)
        
        led_data[9]  = (signals[2] == 2'h1); 
        led_data[10] = (signals[2] == 2'h0); 
        led_data[11] = track_taken[3];       // Tor 2L (Tor wewn. nr 3)
        
        led_data[12] = (signals[4] == 2'h1); 
        led_data[13] = (signals[4] == 2'h0); 
        led_data[14] = track_taken[4];       // Tor 3L (Tor wewn. nr 4)
        
        led_data[15] = (signals[6] == 2'h1); 
        led_data[16] = (signals[6] == 2'h0); 
        led_data[17] = track_taken[5];       // Tor 4L (Tor wewn. nr 5)
        
        led_data[18] = (signals[8] == 2'h1); 
        led_data[19] = (signals[8] == 2'h0);
        led_data[20] = track_taken[6];       // Tor 5L (Tor wewn. nr 6)
        
        led_data[21] = (signals[10] == 2'h1); 
        led_data[22] = (signals[10] == 2'h0);
        led_data[23] = track_taken[7];       // Tor 6L (Tor wewn. nr 7)

        // 3. PRAWA STRONA STACJI (Perony Q24 - Q41)
        led_data[24] = (signals[1] == 2'h1); 
        led_data[25] = (signals[1] == 2'h0);
        led_data[26] = track_taken[2];       // Tor 1P (Ten sam tor wewn. co 1L)
        
        led_data[27] = (signals[3] == 2'h1); 
        led_data[28] = (signals[3] == 2'h0);
        led_data[29] = track_taken[3];       // Tor 2P (Ten sam tor wewn. co 2L)
        
        led_data[30] = (signals[5] == 2'h1); 
        led_data[31] = (signals[5] == 2'h0);
        led_data[32] = track_taken[4];       // Tor 3P
        
        led_data[33] = (signals[7] == 2'h1); 
        led_data[34] = (signals[7] == 2'h0);
        led_data[35] = track_taken[5];       // Tor 4P
        
        led_data[36] = (signals[9] == 2'h1); 
        led_data[37] = (signals[9] == 2'h0);
        led_data[38] = track_taken[6];       // Tor 5P
        
        led_data[39] = (signals[11] == 2'h1); 
        led_data[40] = (signals[11] == 2'h0);
        led_data[41] = track_taken[7];       // Tor 6P

        // 4. TORY WJAZDOWE PRAWE (Q42 - Q47)
        led_data[42] = (signals[14] == 2'h1); 
        led_data[43] = (signals[14] == 2'h0); 
        led_data[44] = track_taken[8];       // Zajętość szlaku P1
        
        led_data[45] = (signals[15] == 2'h1); 
        led_data[46] = (signals[15] == 2'h0); 
        led_data[47] = track_taken[9];       // Zajętość szlaku P2
    end
endmodule
