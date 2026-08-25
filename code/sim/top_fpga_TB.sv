`timescale 1ns / 1ps

module top_fpga_TB();

    logic clk = 0;
    logic btnC = 1;
    logic uart_rx = 1;
    wire  uart_tx;
    wire  Vsync, Hsync;
    wire  [3:0] vgaRed, vgaGreen, vgaBlue;
    wire  JA1;
    wire  PS2Clk = 1'b1;
    wire  PS2Data = 1'b1;

    
    always #5 clk = ~clk;

    top_vga_basys3 uut (
        .clk(clk),
        .btnC(btnC),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx),
        .Vsync(Vsync),
        .Hsync(Hsync),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue),
        .JA1(JA1),
        .PS2Clk(PS2Clk),
        .PS2Data(PS2Data)
    );

    
    localparam time BIT_PERIOD = 8.68us;

    task automatic send_uart_byte(input [7:0] data);
        integer i;
        begin
            uart_rx = 1'b0; 
            #BIT_PERIOD;
            for (i = 0; i < 8; i = i + 1) begin
                uart_rx = data[i]; 
                #BIT_PERIOD;
            end
            uart_rx = 1'b1; 
            #BIT_PERIOD;
        end
    endtask

    initial begin
        $display("=== START SYMULACJI UKLADU TOP FPGA ===");
        btnC = 1'b1; 
        #200;
        btnC = 1'b0; 
        $display("[TB] Reset zwolniony. Oczekiwanie na stabilizacje zegarow...");

        #10us;

        
        $display("[TB] Wysylanie pakietu synchronizacji czasu: 18:45...");
        send_uart_byte(8'hFF); 
        send_uart_byte(8'd18);  
        send_uart_byte(8'd45);  

        #20us;
        assert (uut.current_hours == 5'd18 && uut.current_minutes == 6'd45)
            $display("[SUKCES] Zegar zsynchronizowany poprawnie: %0d:%0d", uut.current_hours, uut.current_minutes);
        else
            $error("[BLAD] Niepoprawny czas po synchronizacji!");

       
        $display("[TB] Wysylanie pociagu o ID 101...");
        send_uart_byte(8'd101);

        #20us;
        assert (uut.TrainID == 8'd101 && uut.train_waiting == 1'b1)
            $display("[SUKCES] Pociag ID %0d przyjety na podejscie stacji!", uut.TrainID);
        else
            $error("[BLAD] Pociag nie zostal zarejestrowany przez Spawner!");

        
        #50us;
        assert (Hsync !== 1'bx && Vsync !== 1'bx)
            $display("[SUKCES] Sygnaly synchronizacji VGA pracuja poprawnie.");
        else
            $error("[BLAD] Brak aktywnosci sygnałów VGA!");

        $display("=== SYMULACJA ZAKONCZONA POMYSLNIE ===");
        $finish;
    end

endmodule