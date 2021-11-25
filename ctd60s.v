`timescale 1ns / 1ps
module ctd60s(
    input clk,
    input pulse_in,
    input rst_n,
    input cnt_en,
    input load,
    output [7:0]x,
    output reg borrow
    );
    //0.47
    reg [3:0] sec_H=0,sec_L=0;

    always @(posedge clk,negedge rst_n) begin
        if(!rst_n)begin
            sec_L<=0;
            sec_H<=0;
        end
        else if(pulse_in&&sec_L==0&&sec_H==0&&(cnt_en==1)&&load==0)begin
                sec_L<=9;
                sec_H<=5; 
        end
        else if(pulse_in&&sec_L==0&&sec_H!=0&&(cnt_en==1)&&(load==0))begin
            sec_L<=9;
            sec_H<=sec_H-1;
        end
        else if(pulse_in&&(cnt_en==1)&&(load==0))begin
            sec_L<=sec_L-1;
            sec_H<=sec_H; 
        end
//        else if(cnt_en==0&&load==1)begin
//            sec_L<=0;
//            sec_H<=0;
//        end
        else begin
            sec_L<=sec_L;
            sec_H<=sec_H;
        end 
    end

    always @(posedge clk,negedge rst_n) begin
        if(!rst_n)  borrow<=0;
        else if(pulse_in&&sec_H==0&&sec_L==0)borrow<=1;
        else borrow<=0;
    end

    assign x={sec_H,sec_L};
endmodule


