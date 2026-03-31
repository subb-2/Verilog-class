`timescale 1ns / 1ps

module tb_stopwatch_watch ();

    // 입력 신호 선언
    reg        clk;
    reg        reset;
    reg  [3:0] sw;
    reg        btn_r;
    reg        btn_l;
    reg        btn_u;
    reg        btn_d;

    // 출력 신호 관찰
    wire [3:0] fnd_digit;
    wire [7:0] fnd_data;




    // DUT (Device Under Test) 인스턴스화
    top_stopwatch_watch dut (
        .clk(clk),
        .reset(reset),
        .sw(sw),
        .btn_r(btn_r),
        .btn_l(btn_l),
        .btn_u(btn_u),
        .btn_d(btn_d),
        .fnd_digit(fnd_digit),
        .fnd_data(fnd_data)
    );


    // 100MHz 클락 생성 (10ns 주기)
    always #5 clk = ~clk;


    initial begin
        #0;
        clk = 0;
        reset = 1;

        sw = 4'b0000;
        btn_r = 0;
        btn_l = 0;
        btn_u = 0;
        btn_d = 0;


        #10;
        reset = 0;
        #20;


        //스톱워치 동작 테스트
        sw[0] = 1;  // up 모드
        sw[1] = 1;  // 스톱워치 선택
        sw[2] = 0;  // 초.밀리초 모드


        #10000000;
        
        btn_r = 1;
        #10;
        btn_r = 0;
        #20;
        btn_r = 1;
        #10;
        btn_r = 0;
        #10;
        btn_r = 1;
        #10;
        btn_r = 0;

        #10;
        btn_r = 1;

        #1000000;
        btn_r = 0;


        #10000000;
        $stop;
    end




endmodule
