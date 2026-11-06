module uart_top (
    input  wire       clk,
    input  wire       rst_n,
    
    //  (Transmitter)
    input  wire       start,
    input  wire [7:0] dlv,
    output wire       tx_busy,
    output wire       serialout,
    
    //  (Receiver)
    input  wire       rx,
    output wire [7:0] dout,
    output wire       rx_done_tick,
    output wire       framing_error
);

    // Dây nối nội bộ duy nhất bên trong hộp uart_top
    wire s_tick;

    //Gọi khối baud_rate_generator
    baud_rate_generator t1 (.clk(clk) , .rst_n(rst_n) , .s_tick(s_tick) );

    //Gọi khối Transmitter
    Transmitter t2( .clk(clk) , .rst_n(rst_n) ,.s_tick(s_tick), .start(start) ,.dlv(dlv) ,.tx_busy(tx_busy) ,.serialout(serialout) );

    //Gọi khối Receiver
    Receiver t3 ( .clk(clk) , .rst_n(rst_n) , .s_tick(s_tick) , .rx(rx) , .rx_done_tick(rx_done_tick) ,  .framing_error(framing_error) , .dout(dout) );  
endmodule
