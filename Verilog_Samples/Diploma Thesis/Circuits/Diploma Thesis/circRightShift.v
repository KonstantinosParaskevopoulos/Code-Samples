`timescale 1ns/1ps

module circRightShift #(
    parameter positions = 1
) (
    input [63:0] x_i,
    output [63:0] x_i_shifted
);
    assign x_i_shifted = {x_i[positions-1:0],x_i[63:positions]};
endmodule