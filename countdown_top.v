`timescale 1ns / 1ps
module countdown_top(
    input clk,
    input rst_n, 
    input cnt_en,
    input load,
    input curr_t,
    input [7:0]min_Init, 
    output [7:0]xq,
    output [7:0]xh
    );
    
    wire c1;
    borrow60s_top U1(
    .cnt_en(cnt_en),
    .load(load),
    .clk(clk),
    .rst_n(rst_n),
    
    .borrow_out(c1),
    .x(xh)
    );

    cnt_new U12(
    .pulse_in(c1),
    .rst_n(rst_n),
    .cnt_en(cnt_en),
    .load(load),
    .min_Init(min_Init),
    .curr_t(curr_t),
    .x(xq)
    );
    
    
    
    
    
endmodule
