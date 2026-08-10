package Map_pkg;

localparam int SEMAFOR_NUMBER = 16;
localparam int TRACK_NUMBER = 6;
    
    // Tablica pozycji X dla 16 semaforów
    localparam logic [11:0] SemaforXPos [0:SEMAFOR_NUMBER-1] = '{
        12'd100, 12'd200, 12'd300, 12'd400, 12'd100, 12'd200, 12'd300, 12'd400,
        12'd500, 12'd600, 12'd700, 12'd800, 12'd500, 12'd600, 12'd700, 12'd800
    };
    
    // Tablica pozycji Y dla 16 semaforów
    localparam logic [11:0] SemaforYPos [0:SEMAFOR_NUMBER-1] = '{
        12'd50,  12'd50,  12'd50,  12'd50,  12'd150, 12'd150, 12'd150, 12'd150,
        12'd50,  12'd50,  12'd50,  12'd50,  12'd150, 12'd150, 12'd150, 12'd150
    };

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

    // --- TABLICE POZYCJI Y DLA TORÓW ---

    
    localparam logic [11:0] StationTrackY [0:5] = '{
        12'(Y_TOR1), 12'(Y_TOR2), 12'(Y_TOR3), 
        12'(Y_TOR4), 12'(Y_TOR5), 12'(Y_TOR6)
    };

  
    localparam logic [11:0] RouteTrackY [0:3] = '{
        12'(Y_TOR3), 12'(Y_TOR4), 
        12'(Y_TOR3), 12'(Y_TOR4)
    };
endpackage
