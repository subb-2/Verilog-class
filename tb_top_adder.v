`timescale 1ns / 1ps

module tb_top_adder();

    reg [7:0] a, b;
    wire [3:0] fnd_digit;
    wire [7:0] fnd_data;
    wire clk;
    wire c; 


        integer i = 0, j = 0; 

        top_adder dut (
            .clk(clk),
            .reset(reset),
            .a(a),
            .b(b),
            .fnd_digit(fnd_digit),
            .fnd_data(fnd_data),
            .c(c) 
        );


        //init
        initial begin
            #0;
            a = 8'b0000_0000; 
            b = 8'b0000_0000;
            #10;

            for ( i = 0; i < 256; i = i + 1 ) begin
                for ( j = 0 ; j < 256 ; j = j + 1 ) begin
                    a = i;
                    b = j;
                    #10;
                end
                
            end

            
            $stop; // 시뮬 멈추는 것, 뒤에 더 볼 수 있음 

            #10000;
            $finish; // 더 이상 시뮬 안하겠다는 선언
        end

endmodule
