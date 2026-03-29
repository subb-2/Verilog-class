`timescale 1ns / 1ps

module tb_adder_fnd();

    reg clk, reset;
    reg  [7:0] a,b;
    wire [7:0] fnd_data;
    wire [3:0] fnd_digit;
    wire c;


    top_adder dut(
        .clk(clk),
        .reset(reset),
        .a(a),
        .b(b),
        .fnd_digit(fnd_digit),
        .fnd_data(fnd_data),
        .c(c)
    );


    always #5 clk = ~clk;


    initial begin
        #0;
        clk = 0;
        reset = 1;
        a = 0;
        b = 0;
        #20;
        reset = 0;
        #100_000;
        $stop;

    end


endmodule


