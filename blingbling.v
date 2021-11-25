`timescale 1ns / 1ps
module blingbling(
    input clk,rst_n,
    input [7:0]lag_xq,
    input [7:0]lag_xh,
    output reg[7:0]led
    );
    
    // get sec_pulse
    reg sec_pulse;
    parameter ts=7000000/2;
    reg [26:0]cntns;
    always @(posedge clk,negedge rst_n)begin
    if(!rst_n)
        cntns<=0;
    else if(clk)
        if(cntns==ts)cntns<=0;
        else cntns<=cntns+1;
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
    
    parameter   
        S0=4'b0000,
        S1=4'b0001,
        S2=4'b0010,
        S3=4'b0011,
        S4=4'b0100,
        S5=4'b0101,
        S6=4'b0110,
        S7=4'b0111,
        S8=4'b1000,
        S9=4'b1001;
        
    reg [3:0]cs;
    reg [3:0]ns;
    always @(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
    cs<=S0;
    end
    else cs<=ns;
    end
    
    always @* begin
        if(sec_pulse)
        case(cs)
            S0:begin
            if(lag_xq[7:0]==8'h00&&lag_xh[7:0]<8'h55)ns=S1;
            else ns=S0;end
            S1:begin
            if(lag_xq[7:0]==8'h00&&lag_xh[7:0]<8'h55)ns=S2;
            else ns=S0;end
            S2:begin
            if(lag_xq[7:0]==8'h00&&lag_xh[7:0]<8'h55)ns=S3;
            else ns=S0;end
            S3:begin
            if(lag_xq[7:0]==8'h00&&lag_xh[7:0]<8'h55)ns=S4;
            else ns=S0;end
            S4:begin
            if(lag_xq[7:0]==8'h00&&lag_xh[7:0]<8'h55)ns=S5;
            else ns=S0;end
            S5:begin
            if(lag_xq[7:0]==8'h00&&lag_xh[7:0]<8'h55)ns=S6;
            else ns=S0;end
            S6:begin
            if(lag_xq[7:0]==8'h00&&lag_xh[7:0]<8'h55)ns=S7;
            else ns=S0;end
            S7:begin
            if(lag_xq[7:0]==8'h00&&lag_xh[7:0]<8'h55)ns=S8;
            else ns=S0;end
            S8:begin
            if(lag_xq[7:0]==8'h00&&lag_xh[7:0]<8'h55)ns=S9;
            else ns=S0;end
            S9:begin
            if(lag_xq[7:0]==8'h00&&lag_xh[7:0]<8'h55)ns=S0;
            else ns=S0;end
            default:ns=S0;
        endcase
        else ns=cs;
    end
    
    always@(posedge clk,negedge rst_n)begin
    if(!rst_n)led<=8'b00000000;
    else
        case(cs)
            S0:led<=8'b00000000;
            S1:led<=8'b10000001;
            S2:led<=8'b01000010;
            S3:led<=8'b00100100;
            S4:led<=8'b00011000;
            S5:led<=8'b00000000;
            S6:led<=8'b00011000;
            S7:led<=8'b00100100;
            S8:led<=8'b01000010;
            S9:led<=8'b10000001;
            default:led<=8'b00000000;
        endcase
    end
        
endmodule
