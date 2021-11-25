`timescale 1ns / 1ps
module sec_pulse(
    input clk,
    input rst_n,
    output reg sec_pulse
    );
    //0.47
//     parameter ts=49999999;
    parameter ts=7000000;
//    parameter ts=2;
    reg [26:0]cntns;
     
    always @(posedge clk,negedge rst_n)begin
    if(!rst_n)
        cntns<=0;
    else if(clk)
        if(cntns==ts)
            cntns<=0;
        else 
            cntns<=cntns+1;
    end
    always @(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
        sec_pulse<=1'd0;
        end
    else if(cntns==ts)begin
            sec_pulse<=1'b1;
            end
    else sec_pulse<=1'd0;
    end
endmodule
