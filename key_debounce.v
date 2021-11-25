`timescale 1ns / 1ps
module key_debounce(
    input clk,rst_n,key,
    output key_out
    );
    reg key_p_flag;
    reg key_n_flag;
    reg key_value;
    reg key_reg;
    reg [20:0] delay_cnt;
    parameter DELAY_TIME=15;
    //key_reg
    always @(posedge clk,negedge rst_n)
    if(!rst_n)key_reg<=1'b0;
    else key_reg<=key;
    
    //delay_cnt
    always @(posedge clk,negedge rst_n)
    if(!rst_n)
        delay_cnt<=21'b0;
    else if(key!=key_reg)
        delay_cnt<=DELAY_TIME;
    else if(delay_cnt>0)
        delay_cnt<=delay_cnt-1'b1;
    else 
        delay_cnt<=21'd0;
    
    //key_value
    always @(posedge clk,negedge rst_n)
    if(!rst_n)
        key_value<=1'b0;
    else if(delay_cnt==1'b1)
        key_value<=key;
    else 
        key_value<=key_value;
    
    //key_p_flag
    always @(posedge clk,negedge rst_n)
    if(!rst_n)
        key_p_flag<=1'b0;
    else if(delay_cnt==1'b1&&key==1)
        key_p_flag<=1'b1;
    else 
        key_p_flag<=1'b0;
    
    //key_n_flag
    always @(posedge clk,negedge rst_n)
    if(!rst_n)
        key_n_flag<=1'b0;
    else if(delay_cnt==1'b1&&key==0)
        key_n_flag<=1'b1;
    else 
        key_n_flag<=1'b0;
    
    assign key_out=key_value&&key_p_flag;
    
endmodule
