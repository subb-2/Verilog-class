`timescale 1ns / 1ps


module top_10000_counter (
    input clk,
    input reset,
    output [3:0] fnd_digit,
    output [7:0] fnd_data
);


    wire [13:0]w_counter_10000;


    fnd_controller U_FND_CNTL(
        .clk(clk),
        .reset(reset),
        .fnd_in_data(w_counter_10000),
        .fnd_digit(fnd_digit),
        .fnd_data(fnd_data)
        );


    counter_10000 U_COUNTER_10000 (
        .clk(clk),
        .reset(reset),
        .counter(w_counter_10000)
        );
   
endmodule


module counter_10000 (
    input        clk,
    input        reset,
    output [13:0] counter
);


    reg [13:0] counter_r;


    assign counter = counter_r;


    always @(posedge clk, posedge reset) begin
       
        if (reset == 1) begin
            counter_r <= 14'd0;
        end else begin
            //to do
            counter_r <= counter_r + 1;  
            if(counter_r == (10000 - 1)) begin
                counter_r <= 14'd0;
            end
        end
    end
endmodule