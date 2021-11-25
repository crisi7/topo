`timescale 1ns / 1ps
module state(
    input clk,
    input rst_n,
    input key_load,
    input key_ss,
    input key_mode,
    input time_out,
    input [7:0]Set_t,
    
    output reg cnt_en,
    output reg load,
    output reg [7:0]min_Init,
    output reg [2:0]cstate, //current state
    output reg curr_t,
    output reg auto_t,
    output reg [7:0]Cycle_t,
    output reg [2:0]cstate_to_g
    );
  
    parameter
        WORK_INIT=3'b000,
        REST_INIT=3'b001,
        COUNT=3'b011,
        PAUSE=3'b010,
        SET_TIME=3'b110,    //set min_Init
        WORK=1,
        REST=0;
        
          
   reg [2:0]nstate; //next state
//   reg [2:0]WORK_Cycle=0;
//   reg [2:0]REST_Cycle=0;
   
   always @(posedge clk,negedge rst_n)begin
    if(!rst_n)begin
        cstate<=WORK_INIT;
        cstate_to_g<=cstate;
    end
    else 
        cstate<=nstate;
        cstate_to_g<=cstate;
    end

    always @* begin
        case(cstate)
        WORK_INIT:begin 
                if(key_load==1)nstate=REST_INIT;
                else if(key_ss==1||auto_t==1)nstate=COUNT;
                else nstate=cstate;
            end
        REST_INIT:begin 
                if(key_load==1)nstate=WORK_INIT;
                else if(key_ss==1||auto_t==1)nstate=COUNT;
                else nstate=cstate;
            end
        COUNT:begin     
                if(key_ss==1)nstate=PAUSE;
                else if(time_out==1&&curr_t==REST)nstate=WORK_INIT;                
                else if(time_out==1&&curr_t==WORK)nstate=REST_INIT;
                else nstate=cstate;
            end
        PAUSE:begin     
                if(key_load==1&&curr_t==REST)nstate=WORK_INIT;
                else if(key_load==1&&curr_t==WORK)nstate=REST_INIT;
                else if(key_ss==1)nstate=COUNT;
                else if(key_mode==1)nstate=SET_TIME;
                else nstate=cstate;
            end
        SET_TIME:begin
                if(key_mode==1)nstate=PAUSE;
                else nstate=cstate;
        end
        default:nstate=WORK_INIT;
        endcase
    end

    always@ (posedge clk,negedge rst_n) begin
        if(!rst_n)begin
            cnt_en<=0;load<=1;
            curr_t<=WORK;   
            auto_t<=0;  //will not goto COUNT directly
            min_Init<=8'h07;
            Cycle_t[7:0]<=8'b00000000;
            end
        else begin
            case (cstate)
                WORK_INIT:begin
                    cnt_en<=0;load<=1;
                    curr_t<=WORK;
                    auto_t<=auto_t;
                    min_Init<=Set_t;
                    Cycle_t=Cycle_t;
                    end
                REST_INIT:begin
                    cnt_en<=0;load<=1;
                    curr_t<=REST;
                    auto_t<=auto_t;
                    min_Init<=8'h03;
                    Cycle_t=Cycle_t;
                    end
                COUNT:begin
                    cnt_en<=1;load<=0;
                    curr_t<=(Cycle_t[7:0]==8'b01000100)?WORK:curr_t;
                    // when cycle equal 4 make it's initial min_Init equal WORK time
                    auto_t<=(Cycle_t[7:0]==8'b01000100)?0:1;
                    // when cycle equal 4 make it stop 
                   
                    min_Init<=min_Init;
                    
                    if(time_out==1)begin                 
                        if(Cycle_t[7:0]==8'b01000100)begin
                            Cycle_t[7:0]<=0;
                            end
                        else if(Cycle_t[7:4]==4'b0100&&Cycle_t[3:0]<4'b0100)begin
                                if(curr_t==REST)begin
                                    Cycle_t[7:4]<=Cycle_t[7:4];
                                    Cycle_t[3:0]<=Cycle_t[3:0]+1;
                                end
                                else Cycle_t<=Cycle_t;
                            end
                        else if(Cycle_t[7:4]<4'b0100&&Cycle_t[3:0]==4'b0100)begin
                                if(curr_t==WORK)begin
                                    Cycle_t[7:4]<=Cycle_t[7:4]+1;
                                    Cycle_t[3:0]<=Cycle_t[3:0];
                                end
                                else Cycle_t<=Cycle_t;
                            end
                        else if(Cycle_t[7:4]<4'b0100&&Cycle_t[3:0]<4'b0100)
                                if(curr_t==REST)begin
                                    Cycle_t[7:4]<=Cycle_t[7:4];
                                    Cycle_t[3:0]<=Cycle_t[3:0]+1;
                                end
                                else if(curr_t==WORK)begin
                                    Cycle_t[7:4]<=Cycle_t[7:4]+1;
                                    Cycle_t[3:0]<=Cycle_t[3:0];
                                end
                                else Cycle_t<=Cycle_t;
                    end
                    else Cycle_t<=Cycle_t;
                    
                    end
                PAUSE:begin
                    cnt_en<=0;load<=0;
                    curr_t<=curr_t;
                    auto_t<=0;
                    min_Init<=min_Init;
                    Cycle_t=Cycle_t;
                    end
                SET_TIME:begin
                    cnt_en<=1;load<=1;
                    curr_t<=curr_t;
                    auto_t<=auto_t;
                    min_Init<=Set_t;
                    Cycle_t=Cycle_t;
                    end
                default:begin
                    cnt_en<=0;load<=1;
                    curr_t<=WORK;
                    auto_t<=auto_t;
                    min_Init<=8'h07;
                    Cycle_t=8'b0000000;
                end
            endcase  
        end
    end
endmodule
