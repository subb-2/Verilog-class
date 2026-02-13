`timescale 1ns / 1ps


module fnd_controller (
    input clk,
    input reset,
    input [8:0] fnd_in_data,
    output [3:0] fnd_digit,
    output [7:0] fnd_data
);

    wire [3:0] w_digit_1, w_digit_10, w_digit_100, w_digit_1000, w_mux_4x1_out; //bit 맞추어야 함
    wire [1:0] w_digit_sel;

    // ssign fnd_digit = 4'b1110;  // to fnd an[3:0]

    digit_splitter U_DIGIT_SPL (
        .in_data(fnd_in_data),
        .digit_1(w_digit_1),
        .digit_10(w_digit_10),
        .digit_100(w_digit_100),
        .digit_1000(w_digit_1000)
    );

   clk_div U_CLK_DIV (
        .clk(clk),
        .reset(reset),
        .o_1khz(w_1khz)
    );

    counter_4 U_COUNTER_4 (
        .clk(w_1khz),
        .reset(reset),
        .digit_sel(w_digit_sel)
    );

    Decoder2x4 U_Decoder_2x4 (
        .digit_sel  (w_digit_sel),
        .fnd_digit_D(fnd_digit)
    );

    mux_4x1 U_Mux_4x1 (
        .sel(w_digit_sel),
        .digit_1(w_digit_1),
        .digit_10(w_digit_10),
        .digit_100(w_digit_100),
        .digit_1000(w_digit_1000),
        .mux_out(w_mux_4x1_out)
    );

    bcd U_BCD (
        .bcd(w_mux_4x1_out),  //sum 8bit 중에서 4bit만 사용하겠음
        .fnd_data(fnd_data) //reg가 아니라, instance 이후 왜 wire인 것일까 bcd에서 선택되었고, controller에서는 값을 연결만 하는 것  
    );

endmodule


module clk_div (
    input  clk,
    input  reset,
    output reg o_1khz
);

    reg [ $clog2(100_000):0] counter_r;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            counter_r <= 0;
            o_1khz <= 1'b0;
        end else begin
            if (counter_r == 99999) begin
                counter_r <= 0;
                o_1khz <= 1'b1;
            end else begin
                counter_r <= counter_r + 1;
                o_1khz <= 1'b0;            
            end
        end   
    end
endmodule


module counter_4 (
    input        clk,
    input        reset,
    output [1:0] digit_sel
);

    reg [1:0] counter_r;

    assign digit_sel = counter_r;

    always @(posedge clk, posedge reset) begin
        //초기화 먼저
        if (reset == 1) begin 
            //init
            counter_r <= 0;
        end else begin
            //to do
            counter_r <= counter_r + 1;  //2bit이므로, 0~3으로만 나옴
        end
    end
endmodule

//to select to fnd digit display
module Decoder2x4 (
    input [1:0] digit_sel,
    output reg [3:0] fnd_digit_D
);
    always @(digit_sel) begin
        case (digit_sel)
            2'b00: fnd_digit_D = 4'b1110;
            2'b01: fnd_digit_D = 4'b1101;
            2'b10: fnd_digit_D = 4'b1011;
            2'b11: fnd_digit_D = 4'b0111;
        endcase
    end
endmodule


module mux_4x1 (
    input [1:0] sel,
    input [3:0] digit_1,
    input [3:0] digit_10,
    input [3:0] digit_100,
    input [3:0] digit_1000,
    output reg [3:0] mux_out
);
    always @(*) begin
        case (sel)  //선택만 하면 되는 것이므로
            2'b00: mux_out = digit_1;
            2'b01: mux_out = digit_10;
            2'b10: mux_out = digit_100;
            2'b11: mux_out = digit_1000;
        endcase
    end
endmodule


module digit_splitter (
    input  [8:0] in_data,
    output [3:0] digit_1,
    output [3:0] digit_10,
    output [3:0] digit_100,
    output [3:0] digit_1000
);

    assign digit_1 = in_data % 10;
    assign digit_10 = (in_data / 10) % 10;
    assign digit_100 = (in_data / 100) % 10;
    assign digit_1000 = (in_data/1000) % 10;

endmodule

module bcd (
    input [3:0] bcd,
    output reg [7:0] fnd_data 
);
    always @(bcd) begin
        case (bcd)
            4'd0: fnd_data = 8'hc0;
            4'd1:
            fnd_data = 8'hf9; 
            4'd2: fnd_data = 8'ha4;
            4'd3: fnd_data = 8'hb0;
            4'd4: fnd_data = 8'h99;
            4'd5: fnd_data = 8'h92;
            4'd6: fnd_data = 8'h82;
            4'd7: fnd_data = 8'hf8;
            4'd8: fnd_data = 8'h80;
            4'd9: fnd_data = 8'h90;
            default:
            fnd_data = 8'hFF;
        endcase
    end
endmodule
