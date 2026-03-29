`timescale 1ns / 1ps

module tb_fsm_2();

reg clk, reset;
reg [2:0] sw;
wire [2:0] led;

    fsm_2 dut (
        .clk(clk),
        .reset(reset),
        .sw(sw),
        .led(led)
    );

    always #5 clk = ~clk;

    initial begin
        #0;
        clk = 0;
        reset = 1;
        sw = 3'b000;

        #10;
        reset = 0;
        sw = 3'b001;
        #10;
        sw = 3'b010;
        #10;
        sw = 3'b100;
        #10;
        sw = 3'b011;
        #10;
        sw = 3'b010;
        #10;
        sw = 3'b100;
        #10;
        sw = 3'b000;
        #10;
        sw = 3'b010;
        #10;
        sw = 3'b100;
        #10;
        sw = 3'b111;
        #10;
        sw = 3'b000;
        #20;
        $stop;
    end

endmodule
