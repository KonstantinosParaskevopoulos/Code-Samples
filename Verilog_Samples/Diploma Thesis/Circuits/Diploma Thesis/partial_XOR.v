`timescale 1ns/1ps


module partialXOR
#(
    parameter width = 64
)
(
    input [width-1:0] in_txt_data,
    input [319:0] state,
    output [319:0] out_state
);

assign out_state = {(in_txt_data^state[319:319-width+1]), state[319-width:0]};
    
endmodule

