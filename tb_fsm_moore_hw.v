`timescale 1ns / 1ps

module tb_fsm_moore_hw();

reg clk, rst;
reg din_bit;
wire dout_bit;

    fsm_moore_hw dut(
    .clk(clk),
    .rst(rst),
    .din_bit(din_bit),
    .dout_bit(dout_bit)
);

    always #5 clk = ~clk;

    initial begin
        #0;
        clk = 0;
        rst = 1;
        din_bit = 1'b0;

        #10;
        rst = 0;
        din_bit = 1'b0;

        #10;
        din_bit = 1'b1;

        #10;
        din_bit = 1'b0;

        #10;
        din_bit = 1'b1;

        #10;
        din_bit = 1'b1;

        #10;
        din_bit = 1'b0;

        #10;
        din_bit = 1'b0;

        #10;
        din_bit = 1'b1;

        #10;
        din_bit = 1'b0;

        #10;
        din_bit = 1'b0;

        #10;
        din_bit = 1'b1;

        #10;
        din_bit = 1'b1;

        #10;
        din_bit = 1'b0;

        #10;
        din_bit = 1'b1;

        #10;
        din_bit = 1'b0;

        #10;
        din_bit = 1'b1;

        #10;
        din_bit = 1'b0;

        #20;
        $stop;

    end

endmodule
