`timescale 1ns / 1ps

module tb_sr04_control();

    reg clk, rst, echo, btn_r;
    wire trigger;
    wire [8:0] dist;

    integer i;

    sr04_control_top dut (
        .clk(clk),
        .rst(rst),
        .echo(echo),
        .btn_r(btn_r),
        .trigger(trigger),
        .dist(dist)
    );

    always #5 clk = ~clk;

    initial begin
        #0;
        clk = 0;
        rst = 1;
        echo = 0;
        btn_r = 0;

        #10;
        rst = 0;
        #1000;
        btn_r = 1;
        #10_000_000;
        btn_r = 0;

        #10_000_000;

        echo = 1;

        #100000;
        $stop;

    end



endmodule
