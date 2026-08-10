module LedMapper (
    input  logic [1:0] signals [0:15],
    output logic [47:0] led_data
);
    always_comb begin
        led_data = 48'b0;

        // 1. TORY WJAZDOWE LEWE (Q0 - Q5)
        led_data[0] = (signals[12] == 2'h2); // Szlak L1 zielony
        led_data[1] = (signals[12] == 2'h1); // Szlak L1 czerwony
        led_data[2] = (signals[12] == 2'h3); // Szlak L1 żółty
        led_data[3] = (signals[13] == 2'h2); // Szlak L2 zielony
        led_data[4] = (signals[13] == 2'h1); // Szlak L2 czerwony
        led_data[5] = (signals[13] == 2'h3); // Szlak L2 żółty

        // 2. LEWA STRONA STACJI (Q6 - Q23)
        led_data[6] = (signals[0] == 2'h2);  // Tor 1L zielony
        led_data[7] = (signals[0] == 2'h1);  // Tor 1L czerwony
        led_data[8] = (signals[0] == 2'h3);  // Tor 1L żółty
        
        led_data[9]  = (signals[2] == 2'h2); // Tor 2L
        led_data[10] = (signals[2] == 2'h1);
        led_data[11] = (signals[2] == 2'h3);
        
        led_data[12] = (signals[4] == 2'h2); // Tor 3L
        led_data[13] = (signals[4] == 2'h1);
        led_data[14] = (signals[4] == 2'h3);
        
        led_data[15] = (signals[6] == 2'h2); // Tor 4L
        led_data[16] = (signals[6] == 2'h1);
        led_data[17] = (signals[6] == 2'h3);
        
        led_data[18] = (signals[8] == 2'h2); // Tor 5L
        led_data[19] = (signals[8] == 2'h1);
        led_data[20] = (signals[8] == 2'h3);
        
        led_data[21] = (signals[10] == 2'h2); // Tor 6L
        led_data[22] = (signals[10] == 2'h1);
        led_data[23] = (signals[10] == 2'h3);

        // 3. PRAWA STRONA STACJI (Q24 - Q41)
        led_data[24] = (signals[1] == 2'h2); // Tor 1P
        led_data[25] = (signals[1] == 2'h1);
        led_data[26] = (signals[1] == 2'h3);
        
        led_data[27] = (signals[3] == 2'h2); // Tor 2P
        led_data[28] = (signals[3] == 2'h1);
        led_data[29] = (signals[3] == 2'h3);
        
        led_data[30] = (signals[5] == 2'h2); // Tor 3P
        led_data[31] = (signals[5] == 2'h1);
        led_data[32] = (signals[5] == 2'h3);
        
        led_data[33] = (signals[7] == 2'h2); // Tor 4P
        led_data[34] = (signals[7] == 2'h1);
        led_data[35] = (signals[7] == 2'h3);
        
        led_data[36] = (signals[9] == 2'h2); // Tor 5P
        led_data[37] = (signals[9] == 2'h1);
        led_data[38] = (signals[9] == 2'h3);
        
        led_data[39] = (signals[11] == 2'h2); // Tor 6P
        led_data[40] = (signals[11] == 2'h1);
        led_data[41] = (signals[11] == 2'h3);

        // 4. TORY WJAZDOWE PRAWE (Q42 - Q47)
        led_data[42] = (signals[14] == 2'h2); // Szlak P1 zielony
        led_data[43] = (signals[14] == 2'h1); // Szlak P1 czerwony
        led_data[44] = (signals[14] == 2'h3); // Szlak P1 żółty
        led_data[45] = (signals[15] == 2'h2); // Szlak P2 zielony
        led_data[46] = (signals[15] == 2'h1); // Szlak P2 czerwony
        led_data[47] = (signals[15] == 2'h3); // Szlak P2 żółty
    end
endmodule