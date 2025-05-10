`timescale 1ns/1ps



module ASCON_Core #(    
    parameter [319:0] Pre_Calc_State_Hash = 320'hee9398aadb67f03d8bb21831c60f1002b48a92db98d5da6243189921b8f8e3e8348fa5c9d525e140,
    parameter [319:0] Pre_Calc_State_Hash_a = 320'h01470194fc6528a6738ec38ac0adffa72ec8e3296c76384cd6f6a54d7f52377da13c42a223be8d87,
    parameter [63:0] IV_aead = 64'h80400c0600000000,
    parameter [63:0] IV_aead_a = 64'h80800c0800000000,
    parameter width = 64,
    parameter width_a = 128,

    parameter [319-(width):0] zero_star_one = 'h01,
    parameter [319-(width_a):0] zero_star_one_a = 'h01,

    parameter capacity = 320 - width,
    parameter capacity_a = 320 - width_a,

    parameter capacity_minus_key_wid = capacity - 128,
    parameter capacity_minus_key_wid_a = capacity_a - 128
) (
    //Inputs
    input [127:0] Key,
    input [127:0] Nonce,
    //input [63:0] IV_aead,
    input [width_a-1:0] data_block,
    input [width_a-1:0] txt_block,
    //Control Signals
    input txt_data_sel,
    input initial_state_sel,
    input [1:0] permutation_input_sel,
    input [2:0] loop_num,
    input key_zero_exp_sel,
    input [1:0] permutation_output_sel,
    input enc_dec, //(0 for encode | 1 for decode)
    input tag_reg_en,
    input out_reg_en,
    input stat_reg_en,
    input hash_aead,    //(0 for hash | 1 for aead)
    input permutation_category,     //Permutation Category Select 0 -> ASCON_128 | 1 -> ASCON_128a
    input const_sel,        //Select Permutation Constant Set   0 -> p_a_constants, p_b_128_constants | 1-> p_b_128a_constants
    input p_out_sel,    // Select Signal for 0*||1, 0*||K and K||0*    1 -> p2 | 0 -> p6
    input [5:0] enable_array,
    input compact_fast,
    //clk enables and resets
    input clk, rstn,
    //Outputs
    output reg [width_a-1:0] output_reg,
    output reg [127:0] tag_reg

);

wire [width_a-1:0] data_or_txt_input;
wire [319:0] initial_state;
wire [319:0] bit_320_txt_or_data_XORed;
wire [319:0] assoc_data_c_xor_01;
wire [319:0] cap_xor_key;
wire [319:0] ciphertext_as_permut_input;
wire [width_a-1:0] aead_output_reg;
reg [319:0] state_reg;

reg [319:0] p_chain_input;
wire [319:0] p_chain_6_output;
wire [319:0] p_chain_2_output;

//=============================Variance Control System to be Checked=============================
//
variance_control_system vcs(
    .data_block(data_block),
    .txt_block(txt_block),
    .prev_state(state_reg),
    .p_chain_6_output(p_chain_6_output),
    .p_chain_2_output(p_chain_2_output),
    .key(Key),
    .p_out_sel(p_out_sel),
    .txt_data_sel(txt_data_sel),
    .permutation_category(permutation_category),
    .key_zero_exp_sel(key_zero_exp_sel),
    .bit_320_txt_or_data_XORed(bit_320_txt_or_data_XORed),
    .aead_output_reg(aead_output_reg),
    .assoc_data_c_xor_01(assoc_data_c_xor_01),
    .cap_xor_key(cap_xor_key)
);
//
//==============================================================================================




//assign data_or_txt_input = txt_data_sel ? data_block : txt_block; //control signal txt_data_sel = 0 txt_block | txt_data_sel = 1 data_block

/*generate    // Data/Text XORs "Generate"
        if (ALG_VER)
            partialXOR #(.width(width)) par_xor (.in_txt_data(data_or_txt_input), .state(state_reg), .out_state(bit_320_txt_or_data_XORed));
        else 
            partialXOR #(.width(width_a)) par_xor (.in_txt_data(data_or_txt_input), .state(state_reg), .out_state(bit_320_txt_or_data_XORed));
endgenerate*/

//control signal 1 -> Init State of AEAD | 0 -> Init State of Hash


/*generate//Initial State Select 
        if(ALG_VER) begin
            assign initial_state = initial_state_sel ? {IV_aead, Key, Nonce} : {data_block ^ Pre_Calc_State_Hash[319:319-(width+1)], Pre_Calc_State_Hash[319-width:0]}; //control signal 1 -> Init State of AEAD | 0 -> Init State of Hash
        end
        else begin 
            assign initial_state = initial_state_sel ? {IV_aead_a, Key, Nonce} : {data_block ^ Pre_Calc_State_Hash_a[319:319-(width+1)], Pre_Calc_State_Hash_a[319-width:0]}; //control signal 1 -> Init State of AEAD_a | 0 -> Init State of Hash_a
        end
endgenerate*/

assign initial_state = (permutation_category) ? (initial_state_sel ? {IV_aead_a, Key, Nonce} : {data_block ^ Pre_Calc_State_Hash_a[319:319-(width_a+1)], Pre_Calc_State_Hash_a[319-width_a:0]}) : (initial_state_sel ? {IV_aead, Key, Nonce} : {data_block ^ Pre_Calc_State_Hash[319:319-(width+1)], Pre_Calc_State_Hash[319-width:0]});

assign ciphertext_as_permut_input = (permutation_category) ? {txt_block, state_reg[319-width_a:0]} : {txt_block[63:0], state_reg[319-width:0]};

always @(*) begin   //Permutation Block Chain Input Multiplexer
    case (permutation_input_sel)//control signal | selects the input of the p_block chain
        2'b00:p_chain_input = initial_state;
        2'b01:p_chain_input = bit_320_txt_or_data_XORed;
        2'b10:p_chain_input = state_reg;
        2'b11:p_chain_input = ciphertext_as_permut_input;  //For Decryption
        default: p_chain_input = 320'h00000000000000000000000000000000000000000000000000000000000000000000000000000000;
    endcase
end

//=============================To be Changed=============================

            p_block_chain p_chain(
                .x_in(p_chain_input),
                .loop_num(loop_num),
                .const_sel(const_sel),
                .enable_array(enable_array),
                .compact_fast(compact_fast),
                .x_out_6(p_chain_6_output),
                .x_out_2(p_chain_2_output)
            );
//=======================================================================


//assign assoc_data_c_xor_01 = {p_chain_output[319:319-width+1],(p_chain_output[(319-width):0] ^ zero_star_one)};
 
//assign cap_xor_key = key_zero_exp_sel ? ({p_chain_output[319:256],(p_chain_output[(319-width):0] ^ {Key, 128'h00000000000000000000000000000000})}) : ({p_chain_output[319:256],(p_chain_output[(319-width):0] ^ {128'h00000000000000000000000000000000, Key})}) ; //control signal | key_zero_exp_sel = 0 {0*||K} | key_zero_exp_sel = 1 {K||0*}


always @(posedge clk or negedge rstn) begin //State Register
    if(!rstn)
        state_reg <= 320'h00;
    else if(stat_reg_en)begin
        case (permutation_output_sel)
            2'b00 : state_reg <= p_chain_6_output;        // state_reg = output of permutation_block_chain p^2 or p^6 no matter as it is controlled by "permutation_category" control signal
            2'b01 : state_reg <= assoc_data_c_xor_01;   // state_reg = xor (p_chain_out, 0*||1)
            2'b10 : state_reg <= p_chain_2_output;
            2'b11 : state_reg <= cap_xor_key;           // state_reg = xor (p_chain_out, (K||0* or 0*||K))
            default: state_reg <= 320'h00;              // reset state_reg in case of unexpected ctrl sgnl
        endcase
    end
end

always @(posedge clk or negedge rstn) begin //Tag Ragister
    if(!rstn) begin
        tag_reg <= 128'h00;
    end
    else if (tag_reg_en) begin
        tag_reg <= state_reg ^ Key;
    end
end

//=============================To be Changed=============================
always @(posedge clk or negedge rstn) begin //Output Register
    if(!rstn) begin
        output_reg <= 'h0;
    end
    else if (out_reg_en) begin
        if(hash_aead==1'b0) output_reg <= state_reg[319:319-width_a+1];
        else if(hash_aead==1'b1 && txt_data_sel==1'b0) output_reg <= aead_output_reg;    //output of plaintext xor prev state only if "text block" selected AND "AEAD mode"
    end
end
//=======================================================================

endmodule