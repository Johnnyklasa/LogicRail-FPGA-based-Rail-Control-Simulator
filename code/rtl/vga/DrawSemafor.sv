module DrawSemafor (
    input logic clk,
    input logic rst,
    input logic [1:0] signals [0:15],            
    vga_if.in vga_in,
    vga_if.out vga_out
);

vga_if vga_nxt();

import vga_pkg::*;
import SRK_pkg::*;
import Map_pkg::*;

function automatic int GetSemaforID(input int h, input int v);
    
    int sem_w = 10;
    int sem_h = 16;
    int L_X = START_X_STACJA - sem_w - 6;
    int R_X = START_X_STACJA + TOR_WIDTH + 6;
    int SZLAK_L_MID = START_X_LEWY_SZLAK + (TOR_SZLAK_WIDTH / 2) - (sem_w / 2);
    int SZLAK_R_MID = START_X_PRAWY_SZLAK + (TOR_SZLAK_WIDTH / 2) - (sem_w / 2);
    
    if (DrawRect(h, v, L_X, Y_TOR1 - 4, sem_w, sem_h)) return 0;
    if (DrawRect(h, v, R_X, Y_TOR1 - 4, sem_w, sem_h)) return 1;
    if (DrawRect(h, v, L_X, Y_TOR2 - 4, sem_w, sem_h)) return 2;
    if (DrawRect(h, v, R_X, Y_TOR2 - 4, sem_w, sem_h)) return 3;
    if (DrawRect(h, v, L_X, Y_TOR3 - 4, sem_w, sem_h)) return 4;
    if (DrawRect(h, v, R_X, Y_TOR3 - 4, sem_w, sem_h)) return 5;
    if (DrawRect(h, v, L_X, Y_TOR4 - 4, sem_w, sem_h)) return 6;
    if (DrawRect(h, v, R_X, Y_TOR4 - 4, sem_w, sem_h)) return 7;
    if (DrawRect(h, v, L_X, Y_TOR5 - 4, sem_w, sem_h)) return 8;
    if (DrawRect(h, v, R_X, Y_TOR5 - 4, sem_w, sem_h)) return 9;
    if (DrawRect(h, v, L_X, Y_TOR6 - 4, sem_w, sem_h)) return 10;
    if (DrawRect(h, v, R_X, Y_TOR6 - 4, sem_w, sem_h)) return 11;
    
    if (DrawRect(h, v, SZLAK_L_MID, Y_SZLAK_L1 - 16, sem_w, sem_h)) return 12;
    if (DrawRect(h, v, SZLAK_L_MID, Y_SZLAK_L2 - 16, sem_w, sem_h)) return 13;
    if (DrawRect(h, v, SZLAK_R_MID, Y_SZLAK_P1 - 16, sem_w, sem_h)) return 14;
    if (DrawRect(h, v, SZLAK_R_MID, Y_SZLAK_P2 - 16, sem_w, sem_h)) return 15;

    return -1;
endfunction

int active_sem_id;
int s_x, s_y, local_x, local_y;
int L_X, R_X, SZLAK_L_MID, SZLAK_R_MID;

always_ff @(posedge clk) begin 
    if (rst) begin 
        vga_out.vcount <= '0;
        vga_out.vsync  <= '0;
        vga_out.vblnk  <= '0;
        vga_out.hcount <= '0;
        vga_out.hsync  <= '0;
        vga_out.hblnk  <= '0;
        vga_out.rgb    <= '0;
    end
    else begin
        vga_out.vcount <= vga_nxt.vcount;
        vga_out.vsync  <= vga_nxt.vsync;
        vga_out.vblnk  <= vga_nxt.vblnk;
        vga_out.hcount <= vga_nxt.hcount;
        vga_out.hsync  <= vga_nxt.hsync;
        vga_out.hblnk  <= vga_nxt.hblnk;
        vga_out.rgb    <= vga_nxt.rgb;
    end
end

always_comb begin 
    vga_nxt.vcount = vga_in.vcount;
    vga_nxt.hcount = vga_in.hcount;
    vga_nxt.vsync  = vga_in.vsync;
    vga_nxt.hsync  = vga_in.hsync;
    vga_nxt.vblnk  = vga_in.vblnk;
    vga_nxt.hblnk  = vga_in.hblnk;
    vga_nxt.rgb    = vga_in.rgb; 
    
    L_X = START_X_STACJA - 10 - 6;
    R_X = START_X_STACJA + TOR_WIDTH + 6;
    SZLAK_L_MID = START_X_LEWY_SZLAK + (TOR_SZLAK_WIDTH / 2) - 5;
    SZLAK_R_MID = START_X_PRAWY_SZLAK + (TOR_SZLAK_WIDTH / 2) - 5;

    active_sem_id = GetSemaforID(vga_in.hcount, vga_in.vcount);

    if (!vga_in.vblnk && !vga_in.hblnk) begin            
        if (active_sem_id != -1) begin
            vga_nxt.rgb = 12'h8_8_8; // Szara obudowa
            
            if (active_sem_id < 12) begin
                s_x = (active_sem_id % 2 == 0) ? L_X : R_X;
                case (active_sem_id / 2)
                    0: s_y = Y_TOR1 - 4;
                    1: s_y = Y_TOR2 - 4;
                    2: s_y = Y_TOR3 - 4;
                    3: s_y = Y_TOR4 - 4;
                    4: s_y = Y_TOR5 - 4;
                    5: s_y = Y_TOR6 - 4;
                    default: s_y = 0;
                endcase
            end else begin
                s_x = (active_sem_id == 12 || active_sem_id == 13) ? SZLAK_L_MID : SZLAK_R_MID;
                case (active_sem_id)
                    12: s_y = Y_SZLAK_L1 - 16;
                    13: s_y = Y_SZLAK_L2 - 16;
                    14: s_y = Y_SZLAK_P1 - 16;
                    15: s_y = Y_SZLAK_P2 - 16;
                    default: s_y = 0;
                endcase
            end
            
            local_x = vga_in.hcount - s_x;
            local_y = vga_in.vcount - s_y;
            
            if (DrawCircle(local_x, local_y, 5, 8, 3)) begin
                case (signals[active_sem_id]) 
                    2'h1: vga_nxt.rgb = 12'hF_0_0; // Czerwony
                    2'h2: vga_nxt.rgb = 12'h0_F_0; // Zielony
                    2'h3: vga_nxt.rgb = 12'hF_F_0; // Żółty
                    default: vga_nxt.rgb = 12'h0_0_0;
                endcase
            end
        end
    end
end
endmodule