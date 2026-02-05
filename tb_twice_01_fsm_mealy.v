`timescale 1ns / 1ps

module tb_twice_01_fsm_mealy();

    reg clk, rst, din_bit;
    wire dout_bit;

    FSM_Mealy dut(
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
        din_bit = 0;

        #20;
        rst = 0;
        din_bit = 1;

        #20;
        din_bit = 0;
        
        #20;
        din_bit = 1;

        #20;
        din_bit = 1;

        #20;
        din_bit = 0;

        #20;
        $stop;

    end

endmodule
