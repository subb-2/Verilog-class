`timescale 1ns / 1ps

module fsm_moore_hw(
    input clk,
    input rst,
    input din_bit,
    output dout_bit
);

parameter s0 = 3'd0, s1 = 3'd1, s2 = 3'd2, s3 = 3'd3, s4 = 3'd4;

reg [2:0] current_state, next_state;
reg [2:0] current_out, next_out;

assign dout_bit = current_out;

always @(posedge clk, posedge rst) begin
    if (rst) begin
        current_state <= s0;
        current_out <= 1'b0;
    end else begin
        current_state <= next_state;
        current_out <= next_out;
    end
end

always @(*) begin
    next_state = current_state;
    next_out = current_out;
    case (current_state)
        s0: begin
            next_out = 1'b0;
            if (din_bit == 1'b0) begin
                next_state = s1;
            end else begin
                next_state = current_state;
            end
        end 

        s1: begin
            next_out = 1'b0;
            if (din_bit == 1'b1) begin
                next_state = s2;                
            end else begin
                next_state = current_state;
            end
        end

        s2: begin
            next_out = 1'b0;
            if (din_bit == 1'b0) begin
                next_state = s3; 
            end else begin
                next_state = s0;
            end
        end

        s3: begin
            next_out = 1'b0;
            if (din_bit == 1'b1) begin
                next_state = s4;
            end else begin
                next_state = s1;
            end
        end

        s4: begin
            next_out = 1'b1;
            if (din_bit == 1'b0) begin
                next_state = s1;
            end else begin
                next_state = s0;
            end
        end

        default: next_state = current_state;
    endcase

end



endmodule
