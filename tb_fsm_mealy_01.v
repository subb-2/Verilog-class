`timescale 1ns / 1ps

module tb_fsm_mealy_01();

    // 입력 신호 선언
    reg  clk;
    reg  rst;
    reg  din_bit;

    // 출력 신호 선언
    wire dout_bit;

    // DUT 인스턴스화 
    fsm_mealy_0101_hw dut (
        .clk(clk),
        .rst(rst),
        .din_bit(din_bit),
        .dout_bit(dout_bit)
    );

    always #5 clk = ~clk;

    initial begin
        // 초기값 설정
        clk = 0;
        rst = 1;
        din_bit = 0;

        // 리셋 신호
        #10;
        rst = 0;
        #10;
        // 입력 신호 패턴
        #10 din_bit = 1;
        #10 din_bit = 0;
        #10 din_bit = 1;
        #10 din_bit = 0;
        #10 din_bit = 1;
        #10 din_bit = 0;
        #20 din_bit = 1;
        #20 din_bit = 0;
        #10 din_bit = 1;
        #10 din_bit = 0;
        #20 din_bit = 1;
        #20 din_bit = 0;
        // 시뮬레이션 종료
        #100 $stop;
    end


endmodule
