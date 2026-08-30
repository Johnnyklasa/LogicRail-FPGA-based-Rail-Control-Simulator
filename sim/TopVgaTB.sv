`timescale 1ns / 1ps

module tb_TopVga();

    
    logic clk;
    logic clk100MHz;
    logic rst_n;
   
    logic vs, hs;
    logic [3:0] r, g, b;
    wire PS2Data, PS2Clk;
    
   
    TopVga TopVga_dut (
        .clk(clk),
        .clk100MHz(clk100MHz),
        .rst_n(rst_n),
        .vs(vs),
        .hs(hs),
        .r(r),
        .g(g),
        .b(b),
        .PS2Data(PS2Data),
        .PS2Clk(PS2Clk)
    );
   
    initial begin
        clk100MHz = 0;
        forever #5 clk100MHz = ~clk100MHz; 
    end
  
    initial begin
        clk = 0;
        forever #20 clk = ~clk; 
    end
  
    initial begin
        #5000000000; 
        $display("AWARYJNY KONIEC - TIMEOUT! (Za dlugo to trwalo)");
        $finish;
    end
    

    initial begin
        $display("=== START SYMULACJI SRK ===");
        
        // --- KROK 1: Inicjalizacja ---
        rst_n = 0;
        #100;
        rst_n = 1;
        $display("[%0t ns] System wybudzony. Czekam na pociag wg rozkladu...", $time);
        
        // --- KROK 2: Oczekiwanie na pociąg na Torze 0 (Wjazd) ---
        wait(uut.track_train_id[0] != 8'd0);
        $display("[%0t ns] SUKCES: Pociag ID: %h dojechal do Semafora 0!", $time, uut.track_train_id[0]);
        $display("[%0t ns] Stan Semafora 0: %b (00=Czerwony, 01=Zielony)", $time, uut.signals[0]);
        
       
        #500000; 

        // --- KROK 3: Ustawienie przebiegu na Tor 5 (position = 3'd4) ---
       $display("[%0t ns] DYSPOZYTOR: Przestawiam rozjazd wjazdowy L1 na Tor 5...", $time);
        force uut.u_Turnout_L1.state = 3'd4; // Zmieniamy wewnętrzny REJESTR
        #10; 
        release uut.u_Turnout_L1.state;
        #500000; 
       
        // --- KROK 4: Otwarcie Semafora Wjazdowego (0) ---
        $display("[%0t ns] DYSPOZYTOR: Zapalam ZIELONE na Semaforze 0!", $time);
        force uut.req_sem[0] = 1'b1;
        #10; 
        release uut.req_sem[0];

        // --- KROK 5: Przejazd na Peron ---
        $display("[%0t ns] Czekam az pociag minie rozjazd i dotrze na Tojjojojojojor 5...", $time);
        wait(uut.track_train_id[5] != 8'd0);
        $display("[%0t ns] SUKCES: Pociag wjechal w perony na Tor 5!", $time);
        
       
        #1000000;

        // --- KROK 6: Wyprawienie pociągu (Rozjazd P1 -> Tor 8) ---
       $display("[%0t ns] DYSPOZYTOR: Przestawiam rozjazd wyjazdowy P1 na Tor 5...", $time);
            force uut.u_Turnout_P1.state = 3'd4;
        #10; 
        release uut.u_Turnout_P1.state;

        #50000;



        // --- KROK 8: Opuszczenie stacji ---
        $display("[%0t ns] DYSPOZYTOR: Zapalam ZIELONE na Semaforze wyjazdowym 8!", $time);
        force uut.req_sem[8] = 1'b1;
        #10; 
        release uut.req_sem[8];

        #500000;
        $display("=== KONIEC SCENARIUSZA: Test Przebiegu Zakonczony Pielgrzymko! ===");
        $finish;
    end

endmodule
