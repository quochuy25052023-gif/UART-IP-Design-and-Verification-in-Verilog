`timescale 1ns/1ps
module tb_receiver;
reg clk, rst_n, s_tick, rx;
wire [7:0] dout;

Receiver dut (
    .clk(clk),
    .rst_n(rst_n),
    .s_tick(s_tick),
    .rx(rx),
    .dout(dout)  );

initial
begin
    clk = 1'b0;
    forever #5 clk = ~clk; 
end

task reset();
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
#40 s_tick=1'b1;
#10 s_tick=1'b0;
end
end
// >>> 1 nhịp s_tick là 50ns >>> ta có 10 bit( 1 start , 8 data , 1 stop) , mà mỗi bit cần 16 nhịp s_tick >>> 10*50*16=8000ns

// Khai báo thời gian 1 bit (Dựa trên 16 nhịp s_tick)
parameter BIT_PERIOD = 800; // 16 * 50ns

task gui_1_byte(input [7:0] data_in);
    integer i;
    begin
        // 1. Kéo rx xuống 0 để tạo Start bit
        rx = 0;
        #BIT_PERIOD; 

        // 2. Dùng vòng lặp for để bơm 8 bit dữ liệu vào dây rx (truyền bit LSB trước)
        for (i = 0; i < 8; i = i + 1) begin
            rx = data_in[i]; // Gán bit thứ i vào dây rx
            #BIT_PERIOD;     // Giữ nguyên mức điện áp đó trong thời gian 1 bit
        end

        // 3. Kéo rx lên 1 để tạo Stop bit
        rx = 1;
        #BIT_PERIOD;
    end
endtask


 integer pass_count = 0;
integer fail_count = 0;
reg [7:0] expected_data;
 integer i;
initial begin
    // ... khởi tạo và reset mạch ...
     rx=1'b1;
  reset();
  #200;
    // Chạy vòng lặp test 10 số ngẫu nhiên
    for (i = 0; i < 10; i = i + 1) begin
        expected_data = $urandom(); // Lấy 1 số ngẫu nhiên 32-bit, tự ép kiểu về 8-bit
        
        $display("Dang truyen byte: %h", expected_data);
        gui_1_byte(expected_data); // Đẩy dữ liệu vào dây rx
        // Chờ thêm 1 tí xíu (vd 1ns) để dữ liệu dout thực sự chốt ổn định
        #1; 
        
        // Scoreboard - Chấm điểm tự động
        if (dout === expected_data) begin
            $display("[PASS] Time=%0t | Expected=%h | Actual=%h", $time, expected_data, dout);
            pass_count = pass_count + 1;
        end else begin
            $display("[ERROR] Time=%0t | Expected=%h | Actual=%h", $time, expected_data, dout);
            fail_count = fail_count + 1;
        end
        
        #1000; // Nghỉ ngơi 1 chút trước khi truyền byte tiếp theo
    end
    
    // In tổng kết
    $display("=== TONG KET: PASS: %0d | FAIL: %0d ===", pass_count, fail_count);
    $finish;
end
endmodule
