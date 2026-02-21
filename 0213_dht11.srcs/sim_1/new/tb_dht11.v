`timescale 1ns / 1ps

module tb_dht11 ();

    reg clk, rst, btn_r_start;
    wire       dht_valid;
    wire [3:0] dht_debug_led;
    reg dht11_sensor_io, sensor_io_sel;
    reg     [39:0] dht11_sensor_data;
    wire           dhtio;
    wire    [ 3:0] fnd_digit;
    wire    [ 7:0] fnd_data;

    integer i;

    assign dhtio = (sensor_io_sel) ? 1'bz : dht11_sensor_io;

    dht11_top dut (
        .clk(clk),
        .rst(rst),
        .btn_r_start(btn_r_start),
        .dht_valid(dht_valid),
        .dht_debug_led(dht_debug_led),
        .dhtio(dhtio),
        .fnd_digit(fnd_digit),
        .fnd_data(fnd_data)
    );

    // dht11_controller dut (
    //     .clk(clk),
    //     .rst(rst),
    //     .start(start),
    //     .humidity(),
    //     .temperature(),
    //     .dht11_done(),
    //     .dht11_valid(),
    //     .debug(),
    //     .dhtio(dhtio)       
    // );

    always #5 clk = ~clk;

    initial begin
        #0;
        clk = 0;
        rst = 1;
        btn_r_start = 0;
        i = 0;
        dht11_sensor_io = 1'b0;
        sensor_io_sel = 1'b1;
        //huminity integral, decimal, temperature integral, decimal. checksum
        dht11_sensor_data = {8'h32, 8'h00, 8'h19, 8'h00, 8'h4b};
        //저쪽에서 나오고 있으니까 테스트는 끊어놓는 것 
        //동시에 나가면 X 나옴 

        //reset
        #20;
        rst = 0;
        #20;
        btn_r_start = 1;
        #1_000_000;
        btn_r_start = 0;

        //19msec + 30usec
        //저쪽에서 끊으니까 내가 넣어줘야 함
        //start signal + wait
        #(1900 * 10 * 1000 + 30_000);

        //to output, sensor to fpga
        sensor_io_sel   = 0; 

        //sync_L, sync_H
        dht11_sensor_io = 1'b0;
        #(80_000);
        dht11_sensor_io = 1'b1;
        #(80_000);

        //40bit data pattern

        for (i = 39; i >= 0; i = i - 1) begin
            //data sync
            dht11_sensor_io = 1'b0;
            #(50_000);
            //data value
            if (dht11_sensor_data[i] == 0) begin
                dht11_sensor_io = 1'b1;
                #(28_000);
            end else begin
                dht11_sensor_io = 1'b1;
                #(70_000);
            end
        end

        dht11_sensor_io = 1'b0;
        #(50_000);

        //to output, fpga to sensor
        sensor_io_sel = 1;

        #100_000;

        $stop;
    end

endmodule
