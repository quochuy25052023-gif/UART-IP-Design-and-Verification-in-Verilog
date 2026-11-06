module Transmitter(
    input clk, rst_n, s_tick, start,
    input [7:0] dlv,
    output reg tx_busy,
    output reg serialout
);

parameter [1:0] IDLE = 2'b00,
                START = 2'b01,
                DATA = 2'b10,
                STOP = 2'b11;

reg [1:0] ttht;
reg [7:0] thghitam;
reg [3:0] demnhip;
reg [2:0] dembit;

always @(posedge clk or negedge rst_n)
begin
    if (!rst_n)
    begin
        ttht <= IDLE;
        thghitam <= 8'd0;
        demnhip <= 4'd0;
        tx_busy <= 1'b0;
        serialout <= 1'b1;
        dembit <= 3'd0;
    end
    else
    begin
        case (ttht)

            IDLE:
            begin
                if (start == 1'b1)
                begin
                    tx_busy <= 1'b1;
                    thghitam <= dlv;
                    ttht <= START;
                    demnhip <= 4'd0;
                    dembit <= 3'd0;
                    serialout <= 1'b0;
                end
                else
                begin
                    serialout <= 1'b1;
                    tx_busy <= 1'b0;
                end
            end

            START:
            begin
                serialout <= 1'b0;

                if (s_tick)
                begin
                    if (demnhip >= 4'd15)
                    begin
                        demnhip <= 4'd0;
                        ttht <= DATA;
                    end
                    else
                    begin
                        demnhip <= demnhip + 1'b1;
                    end
                end
            end

            DATA:
            begin
                serialout <= thghitam[0];

                if (s_tick)
                begin
                    if (demnhip >= 4'd15)
                    begin
                        demnhip <= 4'd0;
                        thghitam <= thghitam >> 1;

                        if (dembit >= 3'd7)
                        begin
                            dembit <= 3'd0;
                            ttht <= STOP;
                        end
                        else
                        begin
                            dembit <= dembit + 1'b1;
                        end
                    end
                    else
                    begin
                        demnhip <= demnhip + 1'b1;
                    end
                end
            end

            STOP:
            begin
                serialout <= 1'b1;

                if (s_tick)
                begin
                    if (demnhip >= 4'd15)
                    begin
                        demnhip <= 4'd0;
                        tx_busy <= 1'b0;
                        ttht <= IDLE;
                    end
                    else
                    begin
                        demnhip <= demnhip + 1'b1;
                        tx_busy <= 1'b1;
                    end
                end
            end

            default:
            begin
                tx_busy <= 1'b0;
                ttht <= IDLE;
                serialout <= 1'b1;
                demnhip <= 4'd0;
                dembit <= 3'd0;
            end

        endcase
    end
end

endmodule
