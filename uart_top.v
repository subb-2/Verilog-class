`timescale 1ns / 1ps

module uart_top (
    input  clk,
    input  rst,
    input  btn_down,
    output uart_tx
);

    wire w_b_tick, w_tx_start;

    btn_debounce U_BD_TX_START(
        .clk(clk),
        .reset(rst),
        .i_btn(btn_down),
        .o_btn(w_tx_start)
    );

    uart_tx U_UART_TX (
        .clk(clk),
        .rst(rst),
        .tx_start(w_tx_start),
        .b_tick(w_b_tick),
        .tx_data(8'h30),
        .uart_tx(uart_tx)
    );

    baud_tick U_BAUD_TICK (
        .clk(clk),
        .rst(rst),
        .b_tick(w_b_tick)
    );

endmodule

module uart_tx (
    input        clk,
    input        rst,
    input        tx_start,
    input        b_tick,
    input  [7:0] tx_data,
    output       uart_tx
);

    localparam IDLE = 4'd0, WAIT = 4'd1, START = 4'd2;
    localparam BIT0 = 4'd3, BIT1 = 4'd4, BIT2 = 4'd5;
    localparam BIT3 = 4'd6, BIT4 = 4'd7, BIT5 = 4'd8;
    localparam BIT6 = 4'd9, BIT7 = 4'd10, STOP = 4'd11;

    //state 관리할 register 필요 
    //state reg
    reg [3:0] c_state, n_state;  //current, next
    reg tx_reg, tx_next;  // output을 SL로 내보내기 위함 

    assign uart_tx = tx_reg;

    //state register SL
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            c_state <= IDLE;
            tx_reg  <= 1'b1;
        end else begin
            c_state <= n_state;
            tx_reg  <= tx_next;
        end
    end

    //next CL
    //CL이 아니라 순차논리로 drive 하고 싶음 노이즈 줄이고 싶어서? 
    //피드백 구조로 순차논리가 됨 조합이 아니라 wire 
    always @(*) begin
        n_state = c_state;
        tx_next = tx_reg;
        case (c_state)
            IDLE: begin
                tx_next = 1'b1;
                if (tx_start == 1) begin
                    n_state = WAIT;
                end
            end

            WAIT: begin
                if (b_tick == 1) begin
                    n_state = START;
                end
            end

            START: begin
                //to start uart frame start bit
                tx_next = 1'b0;
                if (b_tick == 1) begin
                    n_state = BIT0;
                end
            end

            BIT0: begin
                tx_next = tx_data[0];
                if (b_tick == 1) begin
                    n_state = BIT1;
                end
            end

            BIT1: begin
                tx_next = tx_data[1];
                if (b_tick == 1) begin
                    n_state = BIT2;
                end
            end

            BIT2: begin
                tx_next = tx_data[2];
                if (b_tick == 1) begin
                    n_state = BIT3;
                end
            end

            BIT3: begin
                tx_next = tx_data[3];
                if (b_tick == 1) begin
                    n_state = BIT4;
                end
            end

            BIT4: begin
                tx_next = tx_data[4];
                if (b_tick == 1) begin
                    n_state = BIT5;
                end
            end

            BIT5: begin
                tx_next = tx_data[5];
                if (b_tick == 1) begin
                    n_state = BIT6;
                end
            end

            BIT6: begin
                tx_next = tx_data[6];
                if (b_tick == 1) begin
                    n_state = BIT7;
                end
            end

            BIT7: begin
                tx_next = tx_data[7];
                if (b_tick == 1) begin
                    n_state = STOP;
                end
            end

            STOP: begin
                tx_next = 1'b1;
                if (b_tick == 1) begin
                    n_state = IDLE;
                end
            end
        endcase
    end

endmodule

module baud_tick (
    // 주기 : 1/9600
    input      clk,
    input      rst,
    output reg b_tick
);

    //순차논리의 카운트 값으로 주기 돌리기 
    //100MHz / 9600 만큼 카운트해서 tick 1 만들기 
    parameter BAUDRATE = 9600;
    parameter F_COUNT = 100_000_000 / BAUDRATE;
    // reg for counter
    // clog2는 자동 올림되어 나타남 1.1 = 2 로 return 
    reg [$clog2(F_COUNT) - 1:0] counter_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            counter_reg <= 0;
            b_tick <= 1'b0;
        end else begin
            counter_reg <= counter_reg + 1;
            if (counter_reg == (F_COUNT - 1)) begin
                counter_reg <= 0;
                b_tick <= 1'b1;
            end else begin
                b_tick <= 1'b0;
            end
        end
    end

endmodule
