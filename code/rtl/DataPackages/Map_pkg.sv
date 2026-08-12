package Map_pkg;

    localparam int SEMAFOR_NUMBER = 16;
    localparam int TRACK_NUMBER = 6;
    localparam int TURNOUT_NUMBER = 4;

    //STATION PARAMETERS
    localparam int TOR_WIDTH       = 240;
    localparam int TOR_HEIGHT      = 8;
    localparam int PERON_WIDTH     = 220;
    localparam int PERON_HEIGHT    = 20;
    localparam int TOR_SZLAK_WIDTH = 80;
    localparam int SEMAFOR_WIDTH   = 10;
    localparam int SEMAFOR_HEIGHT  = 20;
    localparam int TURNOUT_WIDTH   = 20;
    localparam int TURNOUT_HEIGHT  = 20;

    //X COORIDINATES
    localparam int START_X_LEWY_SZLAK  = 0;
    localparam int START_X_STACJA      = 280;
    localparam int START_X_PERONY      = START_X_STACJA + 10;
    localparam int START_X_PRAWY_SZLAK = 800 - TOR_SZLAK_WIDTH;

    //Y COORDINATES
    localparam int BASE_Y = 186; 
    localparam int OFFSET_TOR_PERON = 18;
    localparam int OFFSET_PERON_TOR = 30;
    localparam int OFFSET_GRUPA     = 38;

    localparam int Y_TOR1   = BASE_Y;
    localparam int Y_PERON1 = Y_TOR1 + OFFSET_TOR_PERON;
    localparam int Y_TOR2   = Y_PERON1 + OFFSET_PERON_TOR;

    localparam int Y_TOR3   = Y_TOR2 + OFFSET_GRUPA;
    localparam int Y_PERON2 = Y_TOR3 + OFFSET_TOR_PERON;
    localparam int Y_TOR4   = Y_PERON2 + OFFSET_PERON_TOR;

    localparam int Y_TOR5   = Y_TOR4 + OFFSET_GRUPA;
    localparam int Y_PERON3 = Y_TOR5 + OFFSET_TOR_PERON;
    localparam int Y_TOR6   = Y_PERON3 + OFFSET_PERON_TOR;

    localparam int Y_SZLAK_L1 = Y_TOR3;
    localparam int Y_SZLAK_L2 = Y_TOR4;
    localparam int Y_SZLAK_P1 = Y_TOR3;
    localparam int Y_SZLAK_P2 = Y_TOR4;

    // --- TABLICE POZYCJI X i Y DLA ROZJAZDÓW (TURNOUT) ---
    // (Rozjazdy pomiędzy szlakami wjazdowymi a początkiem stacji)
    localparam logic [11:0] TurnoutXPos [0:TURNOUT_NUMBER-1] = '{
        12'(START_X_LEWY_SZLAK + TOR_SZLAK_WIDTH + 40), // Rozjazd 0 L
        12'(START_X_LEWY_SZLAK + TOR_SZLAK_WIDTH + 40), // Rozjazd 1 L
        12'(START_X_PRAWY_SZLAK - 60),                  // Rozjazd 2 P
        12'(START_X_PRAWY_SZLAK - 60)                   // Rozjazd 3 P
    };

    localparam logic [11:0] TurnoutYPos [0:TURNOUT_NUMBER-1] = '{
        12'(Y_TOR3), 12'(Y_TOR4), 
        12'(Y_TOR3), 12'(Y_TOR4)
    };

    // --- TABLICE POZYCJI X i Y DLA SEMAFORÓW ---
    // (Ustawione obok torów: 15px nad torem. 12 przy stacji, 4 przy wjazdach)
    localparam logic [11:0] SemaforXPos [0:SEMAFOR_NUMBER-1] = '{
        12'(START_X_LEWY_SZLAK + TOR_SZLAK_WIDTH - 20), // 0: Wjazd L1
        12'(START_X_LEWY_SZLAK + TOR_SZLAK_WIDTH - 20), // 1: Wjazd L2
        12'(START_X_STACJA + 10),                       // 2: Tor 1 Lewy
        12'(START_X_STACJA + 10),                       // 3: Tor 2 Lewy
        12'(START_X_STACJA + 10),                       // 4: Tor 3 Lewy
        12'(START_X_STACJA + 10),                       // 5: Tor 4 Lewy
        12'(START_X_STACJA + 10),                       // 6: Tor 5 Lewy
        12'(START_X_STACJA + 10),                       // 7: Tor 6 Lewy
        12'(START_X_STACJA + TOR_WIDTH - 20),           // 8: Tor 1 Prawy
        12'(START_X_STACJA + TOR_WIDTH - 20),           // 9: Tor 2 Prawy
        12'(START_X_STACJA + TOR_WIDTH - 20),           // 10: Tor 3 Prawy
        12'(START_X_STACJA + TOR_WIDTH - 20),           // 11: Tor 4 Prawy
        12'(START_X_STACJA + TOR_WIDTH - 20),           // 12: Tor 5 Prawy
        12'(START_X_STACJA + TOR_WIDTH - 20),           // 13: Tor 6 Prawy
        12'(START_X_PRAWY_SZLAK + 10),                  // 14: Wjazd P1
        12'(START_X_PRAWY_SZLAK + 10)                   // 15: Wjazd P2
    };

    localparam logic [11:0] SemaforYPos [0:SEMAFOR_NUMBER-1] = '{
        12'(Y_SZLAK_L1 - 15), 12'(Y_SZLAK_L2 - 15),
        12'(Y_TOR1 - 15), 12'(Y_TOR2 - 15), 12'(Y_TOR3 - 15), 12'(Y_TOR4 - 15), 12'(Y_TOR5 - 15), 12'(Y_TOR6 - 15),
        12'(Y_TOR1 - 15), 12'(Y_TOR2 - 15), 12'(Y_TOR3 - 15), 12'(Y_TOR4 - 15), 12'(Y_TOR5 - 15), 12'(Y_TOR6 - 15),
        12'(Y_SZLAK_P1 - 15), 12'(Y_SZLAK_P2 - 15)
    };

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
