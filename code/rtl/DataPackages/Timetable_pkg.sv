package Timetable_pkg;

    localparam int SCHEDULE_SIZE = 3; 

    // TABLICE RÓWNOLEGŁE (Bulletproof dla Vivado XSim)
    // Indeks 0 = Pociąg 1, Indeks 1 = Pociąg 2, Indeks 2 = Pociąg 3

    localparam logic [7:0] Sched_TrainID [0:2] = '{
        8'd101, 
        8'd115, 
        8'd202
    };

    localparam logic [11:0] Sched_Arrival [0:2] = '{
        12'd20, 
        12'd300, 
        12'd400
    };

    localparam logic [11:0] Sched_Departure [0:2] = '{
        12'd440, 
        12'd490, 
        12'd615
    };

endpackage






