`timescale 1ns/1ps

module constAddition_mux_Based_128a_opt #(
    parameter odd_even = 1 //(1 for odd | 0 for even) 
)(
    input [63:0] x_2,
    input [7:0] pa_first,
    input [7:0] pa_sec__pb_first,
    input [7:0] pb128a_first,
    input [7:0] pb128a_sec,
    input [2:0] loop_num, 
    input const_sel,    //1 -> 128a || 0 -> 128
    input compact_fast, //0-> compact || 1-> fast
    output [63:0] x_2_out
);
 
wire [7:0] constant;

    generate
        if (odd_even) begin
            odd_constants_128 odd (loop_num, constant);
        end
        else begin
            even_constants_128 even (loop_num, constant);
        end
    endgenerate

assign x_2_out = (!compact_fast)? ({x_2[63:8], x_2[7:0] ^ constant}) : (const_sel ? (loop_num[0] ? {x_2[63:8], x_2[7:0] ^ pb128a_sec} : {x_2[63:8], x_2[7:0] ^ pb128a_first}) : (loop_num[0] ? {x_2[63:8], x_2[7:0] ^ pa_sec__pb_first} : {x_2[63:8], x_2[7:0] ^ pa_first})); 

//////////////////////////////////////////////////////
//  Perm_Cat    |   Loop_Num[0] |   Const           //
//--------------|---------------|-------------------//
//      0       |       0       |   pa_first        //
//      0       |       1       |   pa_sec/pb_first //
//      1       |       0       |   pb128a_first    //
//      1       |       1       |   pb128a_sec      //
//////////////////////////////////////////////////////


endmodule

module odd_constants_128 (
    input [2:0] loop_num,
    output reg [7:0] constant
);

always @(loop_num) begin
    case (loop_num)
        3'h0: constant = 8'he1;
        3'h1: constant = 8'hc3;
        3'h2: constant = 8'ha5;
        3'h3: constant = 8'h87;
        3'h4: constant = 8'h69;
        3'h5: constant = 8'h4b;
        default: constant = 8'h00;
    endcase
end
    
endmodule

module even_constants_128 (
    input [2:0] loop_num,
    output reg [7:0] constant
);

always @(loop_num) begin
    case (loop_num)
        3'h0: constant = 8'hf0;
        3'h1: constant = 8'hd2;
        3'h2: constant = 8'hb4;
        3'h3: constant = 8'h96;
        3'h4: constant = 8'h78;
        3'h5: constant = 8'h5a;
        default: constant = 8'h00;
    endcase
end
    
endmodule

//////////////////////////////////////////////////////////////////



/*module constAddition_LUT_Based_128_compact #(
    parameter odd_even = 1 //(1 for odd | 0 for even) 
)(
    input [63:0] x_2,
    input [2:0] loop_num,
    output [63:0] x_2_out
);

    wire [7:0] constant;

    generate
        if (odd_even) begin
            odd_constants_128 odd (loop_num, constant);
        end
        else begin
            even_constants_128 even (loop_num, constant);
        end
    endgenerate

assign x_2_out = {x_2[63:8], x_2[7:0] ^ constant}; 



endmodule*/