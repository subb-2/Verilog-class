`timescale 1ns / 1ps

module fsm_mealy_0101_hw(
        input clk,
        input rst,
        input din_bit,
        output dout_bit
    );

    reg [2:0] state_reg, next_state;

    parameter start = 3'd5;
    parameter s0 = 3'd0;
    parameter s1 = 3'd1;
    parameter s2 = 3'd2;
    parameter s3 = 3'd3;

    always @(state_reg or din_bit) begin
        case (state_reg)
            start: if (din_bit == 0) begin
                next_state = s0;
            end else if (din_bit == 1) begin
                next_state = s0;
            end else begin
                next_state = start;
            end

            s0: if (din_bit == 0) begin
                next_state = s1;
            end else if (din_bit == 1) begin
                next_state = s0;
            end else begin
                next_state = start;
            end

            s1: if (din_bit == 0) begin
                next_state = s1;
            end else if (din_bit == 1) begin
                next_state = s2;
            end else begin
                next_state = start;
            end

            s2: if (din_bit == 0) begin
                next_state = s3;
            end else if (din_bit == 1) begin
                next_state = s0;
            end else begin
                next_state = start;
            end

            s3: if (din_bit == 0) begin
                next_state = s1;
            end else if (din_bit == 1) begin
                next_state = s0;
            end else begin
                next_state = start;
            end

            default: next_state = start;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst == 1) begin
            state_reg <= start;
        end else begin
            state_reg <= next_state;
        end
    end

    assign dout_bit = ((state_reg == s3) && (din_bit == 1)) ? 1 : 0;

endmodule
