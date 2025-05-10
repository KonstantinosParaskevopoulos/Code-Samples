`timescale 1ns/1ps

/*module ASCON_SBox (
    input x_0,
    input x_1,
    input x_2,
    input x_3,
    input x_4,
    output x_0_out,
    output x_1_out,
    output x_2_out,
    output x_3_out, //There is a mistake
    output x_4_out
);

wire a,b,c,d,e,f,g,h,i,j,k,l;

assign a = x_0 ^ x_4;
assign b = x_1 ^ x_2;
assign c = x_3 ^ x_4;

assign d = (a ^ 1'b1) & x_1;
assign e = (x_1 ^ 1'b1) & b;
assign f = (b ^ 1'b1) & x_3;
assign g = (x_3 ^ 1'b1) & c;
assign h = (c ^ 1'b1) & a;

assign i = a ^ e;
assign j = x_1 ^ f;
assign k = b ^ g;
assign l = x_3 ^ h;

assign m = c ^ d;
assign n = i ^ m;
assign o = i ^ j;
assign p = k ^ 1'b1;
assign q = k ^ l;

assign x_4_out = m;
assign x_0_out = n;
assign x_1_out = o;
assign x_2_out = p;
assign x_3_out = q;

endmodule*/

module ASCON_SBox_320_Bit (
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

wire [63:0] a,b,c,d,e,f,g,h,i;
wire [63:0] j,k,l,m,n,o,p,q;

assign a = x_0 ^ x_4;
assign b = x_1 ^ x_2;
assign c = x_3 ^ x_4;

assign d = (a ^ 64'hffffffffffffffff) & x_1;
assign e = (x_1 ^ 64'hffffffffffffffff) & b;
assign f = (b ^ 64'hffffffffffffffff) & x_3;
assign g = (x_3 ^ 64'hffffffffffffffff) & c;
assign h = (c ^ 64'hffffffffffffffff) & a;

assign i = a ^ e;
assign j = x_1 ^ f;
assign k = b ^ g;
assign l = x_3 ^ h;

assign m = c ^ d;
assign n = i ^ m;
assign o = i ^ j;
assign p = k ^ 64'hffffffffffffffff;
assign q = k ^ l;

assign x_4_out = m;
assign x_0_out = n;
assign x_1_out = o;
assign x_2_out = p;
assign x_3_out = q;

endmodule