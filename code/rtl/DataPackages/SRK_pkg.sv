
package SRK_pkg;

//parameters
localparam SemaforWidth = 16;
localparam SemaforHeight = 50;
localparam LedDiameter = 10;



//functions

function automatic logic DrawRect(
    input int x_pos, 
    input int y_pos, 
    input int rectX, 
    input int rectY, 
    input int Width, 
    input int Height
);
    return ((x_pos >= rectX) && (x_pos <= rectX + Width) && (y_pos >= rectY) &&( y_pos <= rectY + Height));
endfunction

function automatic logic DrawCircle(
    input int x_pos, 
    input int y_pos, 
    input int circleX,
    input int circleY, 
    input int radius
    );
    int dx;
    int dy;
    
    dx = x_pos - circleX;
    dy = y_pos - circleY;
    
    return ((dx * dx) + (dy * dy) <= (radius * radius));
endfunction


endpackage
