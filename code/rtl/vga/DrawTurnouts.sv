module DrawTurnouts (
    input logic clk,
    input logic rst_n,
    input logic [2:0] route_L1, route_L2, route_P1, route_P2,
    input logic select_L_upper, select_P_upper,
    input logic [3:0] turnout_taken,
    vga_if.in  vga_in,
    vga_if.out vga_out
);
    import vga_pkg::*;
    import Map_pkg::*;
    import SRK_pkg::*;

    // --- INTERFEJSY POTOKU ---
    vga_if vga_in_reg();
    vga_if vga_mid();
    vga_if vga_nxt();

    // --- STAGE 1: Zdekodowane parametry tras ---
    int L1_sy, L1_dy;
    int L2_sy, L2_dy;
    int P1_sy, P1_dy;
    int P2_sy, P2_dy;

    logic en_L1, en_L2, en_P1, en_P2;
    logic act_L1, act_L2, act_P1, act_P2;

    logic d_L1_reg, d_L2_reg, d_P1_reg, d_P2_reg;
    logic act_L1_reg, act_L2_reg, act_P1_reg, act_P2_reg;
    logic taken_L1_reg, taken_L2_reg, taken_P1_reg, taken_P2_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vga_in_reg.vcount <= '0; vga_in_reg.hcount <= '0;
            vga_in_reg.vsync <= '0; vga_in_reg.hsync <= '0;
            vga_in_reg.vblnk <= '0; vga_in_reg.hblnk <= '0;
            vga_in_reg.rgb <= '0;
            L1_sy <= 0; L1_dy <= 0; L2_sy <= 0; L2_dy <= 0;
            P1_sy <= 0; P1_dy <= 0; P2_sy <= 0; P2_dy <= 0;
            en_L1 <= 0; en_L2 <= 0; en_P1 <= 0; en_P2 <= 0;
            act_L1 <= 0; act_L2 <= 0; act_P1 <= 0; act_P2 <= 0;
        end else begin
        
            vga_in_reg.vcount <= vga_in.vcount;
            vga_in_reg.hcount <= vga_in.hcount;
            vga_in_reg.vsync  <= vga_in.vsync;
            vga_in_reg.hsync  <= vga_in.hsync;
            vga_in_reg.vblnk  <= vga_in.vblnk;
            vga_in_reg.hblnk  <= vga_in.hblnk;
            vga_in_reg.rgb    <= vga_in.rgb;

         
            L1_sy <= Y_TOR3;
            case (route_L1)
                3'd1: L1_dy <= Y_TOR1 - Y_TOR3;
                3'd2: L1_dy <= Y_TOR2 - Y_TOR3;
                3'd3: L1_dy <= Y_TOR3 - Y_TOR3;
                3'd4: L1_dy <= Y_TOR4 - Y_TOR3;
                3'd5: L1_dy <= Y_TOR5 - Y_TOR3;
                3'd6: L1_dy <= Y_TOR6 - Y_TOR3;
                default: L1_dy <= 0;
            endcase

            L2_sy <= Y_TOR4;
            case (route_L2)
                3'd1: L2_dy <= Y_TOR1 - Y_TOR4;
                3'd2: L2_dy <= Y_TOR2 - Y_TOR4;
                3'd3: L2_dy <= Y_TOR3 - Y_TOR4;
                3'd4: L2_dy <= Y_TOR4 - Y_TOR4;
                3'd5: L2_dy <= Y_TOR5 - Y_TOR4;
                3'd6: L2_dy <= Y_TOR6 - Y_TOR4;
                default: L2_dy <= 0;
            endcase

            case (route_P1)
                3'd1: begin P1_sy <= Y_TOR1; P1_dy <= Y_TOR3 - Y_TOR1; end
                3'd2: begin P1_sy <= Y_TOR2; P1_dy <= Y_TOR3 - Y_TOR2; end
                3'd3: begin P1_sy <= Y_TOR3; P1_dy <= Y_TOR3 - Y_TOR3; end
                3'd4: begin P1_sy <= Y_TOR4; P1_dy <= Y_TOR3 - Y_TOR4; end
                3'd5: begin P1_sy <= Y_TOR5; P1_dy <= Y_TOR3 - Y_TOR5; end
                3'd6: begin P1_sy <= Y_TOR6; P1_dy <= Y_TOR3 - Y_TOR6; end
                default: begin P1_sy <= Y_TOR3; P1_dy <= 0; end
            endcase

            case (route_P2)
                3'd1: begin P2_sy <= Y_TOR1; P2_dy <= Y_TOR4 - Y_TOR1; end
                3'd2: begin P2_sy <= Y_TOR2; P2_dy <= Y_TOR4 - Y_TOR2; end
                3'd3: begin P2_sy <= Y_TOR3; P2_dy <= Y_TOR4 - Y_TOR3; end
                3'd4: begin P2_sy <= Y_TOR4; P2_dy <= Y_TOR4 - Y_TOR4; end
                3'd5: begin P2_sy <= Y_TOR5; P2_dy <= Y_TOR4 - Y_TOR5; end
                3'd6: begin P2_sy <= Y_TOR6; P2_dy <= Y_TOR4 - Y_TOR6; end
                default: begin P2_sy <= Y_TOR4; P2_dy <= 0; end
            endcase

            en_L1 <= (route_L1 != 0);
            en_L2 <= (route_L2 != 0);
            en_P1 <= (route_P1 != 0);
            en_P2 <= (route_P2 != 0);

            act_L1 <= (route_L1 != 0) && (select_L_upper == 1'b1);
            act_L2 <= (route_L2 != 0) && (select_L_upper == 1'b0);
            act_P1 <= (route_P1 != 0) && (select_P_upper == 1'b1);
            act_P2 <= (route_P2 != 0) && (select_P_upper == 1'b0);
        end
    end


    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vga_mid.vcount <= '0; vga_mid.hcount <= '0;
            vga_mid.vsync <= '0; vga_mid.hsync <= '0;
            vga_mid.vblnk <= '0; vga_mid.hblnk <= '0;
            vga_mid.rgb <= '0;
            d_L1_reg <= 0; d_L2_reg <= 0; d_P1_reg <= 0; d_P2_reg <= 0;
            act_L1_reg <= 0; act_L2_reg <= 0; act_P1_reg <= 0; act_P2_reg <= 0;
             taken_L1_reg <= 0; taken_L2_reg <= 0; taken_P1_reg <= 0; taken_P2_reg <= 0;
        end else begin
            vga_mid.vcount <= vga_in_reg.vcount;
            vga_mid.hcount <= vga_in_reg.hcount;
            vga_mid.vsync  <= vga_in_reg.vsync;
            vga_mid.hsync  <= vga_in_reg.hsync;
            vga_mid.vblnk  <= vga_in_reg.vblnk;
            vga_mid.hblnk  <= vga_in_reg.hblnk;
            vga_mid.rgb    <= vga_in_reg.rgb;


            d_L1_reg <= en_L1 ? IsLine(vga_in_reg.hcount, vga_in_reg.vcount, 80,  L1_sy, 200, L1_dy, TOR_HEIGHT) : 1'b0;
            d_L2_reg <= en_L2 ? IsLine(vga_in_reg.hcount, vga_in_reg.vcount, 80,  L2_sy, 200, L2_dy, TOR_HEIGHT) : 1'b0;
            d_P1_reg <= en_P1 ? IsLine(vga_in_reg.hcount, vga_in_reg.vcount, 520, P1_sy, 200, P1_dy, TOR_HEIGHT) : 1'b0;
            d_P2_reg <= en_P2 ? IsLine(vga_in_reg.hcount, vga_in_reg.vcount, 520, P2_sy, 200, P2_dy, TOR_HEIGHT) : 1'b0;

            act_L1_reg <= act_L1;
            act_L2_reg <= act_L2;
            act_P1_reg <= act_P1;
            act_P2_reg <= act_P2;

            taken_L1_reg <= turnout_taken[0];
            taken_L2_reg <= turnout_taken[1];
            taken_P1_reg <= turnout_taken[2];
            taken_P2_reg <= turnout_taken[3];
        end
    end


    always_comb begin
        vga_nxt.vcount = vga_mid.vcount; vga_nxt.hcount = vga_mid.hcount;
        vga_nxt.vsync = vga_mid.vsync;   vga_nxt.hsync = vga_mid.hsync;
        vga_nxt.vblnk = vga_mid.vblnk;   vga_nxt.hblnk = vga_mid.hblnk;
        vga_nxt.rgb = vga_mid.rgb;

       if (d_L1_reg) vga_nxt.rgb = taken_L1_reg ? 12'hF00 : (act_L1_reg ? 12'hFFF : 12'h444);
        else if (d_L2_reg) vga_nxt.rgb = taken_L2_reg ? 12'hF00 : (act_L2_reg ? 12'hFFF : 12'h444);
        else if (d_P1_reg) vga_nxt.rgb = taken_P1_reg ? 12'hF00 : (act_P1_reg ? 12'hFFF : 12'h444);
        else if (d_P2_reg) vga_nxt.rgb = taken_P2_reg ? 12'hF00 : (act_P2_reg ? 12'hFFF : 12'h444);
    end


    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vga_out.vcount <= '0; vga_out.hcount <= '0;
            vga_out.vsync <= '0;  vga_out.hsync <= '0;
            vga_out.vblnk <= '0;  vga_out.hblnk <= '0;
            vga_out.rgb <= '0;
        end else begin
            vga_out.vcount <= vga_nxt.vcount; vga_out.hcount <= vga_nxt.hcount;
            vga_out.vsync <= vga_nxt.vsync;   vga_out.hsync <= vga_nxt.hsync;
            vga_out.vblnk <= vga_nxt.vblnk;   vga_out.hblnk <= vga_nxt.hblnk;
            vga_out.rgb <= vga_nxt.rgb;
        end
    end
endmodule
