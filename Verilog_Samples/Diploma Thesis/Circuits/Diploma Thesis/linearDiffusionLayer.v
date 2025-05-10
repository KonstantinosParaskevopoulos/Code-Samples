`timescale 1ns/1ps

module linearDiffusionLayer (
    input [63:0] x_0,
    input [63:0] x_1,
    input [63:0] x_2,
    input [63:0] x_3,
    input [63:0] x_4,
    output [63:0] x_0_out,
    output [63:0] x_1_out,
    output [63:0] x_2_out,
    output [63:0] x_3_out,
    output [63:0] x_4_out
);

//Temp Wires for Shifted Values of Each 64-Bit Part of the 320-Bit State Register
wire [63:0] x_0_crs19;
wire [63:0] x_0_crs28;

wire [63:0] x_1_crs61;
wire [63:0] x_1_crs39;

wire [63:0] x_2_crs1;
wire [63:0] x_2_crs6;

wire [63:0] x_3_crs10;
wire [63:0] x_3_crs17;

wire [63:0] x_4_crs7;
wire [63:0] x_4_crs41;


//Shifter Modules Instantiations
circRightShift #(.positions(19))   crs19    (.x_i(x_0), .x_i_shifted(x_0_crs19));
circRightShift #(.positions(28))   crs28    (.x_i(x_0), .x_i_shifted(x_0_crs28));
circRightShift #(.positions(61))   crs61    (.x_i(x_1), .x_i_shifted(x_1_crs61));
circRightShift #(.positions(39))   crs39    (.x_i(x_1), .x_i_shifted(x_1_crs39));
circRightShift #(.positions(1))    crs1     (.x_i(x_2), .x_i_shifted(x_2_crs1));
circRightShift #(.positions(6))    crs6     (.x_i(x_2), .x_i_shifted(x_2_crs6));
circRightShift #(.positions(10))   crs10    (.x_i(x_3), .x_i_shifted(x_3_crs10));
circRightShift #(.positions(17))   crs17    (.x_i(x_3), .x_i_shifted(x_3_crs17));
circRightShift #(.positions(7))    crs7     (.x_i(x_4), .x_i_shifted(x_4_crs7));
circRightShift #(.positions(41))   crs41    (.x_i(x_4), .x_i_shifted(x_4_crs41));

//Output continuous Assignements

assign x_0_out = x_0 ^ x_0_crs19 ^ x_0_crs28;
assign x_1_out = x_1 ^ x_1_crs61 ^ x_1_crs39;
assign x_2_out = x_2 ^ x_2_crs1 ^ x_2_crs6;
assign x_3_out = x_3 ^ x_3_crs10 ^ x_3_crs17;
assign x_4_out = x_4 ^ x_4_crs7 ^ x_4_crs41;    

endmodule