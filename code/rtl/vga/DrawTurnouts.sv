module DrawTurnouts (
    input logic clk,
    input logic rst,
    input logic [2:0] route_L1, route_L2, route_P1, route_P2,
    input logic select_L_upper, select_P_upper,
    vga_if.in  vga_in,
    vga_if.out vga_out
);
    import vga_pkg::*;
    import SRK_pkg::*;
    import Map_pkg::*;

    vga_if vga_nxt();
    logic d_L1, d_L2, d_P1, d_P2;
    logic active_L1, active_L2, active_P1, active_P2;

    always_ff @(posedge clk) begin
        if (rst) begin
            vga_out.vcount <= '0; vga_out.hcount <= '0; vga_out.vsync <= '0; vga_out.hsync <= '0; vga_out.vblnk <= '0; vga_out.hblnk <= '0; vga_out.rgb <= '0;
        end else begin
            vga_out.vcount <= vga_nxt.vcount; vga_out.hcount <= vga_nxt.hcount; vga_out.vsync <= vga_nxt.vsync; vga_out.hsync <= vga_nxt.hsync; vga_out.vblnk <= vga_nxt.vblnk; vga_out.hblnk <= vga_nxt.hblnk; vga_out.rgb <= vga_nxt.rgb;
        end
    end

    always_comb begin
        vga_nxt.vcount = vga_in.vcount; vga_nxt.hcount = vga_in.hcount; vga_nxt.vsync = vga_in.vsync; vga_nxt.hsync = vga_in.hsync; vga_nxt.vblnk = vga_in.vblnk; vga_nxt.hblnk = vga_in.hblnk; vga_nxt.rgb = vga_in.rgb; 

        d_L1 = 1'b0;
        case (route_L1)
            3'd1: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, -86, TOR_HEIGHT);
            3'd2: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, -38, TOR_HEIGHT);
            3'd3: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, 0,   TOR_HEIGHT);
            3'd4: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, 48,  TOR_HEIGHT);
            3'd5: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, 86,  TOR_HEIGHT);
            3'd6: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, 134, TOR_HEIGHT);
        endcase

        d_L2 = 1'b0;
        case (route_L2)
            3'd1: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, -134, TOR_HEIGHT);
            3'd2: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, -86,  TOR_HEIGHT);
            3'd3: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, -48,  TOR_HEIGHT);
            3'd4: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, 0,    TOR_HEIGHT);
            3'd5: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, 38,   TOR_HEIGHT);
            3'd6: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, 86,   TOR_HEIGHT);
        endcase

        d_P1 = 1'b0;
        case (route_P1)
            3'd1: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 186, 200, 86,   TOR_HEIGHT);
            3'd2: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 234, 200, 38,   TOR_HEIGHT);
            3'd3: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 272, 200, 0,    TOR_HEIGHT);
            3'd4: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 320, 200, -48,  TOR_HEIGHT);
            3'd5: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 358, 200, -86,  TOR_HEIGHT);
            3'd6: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 406, 200, -134, TOR_HEIGHT);
        endcase

        d_P2 = 1'b0;
        case (route_P2)
            3'd1: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 186, 200, 134,  TOR_HEIGHT);
            3'd2: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 234, 200, 86,   TOR_HEIGHT);
            3'd3: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 272, 200, 48,   TOR_HEIGHT);
            3'd4: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 320, 200, 0,    TOR_HEIGHT);
            3'd5: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 358, 200, -38,  TOR_HEIGHT);
            3'd6: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 406, 200, -86,  TOR_HEIGHT);
        endcase

        active_L1 = (route_L1 != 0) && (select_L_upper == 1'b1);
        active_L2 = (route_L2 != 0) && (select_L_upper == 1'b0);
        active_P1 = (route_P1 != 0) && (select_P_upper == 1'b1);
        active_P2 = (route_P2 != 0) && (select_P_upper == 1'b0);

        if (d_L1) vga_nxt.rgb = active_L1 ? 12'hFFF : 12'h444;
        else if (d_L2) vga_nxt.rgb = active_L2 ? 12'hFFF : 12'h444;
        else if (d_P1) vga_nxt.rgb = active_P1 ? 12'hFFF : 12'h444;
        else if (d_P2) vga_nxt.rgb = active_P2 ? 12'hFFF : 12'h444;
    end
endmodule