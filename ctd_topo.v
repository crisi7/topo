`timescale 1ns / 1ps
module ctd_topo(
    input clk,
    input rst_n,
    input pulse_in,
    input load,
    input [7:0]min_Init,
    output [7:0]x,
    output reg time_out
    );
    //0.47
    reg [3:0] min_H=0;
    reg [3:0] min_L=7;

    always @(posedge clk,negedge rst_n) begin
        if(!rst_n)begin
            min_H<=min_Init[7:4];
            min_L<=min_Init[3:0];
//            min_H<=0;
//            min_L<=4'h05;
        end
        else if(pulse_in&&min_H==0&&min_L==0&&load==0)begin
             if(min_Init[3:0]==0)begin
             min_H<=min_Init[7:4]-1;
             min_L<=4'd9;
             end
             else begin
             min_H<=min_Init[7:4];
             min_L<=min_Init[3:0]-1;
             end
//            min_H<=2;
//            min_L<=5;
        end
        else if(pulse_in&&min_H!=0&&min_L==0&&load==0)begin
            min_H<=min_H-1;
            min_L<=9;
        end
        else if(pulse_in&&load==0)
            min_L<=min_L-1;
        else begin
            min_H<=min_H;
            min_L<=min_L;
        end
    end

    always @(posedge clk,negedge rst_n) begin
        if(!rst_n)  time_out<=0;
        else if(clk&&pulse_in&&min_H==0&&min_L==0)time_out<=1;
        else time_out<=0;
    end

    assign x={min_H,min_L};
endmodule