`timescale 1ns / 1ps


module distance_counter (
    input clk,
    input rst,
    output [3:0] fnd_digit,
    output [7:0] fnd_data
);


    wire [13:0]w_counter_10000;
    wire w_tick_10us;

    tick_gen_10us U_TICK_GEN(
    .clk(clk),
    .rst(rst),
    .o_tick_10us(w_tick_10us)
    );


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
        .i_tick(w_tick_10hz),
        .digit_splitter(w_counter_10000)
        );
   
endmodule

module tick_gen_10us (
    input clk,
    input rst,
    output reg o_tick_10us 
);
    reg [$clog2(1000)-1:0] r_counter;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            r_counter <= 0;
            o_tick_10us <= 1'b0;
        end else begin
            r_counter <= r_counter + 1;
            if (r_counter == (1000 - 1)) begin
                r_counter <= 0;
                o_tick_10us <= 1'b1;
            end else begin
                o_tick_10us<= 1'b0;
            end
        end
    end
endmodule


module counter_10000 (
    input        clk,
    input        reset,
    input        i_tick,
    output [13:0] digit_splitter
);


    reg [13:0] counter_r;


    assign digit_splitter = counter_r;


    always @(posedge clk, posedge reset) begin
       
        if (reset == 1) begin
            counter_r <= 14'd0;
        end else begin
            //to do
            if (i_tick) begin
                counter_r <= counter_r + 1;  
            end
            
            if(counter_r == (10000 - 1)) begin
                counter_r <= 14'd0;
            end
        end
    end
endmodule

