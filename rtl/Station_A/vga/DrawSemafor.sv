//Autor Karol Sitko
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

// --- INTERFEJSY POTOKU ---
vga_if vga_st1();
vga_if vga_st2();

// --- STAGE 1 ---
int sem_id_st1;

// --- STAGE 2 ---
int sem_id_st2;
int local_x_st2, local_y_st2;
logic [1:0] current_signal_st2;

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
        vga_st1.vcount <= '0; vga_st1.hcount <= '0;
        vga_st1.vsync  <= '0; vga_st1.hsync  <= '0;
        vga_st1.vblnk  <= '0; vga_st1.hblnk  <= '0;
        vga_st1.rgb    <= '0;
        sem_id_st1     <= -1;
    end else begin
        vga_st1.vcount <= vga_in.vcount; vga_st1.hcount <= vga_in.hcount;
        vga_st1.vsync  <= vga_in.vsync;  vga_st1.hsync  <= vga_in.hsync;
        vga_st1.vblnk  <= vga_in.vblnk;  vga_st1.hblnk  <= vga_in.hblnk;
        vga_st1.rgb    <= vga_in.rgb;
        
        sem_id_st1 <= GetSemaforID(vga_in.hcount, vga_in.vcount);
    end
end


always_ff @(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin 
        vga_st2.vcount <= '0; vga_st2.hcount <= '0;
        vga_st2.vsync  <= '0; vga_st2.hsync  <= '0;
        vga_st2.vblnk  <= '0; vga_st2.hblnk  <= '0;
        vga_st2.rgb    <= '0;
        sem_id_st2 <= -1;
        local_x_st2 <= 0; local_y_st2 <= 0;
        current_signal_st2 <= 2'b00;
    end else begin
        vga_st2.vcount <= vga_st1.vcount; vga_st2.hcount <= vga_st1.hcount;
        vga_st2.vsync  <= vga_st1.vsync;  vga_st2.hsync  <= vga_st1.hsync;
        vga_st2.vblnk  <= vga_st1.vblnk;  vga_st2.hblnk  <= vga_st1.hblnk;
        vga_st2.rgb    <= vga_st1.rgb;
        
        sem_id_st2 <= sem_id_st1;
        
        if (sem_id_st1 != -1) begin
            local_x_st2 <= vga_st1.hcount - SemaforXPos[sem_id_st1];
            local_y_st2 <= vga_st1.vcount - SemaforYPos[sem_id_st1];
            current_signal_st2 <= signals[sem_id_st1];
        end
    end
end



logic in_circle;
assign in_circle = (sem_id_st2 != -1) ? DrawCircle(local_x_st2, local_y_st2, 5, 8, 3) : 1'b0;

always_ff @(posedge clk or negedge rst_n) begin 
    if (!rst_n) begin 
        vga_out.vcount <= '0; vga_out.hcount <= '0;
        vga_out.vsync  <= '0; vga_out.hsync  <= '0;
        vga_out.vblnk  <= '0; vga_out.hblnk  <= '0;
        vga_out.rgb    <= '0;
    end else begin
        vga_out.vcount <= vga_st2.vcount; vga_out.hcount <= vga_st2.hcount;
        vga_out.vsync  <= vga_st2.vsync;  vga_out.hsync  <= vga_st2.hsync;
        vga_out.vblnk  <= vga_st2.vblnk;  vga_out.hblnk  <= vga_st2.hblnk;
        
        if (!vga_st2.vblnk && !vga_st2.hblnk) begin            
            if (sem_id_st2 != -1) begin
                if (in_circle) begin
                    case (current_signal_st2) 
                        2'h0: vga_out.rgb <= 12'hF_0_0; // Czerwony
                        2'h1: vga_out.rgb <= 12'h0_F_0; // Zielony
                        2'h2: vga_out.rgb <= 12'hF_F_0; // Żółty
                        default: vga_out.rgb <= 12'h0_0_0;
                    endcase
                end else begin
                    vga_out.rgb <= 12'h8_8_8; 
                end
            end else begin
                vga_out.rgb <= vga_st2.rgb; 
            end
        end else begin
            vga_out.rgb <= 12'h0_0_0;
        end
    end
end

endmodule
