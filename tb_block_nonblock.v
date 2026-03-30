`timescale 1ns / 1ps

module tb_block_nonblock();

    reg a, b, c;
    initial begin
        #0;
        //blocking : 한 줄씩 처리 
        a = 1;
        b = 0;
        #10;
        a = b; // a = 0
        b = a; //위에서 a = 0으로 변경 : b = 0 
        c = a + b; // c = 0 
        #10;
        //non blocking : 병렬 처리 
        a = 1;
        b = 0;
        #10;
        a <= b;
        b <= a;
        c <= a + b;
        #10;
        $stop;
    end
endmodule
