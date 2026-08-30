//Autor:Jan Rutkowski
module TimetableRAM (
    input  logic clk,
   
    input  logic we,                  
    input  logic [3:0] addr_write,     
    input  logic [7:0] train_id_in,
    input  logic [11:0] arr_time_in,
    input  logic [11:0] dep_time_in,

    input  logic [3:0] addr_read_gen,
    output logic [7:0] train_id_out_gen,
    output logic [11:0] arr_time_out_gen,
    
    input  logic [3:0] addr_read_vga,
    output logic [7:0] train_id_out_vga,
    output logic [11:0] arr_time_out_vga,
    output logic [11:0] dep_time_out_vga
    
);
    import Timetable_pkg::*;

    assign train_id_out_gen = mem_train_id[addr_read_gen];
    assign arr_time_out_gen = mem_arr_time[addr_read_gen];
    
    assign train_id_out_vga = mem_train_id[addr_read_vga];
    assign arr_time_out_vga = mem_arr_time[addr_read_vga];
    assign dep_time_out_vga = mem_dep_time[addr_read_vga];

    logic [7:0]  mem_train_id [0:SCHEDULE_SIZE-1];
    logic [11:0] mem_arr_time [0:SCHEDULE_SIZE-1];
    logic [11:0] mem_dep_time [0:SCHEDULE_SIZE-1];

 
    always_ff @(posedge clk) begin
        if (we) begin
            mem_train_id[addr_write] <= train_id_in;
            mem_arr_time[addr_write] <= arr_time_in;
            mem_dep_time[addr_write] <= dep_time_in;
        end
    end


endmodule
