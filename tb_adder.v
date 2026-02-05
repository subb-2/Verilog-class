`timescale 1ns / 1ps

module tb_adder();


    //tb_adder local variable 
    reg a, b, cin;
    wire sum, carry;
    
    //Instanciate_half_adder
 //   half_adder dut ( // dut : instanciate name : design under test 
 //       .a(a),
 //       .b(b),
 //       .sum(sum), 
//      .carry(carry)
 //  );

    //instanciate full adder
module full_adder dut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .c(carry)
);


    //init
    initial begin
        #0;
        a = 0;
        b = 0;
        cin = 0;

        #10;
        a = 1;
        b = 0;
        cin = 0;
       
        #10;
        a = 0;
        b = 1;
        cin = 0;
        
        #10;
        a = 1;
        b = 1;
        cin = 0;

        #0;
        a = 0;
        b = 0;
        cin = 1;

        #10;
        a = 1;
        b = 0;
        cin = 1;
       
        #10;
        a = 0;
        b = 1;
        cin = 1;
        
        #10;
        a = 1;
        b = 1;
        cin = 1;
        
        #10;
        $stop; // 시뮬 멈추는 것, 뒤에 더 볼 수 있음 

        #100;
        $finish; // 더 이상 시뮬 안하겠다는 선언
    end


endmodule
