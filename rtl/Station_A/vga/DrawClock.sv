//Autor:Jan Rutkowski
module DrawClock(
    input logic clk,
    input logic rst_n,
    input logic [5:0] minutes,
    input logic [4:0] hours,
    vga_if.in  vga_in,
    vga_if.out vga_out
);

vga_if vga_nxt();
import SRK_pkg::*;

always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            vga_out.vcount <= '0; vga_out.hcount <= '0; 
            vga_out.vsync <= '0;  vga_out.hsync <= '0; 
            vga_out.vblnk <= '0;  vga_out.hblnk <= '0; 
            vga_out.rgb <= '0;
        end
        else begin 
            vga_out.vcount <= vga_nxt.vcount; vga_out.hcount <= vga_nxt.hcount; 
            vga_out.vsync <= vga_nxt.vsync;   vga_out.hsync <= vga_nxt.hsync; 
            vga_out.vblnk <= vga_nxt.vblnk;   vga_out.hblnk <= vga_nxt.hblnk; 
            vga_out.rgb <= vga_nxt.rgb;
        end
    end



logic [6:0] SSEG_CODE [0:9] = '{
        7'b0000001, // 0
        7'b1001111, // 1 
        7'b0010010, // 2
        7'b0000110, // 3
        7'b1001100, // 4
        7'b0100100, // 5
        7'b0100000, // 6
        7'b0001111, // 7
        7'b0000000, // 8
        7'b0000100  // 9
    };
logic [3:0] h_tens, h_ones;
logic [3:0] m_tens, m_ones;
localparam int SEG_THICKNESS = 10;
localparam int SEG_LENGTH = 40;    

//BCD
always_comb begin
       
        if (hours >= 20)      {h_tens, h_ones} = {4'd2, 4'(hours - 20)};
        else if (hours >= 10) {h_tens, h_ones} = {4'd1, 4'(hours - 10)};
        else                  {h_tens, h_ones} = {4'd0, 4'(hours)};
        
        
        if (minutes >= 50)      {m_tens, m_ones} = {4'd5, 4'(minutes - 50)};
        else if (minutes >= 40) {m_tens, m_ones} = {4'd4, 4'(minutes - 40)};
        else if (minutes >= 30) {m_tens, m_ones} = {4'd3, 4'(minutes - 30)};
        else if (minutes >= 20) {m_tens, m_ones} = {4'd2, 4'(minutes - 20)};
        else if (minutes >= 10) {m_tens, m_ones} = {4'd1, 4'(minutes - 10)};
        else                    {m_tens, m_ones} = {4'd0, 4'(minutes)};
    end



localparam VerticalWidth =80;
localparam VerticalHeight = 20;
localparam HorizontalWidth = 20;
localparam HorizontalHeight= 80;


function automatic logic DrawDigit(input logic [6:0] segments, input int x_offset, input int y_offset, input int hcount, input int vcount);
        logic is_pixel_on = 1'b0;
        
       
       if (!segments[6] && DrawRect(hcount, vcount, x_offset + SEG_THICKNESS, y_offset, SEG_LENGTH, SEG_THICKNESS)) is_pixel_on = 1'b1;
        
        
        if (!segments[5] && DrawRect(hcount, vcount, x_offset + SEG_THICKNESS + SEG_LENGTH, y_offset + SEG_THICKNESS, SEG_THICKNESS, SEG_LENGTH)) is_pixel_on = 1'b1;
        
      
        if (!segments[4] && DrawRect(hcount, vcount, x_offset + SEG_THICKNESS + SEG_LENGTH, y_offset + (2 * SEG_THICKNESS) + SEG_LENGTH, SEG_THICKNESS, SEG_LENGTH)) is_pixel_on = 1'b1;
        
       
        if (!segments[3] && DrawRect(hcount, vcount, x_offset + SEG_THICKNESS, y_offset + (2 * SEG_THICKNESS) + (2 * SEG_LENGTH), SEG_LENGTH, SEG_THICKNESS)) is_pixel_on = 1'b1;
        
        
        if (!segments[2] && DrawRect(hcount, vcount, x_offset, y_offset + (2 * SEG_THICKNESS) + SEG_LENGTH, SEG_THICKNESS, SEG_LENGTH)) is_pixel_on = 1'b1;
        
       
        if (!segments[1] && DrawRect(hcount, vcount, x_offset, y_offset + SEG_THICKNESS, SEG_THICKNESS, SEG_LENGTH)) is_pixel_on = 1'b1;
        
       
        if (!segments[0] && DrawRect(hcount, vcount, x_offset + SEG_THICKNESS, y_offset + SEG_THICKNESS + SEG_LENGTH, SEG_LENGTH, SEG_THICKNESS)) is_pixel_on = 1'b1;
        return is_pixel_on;
    endfunction
        
always_comb begin 
        vga_nxt.vcount = vga_in.vcount; vga_nxt.hcount = vga_in.hcount; 
        vga_nxt.vsync = vga_in.vsync;   vga_nxt.hsync = vga_in.hsync; 
        vga_nxt.vblnk = vga_in.vblnk;   vga_nxt.hblnk = vga_in.hblnk; 
        vga_nxt.rgb = vga_in.rgb; 
        
       
        if      (DrawDigit(SSEG_CODE[h_tens], 300, 50, vga_in.hcount, vga_in.vcount)) vga_nxt.rgb = 12'hF_F_F;
        else if (DrawDigit(SSEG_CODE[h_ones], 370, 50, vga_in.hcount, vga_in.vcount)) vga_nxt.rgb = 12'hF_F_F;
        
       
        else if (DrawRect(vga_in.hcount, vga_in.vcount, 420, 70, SEG_THICKNESS, SEG_THICKNESS)) vga_nxt.rgb = 12'hF_F_F;
        else if (DrawRect(vga_in.hcount, vga_in.vcount, 420, 110, SEG_THICKNESS, SEG_THICKNESS)) vga_nxt.rgb = 12'hF_F_F;
        
        else if (DrawDigit(SSEG_CODE[m_tens], 470, 50, vga_in.hcount, vga_in.vcount)) vga_nxt.rgb = 12'hF_F_F;
        else if (DrawDigit(SSEG_CODE[m_ones], 540, 50, vga_in.hcount, vga_in.vcount)) vga_nxt.rgb = 12'hF_F_F;
    end 

endmodule




