//Autor:Karol Sitko
`timescale 1ns / 1ps

module tb_TrainGenerator();

    
    logic clk;
    logic rst_n;
    logic [4:0] hours;
    logic [5:0] minutes;
    logic minute_tick;
    logic train_tick;
    logic approach_track_taken;

    logic train_waiting;
    logic [7:0] TrainID;

    
    TrainGenerator uut (
        .clk(clk),
        .rst_n(rst_n),
        .hours(hours),
        .minutes(minutes),
        .minute_tick(minute_tick),
        .train_tick(train_tick),
        .approach_track_taken(approach_track_taken),
        .train_waiting(train_waiting),
        .TrainID(TrainID)
    );

 
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

   
    task advance_time();
        
        @(negedge clk); 
        
        
        if (minutes == 59) begin
            minutes = 0;
            hours = hours + 1;
        end else begin
            minutes = minutes + 1;
        end
        
        
        minute_tick = 1'b1;
        @(negedge clk);
        minute_tick = 1'b0;
        
        
        #100;
    endtask

    
    initial begin
        $display("=== START SYMULACJI ===");
        
        // Stan początkowy
        rst_n = 0;
        hours = 0;
        minutes = 0;
        minute_tick = 0;
        train_tick = 0;
        approach_track_taken = 0; 
        
        
        #100;
        rst_n = 1;
        #50;
        
        
        $display("[CZAS %0d:%0d] Czekam na pociag...", hours, minutes);
        advance_time();
        
        
        $display("[CZAS %0d:%0d] Zmiana godziny. Sprawdzam rozklad...", hours, minutes);
        advance_time();
        
       
        #30;
        
       
        if (TrainID == 8'd101 && train_waiting == 1'b1) begin
            $display("-> SUKCES: Wykryto pociag ID: 101 (0x%h) z rozkladu!", TrainID);
        end else begin
            $display("-> BLAD: Oczekiwano ID 101, otrzymano ID: %0d | train_waiting: %b", TrainID, train_waiting);
            $stop; // Zatrzymuje symulację w razie błędu
        end

        
        #50;
        $display("[RUCH] Tor zglasza gotowosc. Generuje pik train_tick...");
        
        
        @(negedge clk);
        train_tick = 1'b1;
        @(negedge clk);
        train_tick = 1'b0;
        
        #30;
        
        
        if (TrainID == 8'd0 && train_waiting == 1'b0) begin
            $display("-> SUKCES: Pociag opuscil generator. Zmienne wyczyszczone.");
        end else begin
            $display("-> BLAD: Generator nie chcial oddac pociagu!");
        end
        
        #100;
        $display("=== KONIEC SYMULACJI - WYNIK POZYTYWNY ===");
        $finish;
    end

endmodule
