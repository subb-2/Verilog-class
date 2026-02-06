`timescale 1ns / 1ps

module tb_uart_loopback();

 // uart 프레임 하나 만들어 넣어줘야지 확인 가능

    parameter BAUD = 9600;
    //parameter BIT_PERIOD = 104_160_000; //us 
    parameter BAUD_PERIOD = (100_000_000/BAUD) * 10; // 예상 = 104_160

    reg clk, rst, rx;
    wire tx;
    reg [7:0] test_data;

    integer i;

    uart_top dut (
        .clk(clk),
        .rst(rst),
        .uart_rx(rx),
        .uart_tx(tx)
    );


    always #5 clk = ~clk;

    initial begin
        #0;
        clk = 0;
        rst = 1;
        rx = 1'b1;
        test_data =  8'h30; // ascii '0'
        #20;
        repeat (5) @(posedge clk); //한 클럭 감 , 상승 엣지 5번 반복 
        rst = 1'b0; 

        //uart test pattern
        //start
        rx = 0; 
        #(BAUD_PERIOD);

        for(i = 0; i < 8; i = i+1) begin
            rx = test_data[i];

            #(BAUD_PERIOD);
        end

        //stop
        rx = 1'b1;
        #(BAUD_PERIOD);
        rx = 0;
        for(i=0;i<12;i=i+1) begin
            #(BAUD_PERIOD);
        end

        #(BAUD_PERIOD);
        $stop; 
    end

endmodule
