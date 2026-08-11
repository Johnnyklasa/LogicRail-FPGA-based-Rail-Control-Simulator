`timescale 1ns / 1ps

module LedTestSwitches(
    input  logic clk,
    input  logic rst,
    input  logic [5:0] sw,
    output logic ds,
    output logic shcp,
    output logic stcp
);

    logic [47:0] led_data;

    always_comb begin
        led_data = 48'b0;
        if (sw < 48) begin
            led_data[sw] = 1'b1;
        end
    end

    LED_Serializer u_serializer (
        .clk(clk),
        .rst(rst),
        .led_data(led_data),
        .ds(ds),
        .shcp(shcp),
        .stcp(stcp)
    );

endmodule