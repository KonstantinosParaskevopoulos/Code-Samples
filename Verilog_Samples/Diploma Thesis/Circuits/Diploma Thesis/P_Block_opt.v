`timescale 1ns/1ps

module p_block_opt #(
    parameter odd_even = 1 //(1 for odd | 0 for even) 
)(
    input [319:0] x_in,
    input [7:0] pa_1st,
    input [7:0] pa_2nd_pb_1st,
    input [7:0] pb_1st,
    input [7:0] pb_2nd,
    input [2:0] loop_num, 
    input const_sel,
    input enable,
    input compact_fast,
    output [319:0] x_out
);

    wire [319:0] s_box_out;
    wire [319:0] lin_dif_layer_out;
    wire [63:0] const_addition_out;

    wire [319:0] p_block_in;
    wire [319:0] s_box_in;

    assign p_block_in = (enable) ? x_in : 320'h0;
    assign s_box_in = (enable) ? {x_in[319:192], const_addition_out, x_in[127:0]} : 320'h0;

    constAddition_mux_Based_128a_opt #(.odd_even(odd_even)) const_add_a (
        .x_2(p_block_in[191:128]),
        .pa_first(pa_1st),
        .pa_sec__pb_first(pa_2nd_pb_1st),
        .pb128a_first(pb_1st),
        .pb128a_sec(pb_2nd),
        .loop_num(loop_num), 
        .const_sel(const_sel),
        .compact_fast(compact_fast),
        .x_2_out(const_addition_out)
    );
    

    ASCON_SBox_320_Bit sbox (
        .x_0(s_box_in[319:256]),   //Most Significant
        .x_1(s_box_in[255:192]),
        .x_2(s_box_in[191:128]),
        .x_3(s_box_in[127:64]),
        .x_4(s_box_in[63:0]),      //Least Significant
        .x_0_out(s_box_out[319:256]),   //Most Significant
        .x_1_out(s_box_out[255:192]),
        .x_2_out(s_box_out[191:128]),
        .x_3_out(s_box_out[127:64]),
        .x_4_out(s_box_out[63:0])      //Least Significant
    );
    
    linearDiffusionLayer ldl (
        .x_0(s_box_out[319:256]),   //Most Significant
        .x_1(s_box_out[255:192]),
        .x_2(s_box_out[191:128]),
        .x_3(s_box_out[127:64]),
        .x_4(s_box_out[63:0]),      //Least Significant
        .x_0_out(lin_dif_layer_out[319:256]),   //Most Significant
        .x_1_out(lin_dif_layer_out[255:192]),
        .x_2_out(lin_dif_layer_out[191:128]),
        .x_3_out(lin_dif_layer_out[127:64]),
        .x_4_out(lin_dif_layer_out[63:0])      //Least Significant
    );
    
    

    
    
assign x_out = lin_dif_layer_out;
    
endmodule

