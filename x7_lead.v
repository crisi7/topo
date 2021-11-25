`timescale 1ns / 1ps
module x7_lead(
    input clk,
    input rst_n,
    input [7:0]xq,
    input [7:0]xh,
    input [2:0]cstate_in,
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
                2'd0:digit=xh[3:0];
                2'd1:digit=xh[7:4];
                2'd2:digit=(xq[7:4]<xq[3:0])?xq[7:4]:xq[3:0];
                2'd3:begin
                if(cstate_in==3'b000)digit=10;
                else if(cstate_in==3'b001)digit=11;
                else if(cstate_in==3'b011)digit=12;
                else if(cstate_in==3'b010)digit=13;
                else if(cstate_in==3'b110)digit=14;
                end
//                WORK_INIT=3'b000,
//                REST_INIT=3'b001,
//                COUNT=3'b011,
//                PAUSE=3'b010,
//                SET_TIME=3'b110,          
                default: digit=4'd0;
            endcase
    end

    always @* begin
        if(!rst_n)
            atog=7'b1111111;
        else
                // set the point of x7seg to seperate
                atog[7]=(an[2'd0]==1||an[2'd2]==1||an[2'd3]==1)?1:0;
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
                
                10:atog[6:0]=7'b1011100;    //WORK_INIT display w
                11:atog[6:0]=7'b0000101;    //REST_INIT display r
                12:atog[6:0]=7'b0001101;    //COUNT display c
                13:atog[6:0]=7'b1100111;    //PAUSE display p
                14:atog[6:0]=7'b1010011;    //SET_TIME  display s

                default: atog[6:0]=7'b1111110;
            endcase
    end

endmodule