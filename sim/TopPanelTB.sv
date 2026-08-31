`timescale 1ns / 1ps

module TopPanelTB();
    
    logic clk;
    logic btnC;
    logic [15:0] sw;
    logic [3:0] custom_sw_turnout;
    logic rx_uart;
    
    wire ds;
    wire shcp;
    wire stcp;
    wire tx_uart;

  
    TopPanel uut (
        .clk(clk),
        .btnC(btnC),
        .sw(sw),
        .custom_sw_turnout(custom_sw_turnout),
        .ds(ds),
        .shcp(shcp),
        .stcp(stcp),
        .rx_uart(rx_uart),
        .tx_uart(tx_uart)
    );

   
    localparam time CLK_PERIOD = 10ns; 
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

  
    task automatic send_uart_byte(input [7:0] data);
        localparam time BIT_PERIOD = 8.68us;
        integer i;
        begin
            rx_uart = 1'b0; // Bit Startu
            #BIT_PERIOD;
            for (i = 0; i < 8; i++) begin
                rx_uart = data[i]; // Bity Danych (LSB -> MSB)
                #BIT_PERIOD;
            end
            rx_uart = 1'b1; // Bit Stopu
            #BIT_PERIOD;
        end
    endtask


    initial begin
        $display("=== START SYMULACJI STACJI B (PANEL) ===");
        
      
        btnC = 1'b1;
        sw = 16'd0;
        custom_sw_turnout = 4'd0;
        rx_uart = 1'b1;

        #200ns;
        // Zwolnienie resetu
        btnC = 1'b0;
        
        
        #5us;
        
        $display("[TB] Wysylanie ID pociagu = 101 po interfejsie UART...");
        
        send_uart_byte(8'd101);
        
        #20us;
        
        $display("[TB] Gracz przelacza semafor i rozjazd...");
        sw[0] = 1'b1; 
        custom_sw_turnout[0] = 1'b1; 
        
        #50us;
        
        $display("=== SYMULACJA ZAKONCZONA ===");
        $finish;
    end

endmodule