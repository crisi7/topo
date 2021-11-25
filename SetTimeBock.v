`timescale 1ns / 1ps
module SetTimeBock(
    input clk,rst_n,
    input key_add,
    input key_sub,
    output reg[7:0]Set_t
    );
    always @(posedge clk,negedge rst_n) begin
        if(!rst_n)
            Set_t[7:0]<=8'h02;
        // add
        else if(Set_t[7:0]==8'h60&&key_add==1&&key_sub!=1)
            Set_t[7:0]<=8'h01;
        else if(Set_t[7:0]!=8'h60&&key_add==1&&key_sub!=1)begin
            if(Set_t[3:0]==4'h9)begin
            Set_t[7:4]<=Set_t[7:4]+1;
            Set_t[3:0]<=0;
            end
            else begin
            Set_t[7:4]<=Set_t[7:4];
            Set_t[3:0]<=Set_t[3:0]+1;
            end
        end
        //sub  
        else if(Set_t[7:0]==8'h01&&key_add!=1&&key_sub==1)
            Set_t[7:0]<=8'h60;
        else if(Set_t[7:0]!=8'h01&&key_add!=1&&key_sub==1)begin
            if(Set_t[3:0]==4'h0)begin
            Set_t[7:4]<=Set_t[7:4]-1;
            Set_t[3:0]<=9;
            end
            else begin
            Set_t[7:4]<=Set_t[7:4];
            Set_t[3:0]<=Set_t[3:0]-1;
            end
        end
            
        else
            Set_t[7:0]<=Set_t[7:0];
           
        
    end  
endmodule
