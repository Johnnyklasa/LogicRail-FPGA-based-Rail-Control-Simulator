module DrawSemafor (
    input logic clk,
    input logic rst,
    input logic [1:0] signals [0:15], 
    vga_if.in vga_in,
    vga_if.out vga_out
);
    import vga_pkg::*;
    import SRK_pkg::*;
    import Map_pkg::*;

    vga_if vga_nxt();

    // Wykrywanie ID Semafora ze zwiększonym dystansem dla torów wjazdowych (Y - 24)
    function automatic int GetSemaforID(input int h, input int v);
        int L_X = START_X_STACJA - SemaforWidth - 5;
        int R_X = START_X_STACJA + TOR_WIDTH + 5;
        int SZLAK_L_MID = START_X_LEWY_SZLAK + (TOR_SZLAK_WIDTH / 2) - (SemaforWidth / 2);
        int SZLAK_R_MID = START_X_PRAWY_SZLAK + (TOR_SZLAK_WIDTH / 2) - (SemaforWidth / 2);
        
        if (DrawRect(h, v, L_X, Y_TOR1 - 2, SemaforWidth, SemaforHeight)) return 0;
        if (DrawRect(h, v, R_X, Y_TOR1 - 2, SemaforWidth, SemaforHeight)) return 1;
        if (DrawRect(h, v, L_X, Y_TOR2 - 2, SemaforWidth, SemaforHeight)) return 2;
        if (DrawRect(h, v, R_X, Y_TOR2 - 2, SemaforWidth, SemaforHeight)) return 3;
        if (DrawRect(h, v, L_X, Y_TOR3 - 2, SemaforWidth, SemaforHeight)) return 4;
        if (DrawRect(h, v, R_X, Y_TOR3 - 2, SemaforWidth, SemaforHeight)) return 5;
        if (DrawRect(h, v, L_X, Y_TOR4 - 2, SemaforWidth, SemaforHeight)) return 6;
        if (DrawRect(h, v, R_X, Y_TOR4 - 2, SemaforWidth, SemaforHeight)) return 7;
        if (DrawRect(h, v, L_X, Y_TOR5 - 2, SemaforWidth, SemaforHeight)) return 8;
        if (DrawRect(h, v, R_X, Y_TOR5 - 2, SemaforWidth, SemaforHeight)) return 9;
        if (DrawRect(h, v, L_X, Y_TOR6 - 2, SemaforWidth, SemaforHeight)) return 10;
        if (DrawRect(h, v, R_X, Y_TOR6 - 2, SemaforWidth, SemaforHeight)) return 11;
        
        if (DrawRect(h, v, SZLAK_L_MID, Y_SZLAK_L1 - 24, SemaforWidth, SemaforHeight)) return 12;
        if (DrawRect(h, v, SZLAK_L_MID, Y_SZLAK_L2 - 24, SemaforWidth, SemaforHeight)) return 13;
        if (DrawRect(h, v, SZLAK_R_MID, Y_SZLAK_P1 - 24, SemaforWidth, SemaforHeight)) return 14;
        if (DrawRect(h, v, SZLAK_R_MID, Y_SZLAK_P2 - 24, SemaforWidth, SemaforHeight)) return 15;

        return -1;
    endfunction

    function automatic int GetLedIndex(input int lx, input int ly);
        int cy = SemaforHeight / 2;
        int r  = LedDiameter / 2;
        if (((lx - 7)*(lx - 7) + (ly - cy)*(ly - cy)) <= r*r) return 0;
        if (((lx - 17)*(lx - 17) + (ly - cy)*(ly - cy)) <= r*r) return 1;
        if (((lx - 27)*(lx - 27) + (ly - cy)*(ly - cy)) <= r*r) return 2;
        if (((lx - 37)*(lx - 37) + (ly - cy)*(ly - cy)) <= r*r) return 3;
        return -1;
    endfunction

    int active_sem_id;
    int s_x, s_y, local_x, local_y, led_idx;
    int L_X, R_X, SZLAK_L_MID, SZLAK_R_MID;

    always_ff @(posedge clk ) begin 
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
        vga_nxt.rgb    = vga_in.rgb; 
        
        L_X = START_X_STACJA - SemaforWidth - 5;
        R_X = START_X_STACJA + TOR_WIDTH + 5;
        SZLAK_L_MID = START_X_LEWY_SZLAK + (TOR_SZLAK_WIDTH / 2) - (SemaforWidth / 2);
        SZLAK_R_MID = START_X_PRAWY_SZLAK + (TOR_SZLAK_WIDTH / 2) - (SemaforWidth / 2);
        
        active_sem_id = GetSemaforID(vga_in.hcount, vga_in.vcount);

        if (vga_in.vblnk || vga_in.hblnk) begin            
            vga_nxt.rgb = 12'h0_0_0;
        end
        else if (active_sem_id != -1) begin
            vga_nxt.rgb = 12'h8_8_8; 
            
            if (active_sem_id < 12) begin
                s_x = (active_sem_id % 2 == 0) ? L_X : R_X;
                case (active_sem_id / 2)
                    0: s_y = Y_TOR1 - 2;
                    1: s_y = Y_TOR2 - 2;
                    2: s_y = Y_TOR3 - 2;
                    3: s_y = Y_TOR4 - 2;
                    4: s_y = Y_TOR5 - 2;
                    5: s_y = Y_TOR6 - 2;
                    default: s_y = 0;
                endcase
            end else begin
                s_x = (active_sem_id == 12 || active_sem_id == 13) ? SZLAK_L_MID : SZLAK_R_MID;
                case (active_sem_id)
                    12: s_y = Y_SZLAK_L1 - 24;
                    13: s_y = Y_SZLAK_L2 - 24;
                    14: s_y = Y_SZLAK_P1 - 24;
                    15: s_y = Y_SZLAK_P2 - 24;
                    default: s_y = 0;
                endcase
            end
            
            local_x = vga_in.hcount - s_x;
            local_y = vga_in.vcount - s_y;
            led_idx = GetLedIndex(local_x, local_y);
            
            if (led_idx != -1) begin
                vga_nxt.rgb = 12'h3_3_3; 
                case (signals[active_sem_id]) 
                    2'h1: if (led_idx == 1) vga_nxt.rgb = 12'hF_0_0; 
                    2'h2: if (led_idx == 0) vga_nxt.rgb = 12'h0_F_0; 
                    2'h3: if (led_idx == 2 || led_idx == 3) vga_nxt.rgb = 12'hF_F_0; 
                    2'h0: ; 
                endcase
            end
        end
    end
endmodule