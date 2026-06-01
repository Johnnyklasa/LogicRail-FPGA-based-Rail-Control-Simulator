package Map_pkg;
    
    // --- SEMAPHORE CONSTANTS ---
    localparam Semafor1XPos = 250;
    localparam Semafor1YPos = 250;

    // --- SIGNIFICANTLY REDUCED X-AXIS DIMENSIONS 
    localparam PERON_WIDTH  = 220; 
    localparam PERON_HEIGHT = 20;  
    localparam TOR_WIDTH    = 240; 
    localparam TOR_HEIGHT   = 8;   

    localparam TOR_SZLAK_WIDTH = 80; // entry tracks

    // --- HORIZONTAL COORDINATES (X) 
    localparam START_X_PERONY = 290; 
    localparam START_X_STACJA = 280; 

    localparam START_X_LEWY_SZLAK  = 0; 
    localparam START_X_PRAWY_SZLAK = 800 - TOR_SZLAK_WIDTH; 

    // --- VERTICAL COORDINATES (Y) 
    
    // UPPER SECTION (Group 1)
    localparam Y_TOR1   = 186;
    localparam Y_PERON1 = 204;
    localparam Y_TOR2   = 234;
    
    // MIDDLE SECTION (Group 2) - Centered at Y=300
    localparam Y_TOR3   = 272;
    localparam Y_PERON2 = 290;
    localparam Y_TOR4   = 320;
    
    // LOWER SECTION (Group 3)
    localparam Y_TOR5   = 358;
    localparam Y_PERON3 = 376;
    localparam Y_TOR6   = 406;

    // MAINLINE TRACK POSITIONS (Extension of tracks 3 and 4)
    localparam Y_SZLAK_L1 = Y_TOR3;
    localparam Y_SZLAK_L2 = Y_TOR4;
    localparam Y_SZLAK_P1 = Y_TOR3;
    localparam Y_SZLAK_P2 = Y_TOR4;

endpackage