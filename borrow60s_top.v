`timescale 1ns / 1ps
module borrow60s_top(
    input clk,
    input rst_n,
    input cnt_en,
    input load,
    output [7:0]x,
    output borrow
    );
    //0.47
    wire c1;
    sec_pulse U1(
    .clk(clk),
    .rst_n(rst_n),
    .sec_pulse(c1)
    );
    
    ctd60s U2(
    .clk(clk),
    .rst_n(rst_n),
    .pulse_in(c1),
    .cnt_en(cnt_en),
    .load(load),
    .x(x),
    .borrow(borrow)
    );
endmodule
