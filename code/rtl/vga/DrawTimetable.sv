module DrawTimetable (
    input  logic clk,
    input  logic rst_n,
    input  logic MouseLeftClick, 
    input  logic [11:0] X_POS,   
    input  logic [11:0] Y_POS,   
    vga_if.in  vga_in,
    vga_if.out vga_out
);

    vga_if vga_nxt();

    logic MouseClick;
    
    ClickDetector u_ClickDetector(
        .clk(clk),
        .Signal(MouseLeftClick),
        .pos_edge(MouseClick),
        .neg_edge()
    );

    logic is_open;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) is_open <= 1'b0;
        
        else if (MouseClick && X_POS >= 10 && X_POS <= 90 && Y_POS >= 10 && Y_POS <= 30)
            is_open <= ~is_open;
    end

  
    logic [7:0] char_xy;
    logic [7:0] char_code;
    logic [3:0] char_line;
    logic [7:0] char_line_pixels;

  
    localparam WIN_X = 10;
    localparam WIN_Y = 40;

    
    TimetableRom u_TimetableRom(
        .char_xy(char_xy),
        .char_code(char_code)
    );

    font_rom u_font_rom (
        .clk(clk),
        .addr({char_code[6:0], char_line}),
        .char_line_pixels(char_line_pixels)
    );

   
    logic [10:0] req_h, req_v; 
    logic [10:0] draw_h;       
    logic pixel_on, in_text_rect, in_btn_rect;

    logic [10:0] hcount_d, vcount_d;
    logic hsync_d, vsync_d, hblnk_d, vblnk_d;
    logic [11:0] rgb_d;

    always_comb begin
        req_h = vga_in.hcount - WIN_X;
        req_v = vga_in.vcount - WIN_Y;
        char_xy = { req_v[6:4], req_h[7:3] }; 
        char_line = req_v[3:0];
    end

   
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hcount_d <= '0; vcount_d <= '0;
            hsync_d  <= '0; vsync_d  <= '0;
            hblnk_d  <= '0; vblnk_d  <= '0;
            rgb_d    <= '0;
        end else begin
            hcount_d <= vga_in.hcount; vcount_d <= vga_in.vcount;
            hsync_d  <= vga_in.hsync;  vsync_d  <= vga_in.vsync;
            hblnk_d  <= vga_in.hblnk;  vblnk_d  <= vga_in.vblnk;
            rgb_d    <= vga_in.rgb;
        end
    end

    always_comb begin
        vga_nxt.hcount = hcount_d; vga_nxt.vcount = vcount_d;
        vga_nxt.hsync  = hsync_d;  vga_nxt.vsync  = vsync_d;
        vga_nxt.hblnk  = hblnk_d;  vga_nxt.vblnk  = vblnk_d;

        in_btn_rect  = (hcount_d >= 10) && (hcount_d < 90) && (vcount_d >= 10) && (vcount_d < 30);
        in_text_rect = (hcount_d >= WIN_X) && (hcount_d < WIN_X + 256) && (vcount_d >= WIN_Y) && (vcount_d < WIN_Y + 128);

        draw_h = hcount_d - WIN_X;
        pixel_on = char_line_pixels[3'h7 - draw_h[2:0]];

        if (hblnk_d || vblnk_d) begin 
            vga_nxt.rgb = 12'h000;
        end
        else if (in_btn_rect) begin
            
            vga_nxt.rgb = is_open ? 12'h0_F_0 : 12'hF_0_0;
        end
        else if (is_open && in_text_rect) begin
           
            vga_nxt.rgb = pixel_on ? 12'hF_F_F : 12'h1_1_3;
        end
        else begin
            vga_nxt.rgb = rgb_d; 
        end
    end

  
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
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

endmodule
