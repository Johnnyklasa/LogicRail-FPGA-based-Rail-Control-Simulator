
//Autor:Karol Sitko
module top_vga_basys3 (
    input  wire clk,
    input  wire btnC,          
   
    input  wire uart_rx,       
    output wire uart_tx,      
    
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    
    output wire JA1,
    
    inout  wire PS2Clk,
    inout  wire PS2Data
);

    timeunit 1ns;
    timeprecision 1ps;

    wire clk100MHz, clk65MHz;
    wire locked;
    wire pclk;
    wire pclk_mirror;
    wire rst_n = ~btnC;

    assign JA1 = pclk_mirror;
    assign pclk = clk65MHz;

    clk_wiz_0 u_clk_wiz_0 (
        .clk(clk),
        .clk100MHz(clk100MHz),
        .clk65MHz(clk65MHz),
        .locked(locked)
    );

    ODDR pclk_oddr (
        .Q(pclk_mirror),
        .C(pclk),
        .CE(1'b1),
        .D1(1'b1),
        .D2(1'b0),
        .R(1'b0),
        .S(1'b0)
    );

    wire [7:0] rx_byte;
    wire       rx_ready;
    wire [7:0] tx_byte;
    wire       tx_start;
    wire       tx_busy;

    UartRx #(
        .CLK_FREQ(65_000_000),
        .BAUD_RATE(115200)
    ) u_UartRx (
        .clk(pclk),
        .rst_n(rst_n),
        .rx(uart_rx),
        .rx_data(rx_byte),
        .rx_ready(rx_ready)
    );
    

    UartTx #(
        .CLK_FREQ(65_000_000),
        .BAUD_RATE(115200)
    ) u_UartTx (
        .clk(pclk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_data(tx_byte),
        .tx(uart_tx),
        .tx_busy(tx_busy)
    );

    wire       sync_en;
    wire [4:0] sync_hours;
    wire [5:0] sync_minutes;
    wire [7:0] rx_train_id;
    wire       rx_train_req;
    
    wire [4:0] current_hours;
    wire [5:0] current_minutes;
    wire       minute_tick;

    UartController u_UartController (
        .clk(pclk),
        .rst_n(rst_n),
        .rx_data(rx_byte),
        .rx_ready(rx_ready),
        .sync_en_out(sync_en),
        .sync_hours_out(sync_hours),
        .sync_minutes_out(sync_minutes),
        .rx_train_id(rx_train_id),
        .rx_train_req(rx_train_req),
        .tx_start(tx_start),
        .tx_data(tx_byte),
        .tx_busy(tx_busy),
        .send_time_req(1'b0),
        .current_hours(current_hours),
        .current_minutes(current_minutes),
        .send_train_req(top_send_train_req),
        .tx_train_id_in(top_tx_train_id)
    );

    RealClock #(
        .CLK_FREQ(65_000_000)
    ) u_RealClock (
        .clk(pclk),
        .rst_n(rst_n),
        .sync_en(sync_en),
        .sync_hours(sync_hours),
        .sync_minutes(sync_minutes),
        .hours(current_hours),
        .minutes(current_minutes),
        .minute_tick(minute_tick)
    );

    wire       train_waiting;
    wire [7:0] TrainID;

    wire top_send_train_req;
    wire [7:0] top_tx_train_id;

    TopVga u_top_vga (
        .clk(pclk),
        .clk100MHz(clk100MHz),
        .rst_n(rst_n),
        .r(vgaRed),
        .g(vgaGreen),
        .b(vgaBlue),
        .send_train_req_out(top_send_train_req),
        .tx_train_id_out(top_tx_train_id),
        .rx_train_id_in(rx_train_id),
        .rx_train_req_in(rx_train_req),
        .tx_busy_in(tx_busy),
        .hours(current_hours),
        .minutes(current_minutes),
        .minute_tick(minute_tick),
        .hs(Hsync),
        .vs(Vsync),
        .PS2Clk(PS2Clk),
        .PS2Data(PS2Data)
    );

endmodule
