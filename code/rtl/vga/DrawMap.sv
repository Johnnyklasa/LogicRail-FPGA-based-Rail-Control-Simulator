module DrawMap (
    input logic clk,
    input logic rst,
    
    input logic [2:0] route_L1, 
    input logic [2:0] route_L2,
    input logic [2:0] route_P1,
    input logic [2:0] route_P2,

    // Physical lever signals (1 = Upper turnout active, 0 = Lower turnout active)
    input logic select_L_upper, 
    input logic select_P_upper,

    vga_if.in  vga_in,
    vga_if.out vga_out
);
    import vga_pkg::*;
    import SRK_pkg::*;
    import Map_pkg::*;

    vga_if vga_nxt();

    function automatic logic DrawTrack(input int h, input int v, input int x, input int y, input int width);
        if (h >= x && h < (x + width) && v >= y && v <= (y + TOR_HEIGHT)) begin
            if (v == y || v == (y + TOR_HEIGHT) || h[3:0] < 2) return 1'b1;
        end
        return 1'b0;
    endfunction

    function automatic logic IsLine(input int h, input int v, input int x1, input int y1, input int dx, input int dy);
        int diff, abs_diff, min_y, max_y;
        
        if (h < x1 || h > x1 + dx) return 1'b0;
        
        min_y = (dy > 0) ? y1 : y1 + dy;
        max_y = (dy > 0) ? y1 + dy : y1;
        if (v < min_y - 6 || v > max_y + 6 + TOR_HEIGHT) return 1'b0;

        diff = dy * (h - x1) - dx * (v - y1 - (TOR_HEIGHT/2));
        abs_diff = (diff < 0) ? -diff : diff;

        if (abs_diff <= (dx * (TOR_HEIGHT/2))) begin
            if (abs_diff >= (dx * ((TOR_HEIGHT/2) - 1))) return 1'b1; 
            if (h[3:0] < 2) return 1'b1;
        end
        return 1'b0;
    endfunction

    logic d_L1, d_L2, d_P1, d_P2;
    logic active_L1, active_L2, active_P1, active_P2;

    always_ff @(posedge clk) begin
        if (rst) begin
            vga_out.vcount <= '0; vga_out.hcount <= '0;
            vga_out.vsync  <= '0; vga_out.hsync  <= '0;
            vga_out.vblnk  <= '0; vga_out.hblnk  <= '0;
            vga_out.rgb    <= '0;
        end else begin
            vga_out.vcount <= vga_nxt.vcount; vga_out.hcount <= vga_nxt.hcount;
            vga_out.vsync  <= vga_nxt.vsync;  vga_out.hsync  <= vga_nxt.hsync;
            vga_out.vblnk  <= vga_nxt.vblnk;  vga_out.hblnk  <= vga_nxt.hblnk;
            vga_out.rgb    <= vga_nxt.rgb;
        end
    end

    always_comb begin
        vga_nxt.vcount = vga_in.vcount; vga_nxt.hcount = vga_in.hcount;
        vga_nxt.vsync  = vga_in.vsync;  vga_nxt.hsync  = vga_in.hsync;
        vga_nxt.vblnk  = vga_in.vblnk;  vga_nxt.hblnk  = vga_in.hblnk;
        vga_nxt.rgb = vga_in.rgb; 

        // Turnout path calculations
        d_L1 = 1'b0;
        case (route_L1)
            3'd1: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, -86);
            3'd2: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, -38);
            3'd3: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, 0);
            3'd4: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, 48);
            3'd5: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, 86);
            3'd6: d_L1 = IsLine(vga_in.hcount, vga_in.vcount, 80, 272, 200, 134);
        endcase

        d_L2 = 1'b0;
        case (route_L2)
            3'd1: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, -134);
            3'd2: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, -86);
            3'd3: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, -48);
            3'd4: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, 0);
            3'd5: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, 38);
            3'd6: d_L2 = IsLine(vga_in.hcount, vga_in.vcount, 80, 320, 200, 86);
        endcase

        d_P1 = 1'b0;
        case (route_P1)
            3'd1: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 186, 200, 86);
            3'd2: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 234, 200, 38);
            3'd3: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 272, 200, 0);
            3'd4: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 320, 200, -48);
            3'd5: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 358, 200, -86);
            3'd6: d_P1 = IsLine(vga_in.hcount, vga_in.vcount, 520, 406, 200, -134);
        endcase

        d_P2 = 1'b0;
        case (route_P2)
            3'd1: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 186, 200, 134);
            3'd2: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 234, 200, 86);
            3'd3: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 272, 200, 48);
            3'd4: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 320, 200, 0);
            3'd5: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 358, 200, -38);
            3'd6: d_P2 = IsLine(vga_in.hcount, vga_in.vcount, 520, 406, 200, -86);
        endcase

        // Activation condition controlled solely by physical lever state
        active_L1 = (route_L1 != 0) && (select_L_upper == 1'b1);
        active_L2 = (route_L2 != 0) && (select_L_upper == 1'b0);
        active_P1 = (route_P1 != 0) && (select_P_upper == 1'b1);
        active_P2 = (route_P2 != 0) && (select_P_upper == 1'b0);

        // Rendering logic
        if (DrawRect(vga_in.hcount, vga_in.vcount, START_X_PERONY, Y_PERON1, PERON_WIDTH, PERON_HEIGHT)) vga_nxt.rgb = 12'h555; 
        else if (DrawRect(vga_in.hcount, vga_in.vcount, START_X_PERONY, Y_PERON2, PERON_WIDTH, PERON_HEIGHT)) vga_nxt.rgb = 12'h555;
        else if (DrawRect(vga_in.hcount, vga_in.vcount, START_X_PERONY, Y_PERON3, PERON_WIDTH, PERON_HEIGHT)) vga_nxt.rgb = 12'h555;
            
        else if (DrawTrack(vga_in.hcount, vga_in.vcount, START_X_STACJA, Y_TOR1, TOR_WIDTH)) vga_nxt.rgb = 12'hFFF;
        else if (DrawTrack(vga_in.hcount, vga_in.vcount, START_X_STACJA, Y_TOR2, TOR_WIDTH)) vga_nxt.rgb = 12'hFFF;
        else if (DrawTrack(vga_in.hcount, vga_in.vcount, START_X_STACJA, Y_TOR3, TOR_WIDTH)) vga_nxt.rgb = 12'hFFF;
        else if (DrawTrack(vga_in.hcount, vga_in.vcount, START_X_STACJA, Y_TOR4, TOR_WIDTH)) vga_nxt.rgb = 12'hFFF;
        else if (DrawTrack(vga_in.hcount, vga_in.vcount, START_X_STACJA, Y_TOR5, TOR_WIDTH)) vga_nxt.rgb = 12'hFFF;
        else if (DrawTrack(vga_in.hcount, vga_in.vcount, START_X_STACJA, Y_TOR6, TOR_WIDTH)) vga_nxt.rgb = 12'hFFF;

        else if (DrawTrack(vga_in.hcount, vga_in.vcount, START_X_LEWY_SZLAK, Y_SZLAK_L1, TOR_SZLAK_WIDTH)) vga_nxt.rgb = 12'hFFF;
        else if (DrawTrack(vga_in.hcount, vga_in.vcount, START_X_LEWY_SZLAK, Y_SZLAK_L2, TOR_SZLAK_WIDTH)) vga_nxt.rgb = 12'hFFF;
        else if (DrawTrack(vga_in.hcount, vga_in.vcount, START_X_PRAWY_SZLAK, Y_SZLAK_P1, TOR_SZLAK_WIDTH)) vga_nxt.rgb = 12'hFFF;
        else if (DrawTrack(vga_in.hcount, vga_in.vcount, START_X_PRAWY_SZLAK, Y_SZLAK_P2, TOR_SZLAK_WIDTH)) vga_nxt.rgb = 12'hFFF;

        // Rendering diagonal turnouts. Bright if enabled by lever, grey if cut off.
        else if (d_L1) vga_nxt.rgb = active_L1 ? 12'hFFF : 12'h444;
        else if (d_L2) vga_nxt.rgb = active_L2 ? 12'hFFF : 12'h444;
        else if (d_P1) vga_nxt.rgb = active_P1 ? 12'hFFF : 12'h444;
        else if (d_P2) vga_nxt.rgb = active_P2 ? 12'hFFF : 12'h444;
    end
endmodule