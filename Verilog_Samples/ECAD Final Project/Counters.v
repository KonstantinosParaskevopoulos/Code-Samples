`include "parameters.v"

module Counters (clk, reset, X, Y);
    input clk, reset;
    output [9:0] X;
    output [9:0] Y;

    reg [9:0] v_counter;
    reg [9:0] h_counter;


/****************************Vertical Counter (Y)*******************************/

always @(posedge clk or posedge reset)            
        if(reset)
            v_counter = 0;
        else
            if(h_counter == `HMAX)                 // end of horizontal scan
                if((v_counter == `VMAX))           // end of vertical scan
                    v_counter = 0;
                else
                    v_counter = v_counter + 1;

/****************************Horizontal Counter (X)*****************************/

always @(posedge clk or posedge reset)            
        if(reset)
            h_counter = 0;
        else
            if(h_counter == `HMAX)                 // end of horizontal scan
                h_counter = 0;
            else
                h_counter = h_counter + 1;

/*********************************Assignments***********************************/

assign Y = v_counter;
assign X = h_counter;

endmodule    