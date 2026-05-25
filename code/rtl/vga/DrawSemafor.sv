
module DrawSemafor (
    input logic clk,
    input logic rst,

    input logic [1:0] signal,            

    vga_if.in vga_in,
    vga_if.out vga_out
);

vga_if vga_nxt();

import vga_pkg::*;
import SRK_pkg::*;
import Map_pkg::*;

always_ff @(posedge clk ) begin 
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
    
    vga_nxt.rgb    = 12'h0_0_0;

    if (vga_in.vblnk || vga_in.hblnk) begin            
        vga_nxt.rgb = 12'h0_0_0;                        
    end

    else if (DrawRect(vga_in.hcount, vga_in.vcount, Semafor1XPos ,Semafor1Ypos, SemaforWidth, SemaforHeight)) begin
        vga_nxt.rgb = 12'h8_8_8;
        if (DrawCircle(vga_in.hcount, vga_in.hcount,Semafor1XPos+SemaforWidth/2,  Semafor1Ypos + 10, LedDiameter))begin
            case (signal) 
                2'h1: vga_nxt.rgb = 12'hF_0_0;
                2'h2: vga_nxt.rgb = 12'h0_F_0;
                2'h3: vga_nxt.rgb = 12'hF_F_0;
                2'h0: vga_nxt.rgb = 12'h0_0_0;
            endcase
    end
    
end
end
endmodule
