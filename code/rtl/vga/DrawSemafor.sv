module DrawSemafor (
    input logic clk,
    input logic rst_n,
    input logic [1:0] signals [0:15],            
    vga_if.in vga_in,
    vga_if.out vga_out
);

vga_if vga_nxt();

import vga_pkg::*;
import SRK_pkg::*;
import Map_pkg::*;

function automatic int GetSemaforID(input int h, input int v);
  
    for (int i = 0; i < SEMAFOR_NUMBER; i++) begin
     
        if (DrawRect(h, v, SemaforXPos[i], SemaforYPos[i], SemaforWidth, SemaforHeight)) begin
            return i; 
        end
    end

    return -1; // Brak zderzenia
endfunction

int active_sem_id;
int s_x, s_y, local_x, local_y;
int L_X, R_X, SZLAK_L_MID, SZLAK_R_MID;

always_ff @(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin 
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
            
            s_x = SemaforXPos[active_sem_id];
            s_y = SemaforYPos[active_sem_id];
            
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
