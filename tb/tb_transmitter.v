`timescale 1ns/1ps

module tb_transmitter;

reg clk, rst_n, s_tick, start;
reg [7:0] dlv;

wire tx_busy, serialout;

Transmitter dut (
    .clk(clk),
    .rst_n(rst_n),
    .s_tick(s_tick),
    .start(start),
    .dlv(dlv),
    .tx_busy(tx_busy),
    .serialout(serialout)
);

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

task reset;
begin
    rst_n = 1'b0;
    #10;
    rst_n = 1'b1;
end
endtask

initial
begin
    s_tick = 1'b0;
    forever
    begin
        #10 s_tick = 1'b1;
        #40 s_tick = 1'b0;
    end
end


initial
begin
    start = 1'b0;
    dlv = 8'b10101010;

    reset();

    #10;
    start = 1'b1;
    #10;
    start = 1'b0;

    wait(tx_busy == 1'b0);
    #100;
    $finish;
end

initial
begin
    $dumpfile("song_uart.vcd");
    $dumpvars(0, tb_transmitter);
end

endmodule
