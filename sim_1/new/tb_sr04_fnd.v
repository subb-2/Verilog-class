`timescale 1ns / 1ps

module tb_sr04_fnd();

    reg clk, rst, echo, btn_r;
    wire trigger;
    wire [3:0] fnd_digit;
    wire [7:0] fnd_data;

    sr04_control_top dut (
        .clk(clk),
        .rst(rst),
        .echo(echo),
        .btn_r(btn_r),
        .trigger(trigger),
        .fnd_digit(fnd_digit),
        .fnd_data(fnd_data)
    );

    always #5 clk = ~clk;

    initial begin
        #0;
        clk = 0;
        rst = 1;
        echo = 0;
        btn_r = 0;

        #100;
        rst = 0;
        #1000;
        btn_r = 1;
        #10_000_000;
        btn_r = 0;

        #200_000;

        echo = 1;
        #580_000;
        echo = 0;
        #1_000_000;
        $stop;
    end

endmodule
