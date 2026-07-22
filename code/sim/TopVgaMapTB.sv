`timescale 1ns / 1ps

module TopVgaMapTB();
    logic clk;
    logic rst;

    // Wejścia  fizyczne manipulatory i mysz
    logic [11:0] X_POS = 12'd100;
    logic [11:0] Y_POS = 12'd100;
    
    // Sygnały sterujące zwrotnicami i trasami 
    logic [2:0] route_L1 = 3'd3;  // trasa lewa 1 (np. na tor 3)
    logic [2:0] route_L2 = 3'd4;  // trasa lewa 2 (np. na tor 4)
    logic [2:0] route_P1 = 3'd3;  // Przykładowa trasa prawa 1
    logic [2:0] route_P2 = 3'd4;  // Przykładowa trasa prawa 2
    logic select_L_upper = 1'b1;  // Wybór górnego przebiegu lewej głowicy
    logic select_P_upper = 1'b1;  // Wybór górnego przebiegu prawej głowicy

    logic [1:0] signals [0:15]; // Tablica sygnałów dla 16 semaforów

    // Wyjścia VGA
    logic vs, hs;
    logic [3:0] r, g, b;


    TopVga uut (
        .clk(clk),
        .rst(rst),
        .X_POS(X_POS),
        .Y_POS(Y_POS),
        .route_L1(route_L1),
        .route_L2(route_L2),
        .route_P1(route_P1),
        .route_P2(route_P2),
        .select_L_upper(select_L_upper),
        .select_P_upper(select_P_upper),
        .signals(signals),
        .vs(vs),
        .hs(hs),
        .r(r),
        .g(g),
        .b(b)
    );

    // zegara 40 MHz 
    always #12.5 clk = ~clk;

    integer file;

    initial begin
        clk = 0;
        rst = 1;
        
        // tablicy semaforów (2'h2 = zielone światło)
        foreach(signals[i]) signals[i] = 2'h2;

        #100;
        rst = 0;

        file = $fopen("symulacja_stacji.ppm", "w");
        
        $fwrite(file, "P3\n800 600\n15\n"); 

        @(negedge vs);
        @(posedge vs);

        $display("Rozpoczeto generowanie klatki obrazu. Prosze czekac...");

        
        while (1) begin
            @(posedge clk);
            
    
            if (uut.u_vga_timing.vcount == 600 && uut.u_vga_timing.hcount == 0) begin
                break;
            end


            if (!uut.u_vga_timing.vblnk && !uut.u_vga_timing.hblnk) begin
                $fwrite(file, "%0d %0d %0d\n", r, g, b);
            end
        end

        $fclose(file);
        $display("ZAKONCZONO! Obraz zapisany do pliku: symulacja_stacji.ppm");
        $finish;
    end
endmodule