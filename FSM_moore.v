`timescale 1ns / 1ps

module FSM_moore(
    input clk,
    input reset,
    input sw,
    output led
    );

    // state 
    parameter s0 = 1'b0, s1 = 1'b1; //state 이름으로 표현하는 것이 좋기 때문

    // state variable 
    reg current_state, next_state; //state 1bit 
    
    //state register SL
    //입력 next 출력 current
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            current_state <= s0;
            // 출력만 초기화 
        end else begin
            current_state <= next_state;
            //ff 1개
        end
    end

    //next state CL
    //CL은 blocking **
    //nonblocking 하고 싶으면, SL에 같이 제작하기 
    always @(*) begin
        next_state = current_state; //초기화 
        case (current_state)
            s0: begin
                if (sw == 1'b1) begin
                    next_state = s1;
                    
                end
            end 
            s1: begin
                if (sw == 1'b0) begin
                    next_state = s0;
                end
            end
            default: next_state = current_state; // Latch 없애기 위해 꼭 필요함 그리고 초기화도 필요 
        endcase
    end

    //output CL
    assign led = (current_state == s1) ? 1'b1 : 1'b0;

endmodule
