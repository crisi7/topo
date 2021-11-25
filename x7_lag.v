`timescale 1ns / 1ps
module x7_lag(
    input clk,
    input rst_n,
    input [7:0]xq,
    input [7:0]xh,
    output reg[7:0]atog,
    output reg[3:0]an
);
    reg[20:0]clkdiv;
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            clkdiv<=21'd0;
        else
            clkdiv<=clkdiv+1;
    end

    wire [1:0]bitcnt;
    assign bitcnt=clkdiv[20:19];


    always @* begin
        if(!rst_n)
            an=4'd0;
        else
            an=4'd0;
            an[bitcnt]=1;
    end


    reg[3:0]digit;
    always @* begin
        if(!rst_n)
            digit=4'd0;
        else
            case (bitcnt)
                2'd0:begin
                digit=xh[3:0];
                end
                2'd1:begin
                digit=xh[7:4];
                end
                2'd2:begin
                digit=xq[3:0];
                end
                2'd3:begin
                digit=xq[7:4];
                end
                default: digit=4'd0;
            endcase
    end

    always @* begin
        if(!rst_n)
            atog=8'b11111111;
        else
            atog[7]=(an[2'd2]==1)?1:0;
            case (digit)
                0: atog[6:0]=7'b1111110;
                1: atog[6:0]=7'b0110000;
                2: atog[6:0]=7'b1101101;
                3: atog[6:0]=7'b1111001;
                4: atog[6:0]=7'b0110011;
                5: atog[6:0]=7'b1011011;
                6: atog[6:0]=7'b1011111;
                7: atog[6:0]=7'b1110000;
                8: atog[6:0]=7'b1111111;
                9: atog[6:0]=7'b1111011;
                default: atog[7:0]=7'b1111110;
            endcase
    end

endmodule