package Timetable_pkg;

typedef struct packed {
    logic [7:0] TrainID;
    logic [11:0] ArrivalTime;
    logic [11:0] DepartureTime;
} Train;

    localparam Train Schedule [0:2] = '{
        '{8'd101, 12'd430, 12'd440},
        '{8'd115, 12'd480, 12'd490}, 
        '{8'd202, 12'd600, 12'd615}  
    };

endpackage







