module top_vga_basys3 (
    input  wire clk,
    input  wire btnC,
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

    // --- Lokalne sygnały ---
    wire clk100MHz, clk65MHz;
    wire locked;
    wire pclk;
    wire pclk_mirror;

    (* KEEP = "TRUE" *)
    (* ASYNC_REG = "TRUE" *)
    
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
    
    logic [2:0] dummy_route = 3'b000;
   
    TopVga u_top_vga (
        .clk(pclk),  
        .clk100MHz(clk100MHz),              
        .rst_n(~btnC),  // Przycisk na Basys3 podaje 1, więc negujemy go dla rst_n
        
        .route_L1(dummy_route),
        .route_L2(dummy_route),
        .route_P1(dummy_route),
        .route_P2(dummy_route),
        .select_L_upper(1'b0),
        .select_P_upper(1'b0),
        
        .r(vgaRed),
        .g(vgaGreen),
        .b(vgaBlue),
        .hs(Hsync),
        .vs(Vsync),
        .PS2Clk(PS2Clk),
        .PS2Data(PS2Data)
    );

endmodule
