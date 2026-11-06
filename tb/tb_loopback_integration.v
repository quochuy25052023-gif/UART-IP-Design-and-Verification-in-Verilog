`timescale 1ns/1ps
module tb_loopback_integration;
reg clk, rst_n;
wire s_tick;
wire tx2rx;
  baud_rate_generator #(.fclk(2000) , .Baudrate(25) , .k(16) )dut ( .clk(clk), .rst_n(rst_n), .s_tick(s_tick) );

reg start;
reg [7:0] dlv;
wire tx_busy, serialout;
Transmitter dut_tx(.clk(clk), .rst_n(rst_n), .s_tick(s_tick), .start(start), .dlv(dlv) , .tx_busy(tx_busy) , .serialout(tx2rx) );


wire [7:0] dout;
Receiver dut_rx( .clk(clk) , .rst_n(rst_n) , .s_tick(s_tick) , .rx(tx2rx) , .dout(dout) );


task reset();
begin
rst_n = 1'b0;
#10;
rst_n = 1'b1;
end
endtask

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk; 
end



reg [4:0] pass_count = 0;
reg [4:0] fail_count = 0;
integer i;

initial 
begin
//đầu tiên vô thì phải reset trước
reset();
for( i = 0; i < 5 ; i = i + 1)
begin
 dlv=$urandom();
start=1'b1;
#20;
start=1'b0; // để mà không cho nó chạy liên tiếp với giá trị dữ liệu đầu vào cũ
  wait(dut_rx.rx_done_tick === 1'b1); #1;
if(dout === dlv)
begin
 pass_count = pass_count + 1'b1;
  $display("[PASS]  ;Time=%0t; dlvao =%h; dlnhan =%h ", $time, dlv, dout);
end
else
begin
 fail_count = fail_count + 1'b1;
  $display("[ERROR]  ;Time=%0t; dlvao =%h; dlnhan =%h ",$time, dlv, dout);
end
  wait(dut_tx.tx_busy === 1'b0);
end
  
 $display("=== TONG KET: PASS: %0d | FAIL: %0d ===", pass_count, fail_count);
$finish;
end
endmodule
