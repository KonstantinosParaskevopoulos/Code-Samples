`timescale 1ns/1ps

module variance_control_system #(    
    parameter width = 64,
    parameter width_a = 128,

    parameter [319-(width):0] zero_star_one = 'h01,
    parameter [319-(width_a):0] zero_star_one_a = 'h01,

    parameter capacity = 320 - width,
    parameter capacity_a = 320 - width_a,

    parameter capacity_minus_key_wid = capacity - 128,
    parameter capacity_minus_key_wid_a = capacity_a - 128

) (
    input [width_a-1:0] data_block, //128-bit Block
    input [width_a-1:0] txt_block,  //128-bit Block
    input [319:0] prev_state,       //State Register Output
    input [319:0] p_chain_6_output, //Permutation-Block Chain Output (6-th Block Output)
    input [319:0] p_chain_2_output, //2nd Permutation-Block Output
    input [127:0] key,
    
    input p_out_sel,
    input txt_data_sel,             //control signal txt_data_sel = 0 txt_block | txt_data_sel = 1 data_block
    input permutation_category,     //Permutation Category Select 0 -> ASCON_128 | 1 -> ASCON_128a
    input key_zero_exp_sel,

    output [319:0] bit_320_txt_or_data_XORed,    
    output [width_a-1:0] aead_output_reg,
    output [319:0] assoc_data_c_xor_01,
    output [319:0] cap_xor_key

    
);

wire [width_a-1:0] data_or_txt_input;
//wire [319:0] initial_state;

wire [255:0] prev_state_255_0;
wire [191:0] prev_state_191_0;

wire [63:0] prev_state_319_256;
wire [127:0] prev_state_319_192;

wire [capacity-1:0] zero_key;
wire [capacity_a-1:0] zero_key_a;
wire [capacity-1:0] key_zero;
wire [capacity_a-1:0] key_zero_a;

wire [319:0] xored_zero_key;
wire [319:0] xored_key_zero;


assign zero_key = {128'h0, key};
assign zero_key_a = {64'h0, key};
assign key_zero = {key, 128'h0};
assign key_zero_a = {key, 64'h0};

assign prev_state_255_0 = prev_state[255:0];
assign prev_state_191_0 = prev_state[191:0];
assign prev_state_319_256 = prev_state[319:256];
assign prev_state_319_192 = prev_state[319:192];


assign data_or_txt_input = txt_data_sel ? data_block : txt_block; //control signal txt_data_sel = 0 txt_block | txt_data_sel = 1 data_block

assign bit_320_txt_or_data_XORed = (permutation_category) ? {(data_or_txt_input ^ prev_state_319_192), prev_state_191_0} : {(data_or_txt_input[63:0] ^ prev_state_319_256), prev_state_255_0};

assign aead_output_reg = (permutation_category) ? bit_320_txt_or_data_XORed[319:319-width_a+1] : {64'h0000000000000000, bit_320_txt_or_data_XORed[319:319-width+1]}; 

assign assoc_data_c_xor_01 = (p_out_sel) ? ((permutation_category) ? {p_chain_2_output[319:319-width_a+1],(p_chain_2_output[(319-width_a):0] ^ zero_star_one_a)} : {p_chain_2_output[319:319-width+1],(p_chain_2_output[(319-width):0] ^ zero_star_one)}) : ((permutation_category) ? {p_chain_6_output[319:319-width_a+1],(p_chain_6_output[(319-width_a):0] ^ zero_star_one_a)} : {p_chain_6_output[319:319-width+1],(p_chain_6_output[(319-width):0] ^ zero_star_one)});

assign xored_zero_key = (p_out_sel) ? ((permutation_category) ? {p_chain_2_output[319:319-width_a+1],(p_chain_2_output[(319-width_a):0] ^ zero_key_a)} : {p_chain_2_output[319:319-width+1],(p_chain_2_output[(319-width):0] ^ zero_key)}) : ((permutation_category) ? {p_chain_6_output[319:319-width_a+1],(p_chain_6_output[(319-width_a):0] ^ zero_key_a)} : {p_chain_6_output[319:319-width+1],(p_chain_6_output[(319-width):0] ^ zero_key)});

assign xored_key_zero = (p_out_sel) ? ((permutation_category) ? {p_chain_2_output[319:319-width_a+1],(p_chain_2_output[(319-width_a):0] ^ key_zero_a)} : {p_chain_2_output[319:319-width+1],(p_chain_2_output[(319-width):0] ^ key_zero)}) : ((permutation_category) ? {p_chain_6_output[319:319-width_a+1],(p_chain_6_output[(319-width_a):0] ^ key_zero_a)} : {p_chain_6_output[319:319-width+1],(p_chain_6_output[(319-width):0] ^ key_zero)});

assign cap_xor_key = (key_zero_exp_sel) ? xored_key_zero : xored_zero_key;

endmodule