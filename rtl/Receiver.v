module Receiver(input clk, rst_n , s_tick, rx, output reg rx_done_tick,  framing_error,output reg [7:0] dout);
reg [1:0] ttht ;
reg rx_sync1 , rx_sync2;

// Khối tạo 2 D-Flip-Flop mắc nối tiếp để chống Metastability
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        rx_sync1 <= 1'b1; // Khởi tạo mức 1 (trạng thái IDLE của UART)
        rx_sync2 <= 1'b1;
    end 
    else begin
        rx_sync1 <= rx;       // FF1 lấy mẫu chân rx bên ngoài
        rx_sync2 <= rx_sync1; // FF2 nhận giá trị ổn định từ FF1
    end
end

parameter [1:0] IDLE=2'b00, START=2'b01 , DATA=2'b10 , STOP=2'b11;
reg [7:0] tgtam;
reg [3:0] demtick;
reg [2:0] dembit;
always @(posedge clk or negedge rst_n)
begin
if(!rst_n)
begin
tgtam <= 8'd0;
rx_done_tick <= 1'b0;
framing_error <= 1'b0;
dout <= 8'd0;
ttht <= IDLE;
demtick <= 4'd0;
dembit <= 3'd0;
end
else begin
case(ttht)
IDLE:
begin
rx_done_tick <= 1'b0;
if(rx_sync2 == 1'b0) ttht <= START; end
START:
begin
if(s_tick) begin
if(demtick == 4'd7)
begin
if(rx_sync2 == 1'b0)
begin
demtick <= 4'd0;
ttht <= DATA;
end
else
begin
demtick <= 4'd0;
ttht <= IDLE;
end
end
else demtick <= demtick + 1'b1;
end
end
DATA:
begin
if(s_tick)
begin
if(demtick == 4'd15)
begin
demtick <= 4'd0;
tgtam <= { rx_sync2, tgtam[7:1] };
if(dembit == 3'd7)
begin
dembit <= 3'd0;
ttht <= STOP;
end
else dembit <= dembit + 1'b1;
end
else demtick <= demtick +1'b1;
end
end
STOP:
begin
if(s_tick)
begin
if(demtick == 4'd15)
begin
demtick <= 4'd0;
ttht <= IDLE;
if(rx_sync2 == 1'b1)
begin
rx_done_tick <= 1'b1;
dout <= tgtam;
framing_error <= 1'b0;
end
else
begin
framing_error <= 1'b1;
rx_done_tick <= 1'b0;
end
end
else demtick <= demtick + 1'b1;
end
end
default:
begin
    ttht <= IDLE;
    demtick <= 4'd0;
    dembit <= 3'd0;
    rx_done_tick <= 1'b0;
    framing_error <= 1'b0;
end
endcase
end
end
endmodule
