`timescale 1ns / 1ps
module ctd_top_topo(
    input clk,
    input rst_n, 
    input cnt_en,
    input load,
    input [7:0]min_Init, 
    output [7:0]xmin,
    output [7:0]xsec,
    output time_out
    );
    //0.47
    wire c21,c22;
    borrow60s_top U21(
    .clk(clk),
    .rst_n(rst_n),
    .cnt_en(cnt_en),
    .load(load),    
    .borrow(c21),
    .x(xsec)
    );
    
    ctd_topo U22(
    .clk(clk),
    .pulse_in(c21),
    .rst_n(rst_n),
    .load(load),
    .min_Init(min_Init),
    .x(xmin),
    .time_out(time_out)
    );
   
   
endmodule