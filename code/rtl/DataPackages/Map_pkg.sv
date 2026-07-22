package Map_pkg;
    //1. PARAMETRY SEMAFORA 
    localparam Semafor1XPos = 250;
    localparam Semafor1YPos = 250;

    //2. WYMIARY BAZOWE STACJI 
    localparam TOR_WIDTH       = 240; 
    localparam TOR_HEIGHT      = 8;   
    localparam PERON_WIDTH     = 220; 
    localparam PERON_HEIGHT    = 20;  
    localparam TOR_SZLAK_WIDTH = 80;  

    //3. WSPÓŁRZĘDNE X 
    localparam START_X_LEWY_SZLAK  = 0; 
    localparam START_X_STACJA      = 280; 
    localparam START_X_PERONY      = START_X_STACJA + 10; 
    localparam START_X_PRAWY_SZLAK = 800 - TOR_SZLAK_WIDTH; 

    //4. WSPÓŁRZĘDNE Y
    localparam BASE_Y = 186; // punkt startowy układu (Tor 1)
    localparam OFFSET_TOR_PERON = 18;
    localparam OFFSET_PERON_TOR = 30;
    localparam OFFSET_GRUPA     = 38; 

    localparam Y_TOR1   = BASE_Y;
    localparam Y_PERON1 = Y_TOR1 + OFFSET_TOR_PERON;
    localparam Y_TOR2   = Y_PERON1 + OFFSET_PERON_TOR;
    
    localparam Y_TOR3   = Y_TOR2 + OFFSET_GRUPA;
    localparam Y_PERON2 = Y_TOR3 + OFFSET_TOR_PERON;
    localparam Y_TOR4   = Y_PERON2 + OFFSET_PERON_TOR;
    
    localparam Y_TOR5   = Y_TOR4 + OFFSET_GRUPA;
    localparam Y_PERON3 = Y_TOR5 + OFFSET_TOR_PERON;
    localparam Y_TOR6   = Y_PERON3 + OFFSET_PERON_TOR;

    localparam Y_SZLAK_L1 = Y_TOR3;
    localparam Y_SZLAK_L2 = Y_TOR4;
    localparam Y_SZLAK_P1 = Y_TOR3;
    localparam Y_SZLAK_P2 = Y_TOR4;
endpackage