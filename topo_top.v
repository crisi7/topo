`timescale 1ns / 1ps
module topo_top(
    input clk,
    input rst_n, 
    input key_ss,
    input key_load,
    input key_mode,
    input key_add,
    input key_sub,
    
    output cnt_en,
    output load,
//    output [7:0]min_Init,
    
    output [7:0]atog,
    output [3:0]an,
    output [2:0]cstate,
    output [7:0]atog2,
    output [3:0]an2,
    output curr_t,
    output auto_t,
    output [7:0]led
    );
    
    wire c_key_ss,c_key_load,c_key_mode,c_key_add,c_key_sub;
    
    key_debounce U_key_ss(
    .clk(clk),
    .rst_n(rst_n),
    .key(key_ss),
    .key_out(c_key_ss)
    );  
    
    key_debounce U_key_load(
    .clk(clk),
    .rst_n(rst_n),
    .key(key_load),
    .key_out(c_key_load)
    );
    
    key_debounce U_key_mode(
    .clk(clk),
    .rst_n(rst_n),
    .key(key_mode),
    .key_out(c_key_mode)
    );
    
    key_debounce U_key_add(
    .clk(clk),
    .rst_n(rst_n),
    .key(key_add),
    .key_out(c_key_add)
    );
    
    key_debounce U_key_sub(
    .clk(clk),
    .rst_n(rst_n),
    .key(key_sub),
    .key_out(c_key_sub)
    );
    
    wire [7:0]c_Set_t;
    //SetTimeBlock
    SetTimeBock U_SetTime(
    .clk(clk),
    .rst_n(rst_n),
    .key_add(c_key_add),
    .key_sub(c_key_sub),
    .Set_t(c_Set_t)
    );
    
    //countdown
    wire [7:0]c_sec;wire [7:0]c_min,c4;
    wire [7:0]c_min_Init;
    
    ctd_top_topo U_ctd(
    .clk(clk),
    .rst_n(rst_n) ,
    .cnt_en(cnt_en),
    .load(load),
    .min_Init(c_min_Init), 
    .xmin(c_min),
    .xsec(c_sec),
    .time_out(c4)
    );
    
    wire [7:0]c_Cycle_t;
    wire [2:0]c_cstate_to_g;
    //state mac
    state U_state(
    .clk(clk),
    .rst_n(rst_n),
    .key_ss(c_key_ss),
    .key_load(c_key_load),
    .key_mode(c_key_mode),
    .time_out(c4),
    .Set_t(c_Set_t),
    
    .cnt_en(cnt_en),
    .load(load),
    .min_Init(c_min_Init),
    .cstate(cstate), //ÏÖÌ¬
    .curr_t(curr_t),
    .auto_t(auto_t),
    .Cycle_t(c_Cycle_t),
    .cstate_to_g(c_cstate_to_g)
    );
    
    // cstate_to_g and Cycle and min_Init
    x7_lead U_x7_lead(
    .clk(clk),
    .rst_n(rst_n),
    .cstate_in(c_cstate_to_g),
    .xq(c_Cycle_t),
    .xh(c_min_Init),
   
    .atog(atog2),
    .an(an2)
    );
    
    //x7seg countdown
    x7_lag U_x7_lag(
    .clk(clk),
    .rst_n(rst_n),
    .xq(c_min),
    .xh(c_sec),
    
    .atog(atog),
    .an(an)
    );
    
    //blbl
    blingbling U_blbl(
    .clk(clk),
    .rst_n(rst_n),
    .lag_xq(c_min),
    .lag_xh(c_sec),
    .led(led)
    
    );
    
    
    
endmodule
