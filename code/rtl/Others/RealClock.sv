module RealClock(
    input logic clk,
    input logic rst_n,
    output logic [4:0] hours,
    output logic [5:0] minutes,
    output logic minute_tick
);


localparam cyclespersecond = 40000000;

logic [4:0] hours_nxt;
logic [5:0]minutes_nxt; 
int clockcycles;

assign minute_tick = (clockcycles == (cyclespersecond * 20) - 1);

always_ff @(posedge clk or  negedge rst_n ) begin

    if(!rst_n) begin
        hours <= 1'b0;
        minutes <= 1'b0;
        clockcycles <= 0;
    end
    else begin 
        hours <= hours_nxt;
        minutes<= minutes_nxt;
        if(minute_tick)begin
            clockcycles <=0;
        end
        else begin
            clockcycles <= clockcycles+1;
        end
    end

   

end

always_comb begin
    hours_nxt = hours;
    minutes_nxt = minutes;
     if (minute_tick) begin 
        minutes_nxt = minutes +1;
    if (minutes == 59) begin
        hours_nxt = hours +1;
        minutes_nxt = 0;
    end
    end
end





endmodule
