`timescale 1ns / 1ps

module fsm_2 (
    input        clk,
    input        reset,
    input  [2:0] sw,
    output [2:0] led
);

    //parameter : state
    parameter s0 = 3'd0, s1 = 3'd1, s2 = 3'd2, s3 = 3'd3, s4 = 3'd4;

    //state reg varialbe 
    reg [2:0] current_state, next_state;
    reg [2:0] current_led, next_led;

    //output
    assign led = current_led;  //next는 업데이트 전이므로 

    //state register : positive edge 에서 current를 next로 update 
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            current_state <= s0;
            current_led   <= 3'b000;
        end else begin
            current_state <= next_state;
            current_led <= next_led; //SL로 내보내기 위해 피드백 구조로 만들어야 함, 이렇게 같이 제작 가능, 아니면 Latch 발생
            //따로 피드백 받는 구조를 만들 수도 있지만, 너무 길어짐 
        end
    end

    //next state CL
    always @(*) begin
        //구문 시작 초기화 tihs always initialize 
        next_state = current_state; //무조건 이렇게 초기화 하는 것은 아니고 이 예제여서 그런 것 
        //led CL output 
        next_led = current_led;
        case (current_state)  //현재 상태를 보고 입력이 조건 역할 
            s0: begin
                //output 
                next_led = 3'b000;
                if (sw == 3'b001) begin
                    next_state = s1;
                end else if (sw == 3'b010) begin
                    next_state = s2;
                end else begin
                    next_state = current_state;
                end
            end
            s1: begin
                next_led = 3'b001;
                if (sw == 3'b010) begin
                    next_state = s2;
                end else begin
                    next_state = current_state;
                end
            end
            s2: begin
                next_led = 3'b010;
                if (sw == 3'b100) begin
                    next_state = s3;
                end else begin
                    next_state = current_state;
                end
            end
            s3: begin
                next_led = 3'b100;
                if (sw == 3'b011) begin
                    next_state = s1;
                end else if (sw == 3'b111) begin
                    next_state = s4;
                end else if (sw == 3'b000) begin
                    next_state = s0;
                end else begin
                    next_state = current_state;
                end
            end
            s4: begin
                next_led = 3'b111;
                if (sw == 3'b000) begin
                    next_state = s0;
                end else begin
                    next_state = current_state;
                end
            end

            default: next_state = current_state;
        endcase
    end

    //output CL : LED 
    //assign led = (current_state == s1) ? 2'b01:
    //            (current_state == s2) ? 2'b11 : 1'b00;
    //always @(*) begin
    //    case (current_state)
    //        s0: led = 3'b000;
    //        s1: led = 3'b001;
    //        s2: led = 3'b010;
    //        s3: led = 3'b110;
    //        s4: led = 3'b111;
    //        default: led = 2'b00;
    //    endcase
    //end

endmodule
