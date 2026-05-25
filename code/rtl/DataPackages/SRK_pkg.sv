
package SRK_pkg;

//parameters
localparam SemaforWidth = 16;
localparam SemaforHeight = 50;
localparam LedDiameter = 10;



//functions

function automatic logic DrawRect(int x_pos, int y_pos, int rectX, int rectY, int Width, int Height) ;
    return ((x_pos >= rectX) && (x_pos =< rectX + Width) && (y_pos >= rectY) &&( y_pos =< rectY + Height));
endfunction

function automatic logic DrawCircle(int x_pos, int y_pos, int circleX, int circleY, int radius);
    int dx;
    int dy;
    
    dx = x_pos - circleX;
    dy = y_pos - circleY;
    
    return ((dx * dx) + (dy * dy) <= (radius * radius));
endfunction


endpackage
