module baud_rate_generator #(parameter fclk=50000000, parameter Baudrate=115200, parameter k=16)(input clk, rst_n, output reg s_tick);
localparam N = fclk/(Baudrate*k);
localparam demwidth = $clog2(N);
reg [demwidth-1:0] counter;
always@( posedge clk, negedge rst_n)
begin
if(!rst_n)
begin
counter <= {demwidth{1'b0}};
s_tick <= 1'b0;
end
else
begin
if(counter >= N -1)
begin
counter <= {demwidth{1'b0}};
s_tick <= 1'b1;
end
else
begin
counter <= counter + 1'b1;
s_tick <= 1'b0;
end
end
end
endmodule
