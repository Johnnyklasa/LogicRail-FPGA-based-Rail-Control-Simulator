package SRK_pkg;
    localparam SemaforWidth = 16;
    localparam SemaforHeight = 20;
    localparam LedDiameter = 10;

    function automatic logic DrawRect(input int x_pos, input int y_pos, input int rectX, input int rectY, input int Width, input int Height);
        return ((x_pos >= rectX) && (x_pos <= rectX + Width) && (y_pos >= rectY) &&( y_pos <= rectY + Height));
    endfunction

    function automatic logic DrawCircle(input int x_pos, input int y_pos, input int circleX, input int circleY, input int radius);
        int dx = x_pos - circleX;
        int dy = y_pos - circleY;
        return ((dx * dx) + (dy * dy) <= (radius * radius));
    endfunction

    function automatic logic DrawTrack(input int h, input int v, input int x, input int y, input int width, input int height);
        if (h >= x && h < (x + width) && v >= y && v <= (y + height)) begin
            if (v == y || v == (y + height) || h[3:0] < 2) return 1'b1;
        end
        return 1'b0;
    endfunction

    function automatic logic IsLine(input int h, input int v, input int x1, input int y1, input int dx, input int dy, input int height);
        int diff, abs_diff, min_y, max_y;
        if (h < x1 || h > x1 + dx) return 1'b0;
        
        min_y = (dy > 0) ? y1 : y1 + dy;
        max_y = (dy > 0) ? y1 + dy : y1;
        if (v < min_y - 6 || v > max_y + 6 + height) return 1'b0;

        diff = dy * (h - x1) - dx * (v - y1 - (height/2));
        abs_diff = (diff < 0) ? -diff : diff;

        if (abs_diff <= (dx * (height/2))) begin
            if (abs_diff >= (dx * ((height/2) - 1))) return 1'b1; 
            if (h[3:0] < 2) return 1'b1;
        end
        return 1'b0;
    endfunction




endpackage
