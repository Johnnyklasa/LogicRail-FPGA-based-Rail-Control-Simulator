//Autor: Karol sitko
module DrawPlatforms (
    input  logic clk,
    input  logic rst_n,
    vga_if.in  vga_in,
    vga_if.out vga_out
);
    import vga_pkg::*;
    import SRK_pkg::*;
    import Map_pkg::*;

    vga_if vga_nxt();

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vga_out.vcount <= '0; vga_out.hcount <= '0; vga_out.vsync <= '0; vga_out.hsync <= '0; vga_out.vblnk <= '0; vga_out.hblnk <= '0; vga_out.rgb <= '0;
        end else begin
            vga_out.vcount <= vga_nxt.vcount; vga_out.hcount <= vga_nxt.hcount; vga_out.vsync <= vga_nxt.vsync; vga_out.hsync <= vga_nxt.hsync; vga_out.vblnk <= vga_nxt.vblnk; vga_out.hblnk <= vga_nxt.hblnk; vga_out.rgb <= vga_nxt.rgb;
        end
    end

    always_comb begin
        vga_nxt.vcount = vga_in.vcount; vga_nxt.hcount = vga_in.hcount; vga_nxt.vsync = vga_in.vsync; vga_nxt.hsync = vga_in.hsync; vga_nxt.vblnk = vga_in.vblnk; vga_nxt.hblnk = vga_in.hblnk; vga_nxt.rgb = vga_in.rgb;

        if (DrawRect(vga_in.hcount, vga_in.vcount, START_X_PERONY, Y_PERON1, PERON_WIDTH, PERON_HEIGHT) ||
            DrawRect(vga_in.hcount, vga_in.vcount, START_X_PERONY, Y_PERON2, PERON_WIDTH, PERON_HEIGHT) ||
            DrawRect(vga_in.hcount, vga_in.vcount, START_X_PERONY, Y_PERON3, PERON_WIDTH, PERON_HEIGHT)) begin
            vga_nxt.rgb = 12'h555; 
        end
    end
endmodule
