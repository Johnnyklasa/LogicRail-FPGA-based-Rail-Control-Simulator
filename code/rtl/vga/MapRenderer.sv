module MapRenderer(
    input logic clk,
    input logic rst,
    input logic [2:0] route_L1, route_L2, route_P1, route_P2,
    input logic select_L_upper, select_P_upper,
    input logic [1:0] signals [0:15],
    vga_if.in  vga_in,
    vga_if.out vga_out
);
    vga_if vga_platforms();
    vga_if vga_internal_tracks();
    vga_if vga_entry_tracks();
    vga_if vga_turnouts();

    DrawPlatforms u_DrawPlatforms (
        .clk(clk), .rst(rst),
        .vga_in(vga_in),
        .vga_out(vga_platforms)
    );

    DrawInternalTracks u_DrawInternalTracks (
        .clk(clk), .rst(rst),
        .vga_in(vga_platforms),
        .vga_out(vga_internal_tracks)
    );

    DrawEntryTracks u_DrawEntryTracks (
        .clk(clk), .rst(rst),
        .vga_in(vga_internal_tracks),
        .vga_out(vga_entry_tracks)
    );

    DrawTurnouts u_DrawTurnouts (
        .clk(clk), .rst(rst),
        .route_L1(route_L1), .route_L2(route_L2),
        .route_P1(route_P1), .route_P2(route_P2),
        .select_L_upper(select_L_upper), .select_P_upper(select_P_upper),
        .vga_in(vga_entry_tracks),
        .vga_out(vga_turnouts)
    );
    
    
    DrawSemafor u_DrawSemafor (
        .clk(clk), .rst(rst),
        .signals(signals), 
        .vga_in(vga_turnouts),
        .vga_out(vga_out)
    );
endmodule