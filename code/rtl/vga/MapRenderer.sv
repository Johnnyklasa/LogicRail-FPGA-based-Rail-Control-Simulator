module MapRenderer(
    input logic clk,
    input logic rst_n,
    input logic [2:0] route_L1, route_L2, route_P1, route_P2,
    input logic select_L_upper, select_P_upper,
    input logic [1:0] signals [0:15],
    input logic [9:0] isTaken,
    input logic [3:0] turnout_taken,
    input logic [5:0] minutes,
    input logic [4:0] hours,
    vga_if.in  vga_in,
    vga_if.out vga_out
);
    
    vga_if vga_platforms();
    vga_if vga_internal_tracks();
    vga_if vga_entry_tracks();
    vga_if vga_turnouts();
    vga_if vga_semafor();

    DrawPlatforms u_DrawPlatforms (
        .clk(clk), .rst_n(rst_n),
        .vga_in(vga_in),
        .vga_out(vga_platforms)
    );

    DrawInternalTracks u_DrawInternalTracks (
        .clk(clk), .rst_n(rst_n),
        .isTaken(isTaken),
        .vga_in(vga_platforms),
        .vga_out(vga_internal_tracks)
    );

    DrawEntryTracks u_DrawEntryTracks (
        .clk(clk), .rst_n(rst_n),
        .isTaken(isTaken),
        .vga_in(vga_internal_tracks),
        .vga_out(vga_entry_tracks)
    );

    DrawTurnouts u_DrawTurnouts (
        .clk(clk), .rst_n(rst_n),
        .route_L1(route_L1), .route_L2(route_L2),
        .route_P1(route_P1), .route_P2(route_P2),
        .select_L_upper(select_L_upper), .select_P_upper(select_P_upper),
        .turnout_taken(turnout_taken),
        .vga_in(vga_entry_tracks),
        .vga_out(vga_turnouts)
    );
    
    DrawSemafor u_DrawSemafor (
        .clk(clk), .rst_n(rst_n),
        .signals(signals), 
        .vga_in(vga_turnouts),
        .vga_out(vga_semafor)
    );


    DrawClock u_DrawClock(
        .clk(clk), .rst_n(rst_n),
        .minutes(minutes), .hours(hours),
        .vga_in(vga_semafor),
        .vga_out(vga_out)
    );
endmodule
