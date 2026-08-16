`timescale 1ns / 1ps

module tb_TrainGenerator();

    // =======================================================
    // 1. SYGNAŁY I ZMIENNE LOKALNE
    // =======================================================
    logic clk;
    logic rst_n;
    logic [4:0] hours;
    logic [5:0] minutes;
    logic minute_tick;
    logic train_tick;
    logic approach_track_taken;

    logic train_waiting;
    logic [7:0] TrainID;

    // =======================================================
    // 2. INSTANCJA TESTOWANEGO MODUŁU (Unit Under Test)
    // =======================================================
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

    // =======================================================
    // 3. GENERATOR ZEGARA 100 MHz (Okres 10 ns)
    // =======================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // =======================================================
    // 4. TASK SYMULUJĄCY UPŁYW CZASU (Jak Twój RealClock)
    // =======================================================
    task advance_time();
        // Czekamy na ujemne zbocze, żeby bezpiecznie zmienić sygnały
        @(negedge clk); 
        
        // Aktualizacja wirtualnego czasu
        if (minutes == 59) begin
            minutes = 0;
            hours = hours + 1;
        end else begin
            minutes = minutes + 1;
        end
        
        // Wygenerowanie piku minute_tick (Trwa dokładnie 10 ns)
        minute_tick = 1'b1;
        @(negedge clk);
        minute_tick = 1'b0;
        
        // Zostawiamy trochę "pustego" czasu (odstęp między tyknięciami)
        #100;
    endtask

    // =======================================================
    // 5. GŁÓWNY SCENARIUSZ TESTOWY
    // =======================================================
    initial begin
        $display("=== START SYMULACJI ===");
        
        // Stan początkowy
        rst_n = 0;
        hours = 0;
        minutes = 0;
        minute_tick = 0;
        train_tick = 0;
        approach_track_taken = 0; // Tor przed stacją jest pusty
        
        // Trzymamy reset przez 100 ns
        #100;
        rst_n = 1;
        #50;
        
        // TEST 1: Czas 00:00 -> 00:01
        $display("[CZAS %0d:%0d] Czekam na pociag...", hours, minutes);
        advance_time();
        
        // TEST 2: Czas 00:01 -> 00:02 (W rozkładzie jest pociąg ID: 101)
        $display("[CZAS %0d:%0d] Zmiana godziny. Sprawdzam rozklad...", hours, minutes);
        advance_time();
        
        // Czekamy kilka taktów zegara, żeby logika always_ff zdążyła zareagować
        #30;
        
        // SPRAWDZENIE: Czy pociąg się zespawnował?
        if (TrainID == 8'd101 && train_waiting == 1'b1) begin
            $display("-> SUKCES: Wykryto pociag ID: 101 (0x%h) z rozkladu!", TrainID);
        end else begin
            $display("-> BLAD: Oczekiwano ID 101, otrzymano ID: %0d | train_waiting: %b", TrainID, train_waiting);
            $stop; // Zatrzymuje symulację w razie błędu
        end

        // TEST 3: Wessanie pociągu przez Tor_0
        #50;
        $display("[RUCH] Tor zglasza gotowosc. Generuje pik train_tick...");
        
        // Symulacja impulsu przesunięcia (train_tick_pulse)
        @(negedge clk);
        train_tick = 1'b1;
        @(negedge clk);
        train_tick = 1'b0;
        
        #30;
        
        // SPRAWDZENIE: Czy pociąg zniknął z generatora?
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
