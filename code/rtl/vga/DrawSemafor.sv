module DrawSemafor (
    input logic clk,
    input logic rst_n,
    input logic [1:0] signals [0:15],            
    vga_if.in vga_in,
    vga_if.out vga_out
);

import vga_pkg::*;
import SRK_pkg::*;
import Map_pkg::*;

vga_if vga_mid();
vga_if vga_nxt();

int active_sem_id_reg;
int local_x, local_y;

 function automatic int GetSemaforID(input int h, input int v);
    for (int i = 0; i < SEMAFOR_NUMBER; i++) begin
        if (DrawRect(h, v, SemaforXPos[i], SemaforYPos[i], SemaforWidth, SemaforHeight)) begin
            return i; 
        end
    end
    return -1; 
endfunction



always_ff @(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin 
        vga_mid.vcount <= '0;
        vga_mid.vsync  <= '0;
        vga_mid.vblnk  <= '0;
        vga_mid.hcount <= '0;
        vga_mid.hsync  <= '0;
        vga_mid.hblnk  <= '0;
        vga_mid.rgb    <= '0;
        active_sem_id_reg <= -1;
    end
    else begin
       
        vga_mid.vcount <= vga_in.vcount;
        vga_mid.vsync  <= vga_in.vsync;
        vga_mid.vblnk  <= vga_in.vblnk;
        vga_mid.hcount <= vga_in.hcount;
        vga_mid.hsync  <= vga_in.hsync;
        vga_mid.hblnk  <= vga_in.hblnk;
        vga_mid.rgb    <= vga_in.rgb;
        
    
        active_sem_id_reg <= GetSemaforID(vga_in.hcount, vga_in.vcount);
    end
end


always_comb begin 
 
    vga_nxt.vcount = vga_mid.vcount;
    vga_nxt.hcount = vga_mid.hcount;
    vga_nxt.vsync  = vga_mid.vsync;
    vga_nxt.hsync  = vga_mid.hsync;
    vga_nxt.vblnk  = vga_mid.vblnk;
    vga_nxt.hblnk  = vga_mid.hblnk;
    vga_nxt.rgb    = vga_mid.rgb; 
    
  
    if (!vga_mid.vblnk && !vga_mid.hblnk) begin            
        if (active_sem_id_reg != -1) begin
            vga_nxt.rgb = 12'h8_8_8;
            
            local_x = vga_mid.hcount - SemaforXPos[active_sem_id_reg];
            local_y = vga_mid.vcount - SemaforYPos[active_sem_id_reg];
            
            if (DrawCircle(local_x, local_y, 5, 8, 3)) begin
                case (signals[active_sem_id_reg]) 
                    2'h0: vga_nxt.rgb = 12'hF_0_0; // Czerwony
                    2'h1: vga_nxt.rgb = 12'h0_F_0; // Zielony
                    2'h2: vga_nxt.rgb = 12'hF_F_0; // Żółty
                    default: vga_nxt.rgb = 12'h0_0_0;
                endcase
            end
        end
    end
end


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

endmodule
