module TimetableRom (
    input  logic [7:0] char_xy,
    output logic [7:0] char_code,

    // --- NOWE PORTY: Most do pamięci RAM ---
    output logic [3:0] ram_addr_read,
    input  logic [7:0] ram_train_id,
    input  logic [11:0] ram_arr_time,
    input  logic [11:0] ram_dep_time
);
  
    localparam logic [0:31][7:0] HEADER1 = "--- ROZKLAD JAZDY ---           ";
    localparam logic [0:31][7:0] HEADER2 = "ID   PRZ.     ODJ.              ";

    logic [2:0] row;
    logic [4:0] col;
    assign row = char_xy[7:5];
    assign col = char_xy[4:0];

   
    assign ram_addr_read = (row >= 3'd2) ? (row - 3'd2) : 4'd0;

  
    logic [7:0] id_100, id_10, id_1;
    assign id_100 = 8'h30 + (ram_train_id / 100);
    assign id_10  = 8'h30 + ((ram_train_id / 10) % 10);
    assign id_1   = 8'h30 + (ram_train_id % 10);

  
    logic [7:0] arr_h, arr_m;
    assign arr_h = ram_arr_time / 60;
    assign arr_m = ram_arr_time % 60;
    
    logic [7:0] arr_h10, arr_h1, arr_m10, arr_m1;
    assign arr_h10 = 8'h30 + (arr_h / 10);
    assign arr_h1  = 8'h30 + (arr_h % 10);
    assign arr_m10 = 8'h30 + (arr_m / 10);
    assign arr_m1  = 8'h30 + (arr_m % 10);


    logic [7:0] dep_h, dep_m;
    assign dep_h = ram_dep_time / 60;
    assign dep_m = ram_dep_time % 60;
    
    logic [7:0] dep_h10, dep_h1, dep_m10, dep_m1;
    assign dep_h10 = 8'h30 + (dep_h / 10);
    assign dep_h1  = 8'h30 + (dep_h % 10);
    assign dep_m10 = 8'h30 + (dep_m / 10);
    assign dep_m1  = 8'h30 + (dep_m % 10);

    
    always_comb begin
        if (row == 0) begin
            char_code = HEADER1[col];
        end
        else if (row == 1) begin
            char_code = HEADER2[col];
        end
        else begin
           
            if (ram_train_id == 8'd0) begin
                char_code = 8'h20; 
            end else begin
                case (col)
                    // Kolumny ID
                    5'd0: char_code = id_100;
                    5'd1: char_code = id_10;
                    5'd2: char_code = id_1;
                    // Kolumny Przyjazdu
                    5'd5: char_code = arr_h10;
                    5'd6: char_code = arr_h1;
                    5'd7: char_code = 8'h3A; // Znak dwukropka ':'
                    5'd8: char_code = arr_m10;
                    5'd9: char_code = arr_m1;
                    // Kolumny Odjazdu
                    5'd14: char_code = dep_h10;
                    5'd15: char_code = dep_h1;
                    5'd16: char_code = 8'h3A; // Znak dwukropka ':'
                    5'd17: char_code = dep_m10;
                    5'd18: char_code = dep_m1;
                    // Puste miejsca
                    default: char_code = 8'h20;
                endcase
            end
        end
    end
endmodule
