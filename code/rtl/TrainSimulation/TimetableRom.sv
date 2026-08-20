module TimetableRom (
    input  logic [7:0] char_xy,
    output logic [7:0] char_code
);
    import Timetable_pkg::*; 

    logic [7:0] memory [0:255];

   
    function automatic logic [7:0] to_ascii(int val);
        return 8'h30 + (val % 10);
    endfunction

    localparam logic [0:31][7:0] HEADER1 = "--- ROZKLAD JAZDY ---           ";
    localparam logic [0:31][7:0] HEADER2 = "ID   PRZ.     ODJ.              ";

    initial begin
       
        
        for (int i = 0; i < 256; i++) memory[i] = 8'h20;

        for (int i = 0; i < 32; i++) begin
            memory[i]      = HEADER1[i];
            memory[32 + i] = HEADER2[i];
        end
        
      
       
        for (int i = 0; i < SCHEDULE_SIZE; i++) begin
            int row = (i + 2) * 32; 

          
            memory[row + 0] = to_ascii(Sched_TrainID[i] / 100);
            memory[row + 1] = to_ascii((Sched_TrainID[i] / 10) % 10);
            memory[row + 2] = to_ascii(Sched_TrainID[i] % 10);

          
            memory[row + 5] = to_ascii((Sched_Arrival[i] / 60) / 10);
            memory[row + 6] = to_ascii((Sched_Arrival[i] / 60) % 10);
            memory[row + 7] = ":";
            memory[row + 8] = to_ascii((Sched_Arrival[i] % 60) / 10);
            memory[row + 9] = to_ascii((Sched_Arrival[i] % 60) % 10);

          
            memory[row + 14] = to_ascii((Sched_Departure[i] / 60) / 10);
            memory[row + 15] = to_ascii((Sched_Departure[i] / 60) % 10);
            memory[row + 16] = ":";
            memory[row + 17] = to_ascii((Sched_Departure[i] % 60) / 10);
            memory[row + 18] = to_ascii((Sched_Departure[i] % 60) % 10);
        end
    end

  
    always_comb char_code = memory[char_xy];
    
endmodule
