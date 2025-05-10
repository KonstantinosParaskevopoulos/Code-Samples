`include "Opcodes.v"
`timescale 1ns/1ps

module Ctrl_Circuit #(

    parameter number_of_instructions = 41,
    parameter opcode_width = 6, //$clog2(number_of_instructions)
    parameter state_ID_width = 7,
    //state IDs
    parameter IDLE = 7'h00,
    parameter F_REF_ST_REG_LOOP_2_MD = 7'h01,
    parameter F_REF_ST_REG_LOOP_1_MD = 7'h02,
    parameter F_REF_ST_REG_LOOP_2_xor01_MD = 7'h03,
    parameter F_REF_ST_REG_LOOP_2_ST = 7'h04,
    parameter F_REF_ST_REG_LOOP_1_HASHIV = 7'h05,
    parameter F_REF_ST_REG_LOOP_1_ST = 7'h06,
    parameter F_REF_ST_REG_LOOP_2_xorK0_PT = 7'h07,
    parameter F_REF_ST_REG_LOOP_2_PT = 7'h08,
    parameter F_REF_ST_REG_LOOP_1_PT = 7'h09,
    parameter F_REF_ST_REG_LOOP_2_xorK0_CT = 7'h0A,
    parameter F_REF_ST_REG_LOOP_2_CT = 7'h0B,
    parameter F_REF_ST_REG_LOOP_1_CT = 7'h0C,
    parameter F_REF_ST_REG_LOOP_1_AEADIV = 7'h0D,
    parameter F_REF_ST_REG_LOOP_2_xor0K_ST = 7'h0E,
    parameter F_A_REF_ST_REG_LOOP_1_MD = 7'h0F,
    parameter F_A_REF_ST_REG_LOOP_2_ST = 7'h10,
    parameter F_A_REF_ST_REG_LOOP_2_xor01_ST = 7'h11,
    parameter F_A_REF_ST_REG_LOOP_1_PA_MD = 7'h12,
    parameter F_A_REF_ST_REG_LOOP_2_PA_ST = 7'h13,
    parameter F_A_REF_ST_REG_LOOP_1_HASHIV = 7'h14,
    parameter F_A_REF_ST_REG_LOOP_1_ST = 7'h15,
    parameter F_A_REF_ST_REG_LOOP_1_PT = 7'h16,
    parameter F_A_REF_ST_REG_LOOP_1_CT = 7'h17,
    parameter F_A_REF_ST_REG_LOOP_2_xorK0_ST = 7'h18,
    parameter F_A_REF_ST_REG_LOOP_1_PA_PT = 7'h19,
    parameter F_A_REF_ST_REG_LOOP_1_PA_CT = 7'h1A,
    parameter F_A_REF_ST_REG_LOOP_1_PA_AEADIV = 7'h1B,
    parameter LP_REF_ST_REG_LOOP_0_MD = 7'h1C,
    parameter LP_REF_ST_REG_LOOP_3_MD = 7'h1D,
    parameter LP_SHARED_REF_ST_REG_LOOP_1_ST = 7'h1E,
    parameter LP_SHARED_REF_ST_REG_LOOP_2_ST = 7'h1F,
    parameter LP_SHARED_REF_ST_REG_LOOP_3_ST = 7'h20,
    parameter LP_SHARED_REF_ST_REG_LOOP_4_ST = 7'h21,
    parameter LP_SHARED_REF_ST_REG_LOOP_5_ST = 7'h22,
    parameter LP_REF_ST_REG_LOOP_5_xorK0_ST = 7'h23,
    parameter LP_REF_ST_REG_LOOP_5_xor0K_ST = 7'h24,
    parameter LP_REF_ST_REG_LOOP_5_xor01_ST = 7'h25,
    parameter LP_REF_ST_REG_LOOP_0_HASHIV = 7'h26,
    parameter LP_SHARED_REF_ST_REG_LOOP_0_ST = 7'h27,
    parameter LP_REF_ST_REG_LOOP_3_PT = 7'h28,
    parameter LP_REF_ST_REG_LOOP_0_PT = 7'h29,
    parameter LP_REF_ST_REG_LOOP_3_CT = 7'h2A,
    parameter LP_REF_ST_REG_LOOP_0_CT = 7'h2B,
    parameter LP_REF_ST_REG_LOOP_0_AEADIV = 7'h2C,
    parameter LP_A_REF_ST_REG_LOOP_2_HASHIV = 7'h2D,
    parameter LP_A_REF_ST_REG_LOOP_2_PT = 7'h2E,
    parameter LP_A_REF_ST_REG_LOOP_0_PT = 7'h2F,
    parameter LP_A_REF_ST_REG_LOOP_2_CT = 7'h30,
    parameter LP_A_REF_ST_REG_LOOP_0_CT = 7'h31,
    parameter LP_A_REF_ST_REG_LOOP_0_AEADIV = 7'h32,
    parameter LP_A_REF_ST_REG_LOOP_5_xorK0_ST = 7'h33,
    parameter LP_A_REF_ST_REG_LOOP_5_xor0K_ST = 7'h34,
    parameter LP_A_REF_ST_REG_LOOP_5_xor01_ST = 7'h35,
    parameter LP_A_REF_ST_REG_LOOP_2_MD = 7'h36,
    parameter LP_A_REF_ST_REG_LOOP_0_MD = 7'h37,
    parameter PULL_TXT_FIFO = 7'h38,
    parameter PULL_DATA_FIFO = 7'h39,
    parameter REF_OUT_REG_HASH = 7'h3A,
    parameter A_REF_OUT_REG_HASH = 7'h3B,
    parameter REF_OUT_REG_AEAD = 7'h3C,
    parameter A_REF_OUT_REG_AEAD = 7'h3D,
    parameter PUSH_OUT_FIFO = 7'h3E,
    parameter EN_TAG_REG = 7'h3F,
    parameter KEY_LD = 7'h40,
    parameter NONCE_LD = 7'h41,
    parameter EXP_TAG_LD = 7'h42,
    //parameter TXT_BLK_LD = 7'h43,
    //parameter DATA_BLK_LD = 7'h44,
    parameter PUSH_TXT_FIFO = 7'h45,
    parameter PUSH_DATA_FIFO = 7'h46,
    parameter PULL_OUT_FIFO = 7'h47,
    parameter PULL_OUT_FIFO_DEC = 7'h48,
    parameter GLOBAL_RESET = 7'h7E,
    parameter INSTRUCTION_END = 7'h7F
    //parameter SESSION_END_STATE = 7'h7F   //To exit this state we have to do a HW or a SW reset
)(
    //clk enables and resets
    input clk, rstn_ctrl,
    input [opcode_width-1:0] opcode,
    input compact_fast,

    //Control Signals
    output reg txt_data_sel,
    output reg initial_state_sel,
    output reg [1:0] permutation_input_sel,
    output reg [2:0]loop_num,
    output reg key_zero_exp_sel,
    output reg [1:0] permutation_output_sel,
    output reg enc_dec, //(0 for encode | 1 for decode)
    output reg out_reg_en,
    output reg hash_aead,    //(0 for hash | 1 for aead)
    output reg permutation_category,     //Permutation Category Select 0 -> ASCON_128 | 1 -> ASCON_128a
    output reg const_sel,        //Select Permutation Constant Set   0 -> p_a_constants, p_b_128_constants | 1-> p_b_128a_constants
    output reg p_out_sel,    // Select Signal for 0*||1, 0*||K and K||0*    1 -> p2 | 0 -> p6
    output reg [5:0] enable_array,
    output reg exp_tag_en, 
    output reg key_en, 
    output reg nonce_en, 
    output reg glob_out_reg_en, //output data_in_en, output txt_in_en, 
    output reg ready, 
    output reg tag_reg_en,    //Register Enables
    output reg txt_FIFO_in_write, 
    output reg txt_FIFO_in_read,  
    output reg ad_FIFO_in_write, 
    output reg ad_FIFO_in_read, 
    output reg txt_FIFO_out_write, 
    output reg txt_FIFO_out_read, //FIFO Control Signals
    output reg state_reg_en, 
    output reg next, 
    //output reg //txt_blk_en, 
    //output reg //data_blk_en,
    output reg rstn
    //Output
);

reg [state_ID_width-1:0] next_state;
reg [state_ID_width-1:0] current_state;

reg comp_fast_reg;  // 0 -> Low Power Mode || 1 -> Fast Mode

always @(posedge clk or negedge rstn_ctrl)  //Circuit that ensures that the change between "Low Power Mode" and "Fast Mode" will Happen ONLY during "Resets"
begin
    if(rstn_ctrl==0 || current_state==GLOBAL_RESET)
        comp_fast_reg <= compact_fast;   
end

//FSM State Change Logic
always @(posedge clk or negedge rstn_ctrl)
begin
 if(rstn_ctrl==0) 
    current_state <= GLOBAL_RESET;// when reset=0, reset the state of the FSM to "IDLE" State
 else
    current_state <= next_state; // otherwise, next state
end 

always @(posedge clk) begin
        if(comp_fast_reg) begin         //Fast
                enable_array = 6'h3f;
                //p_out_sel = 1'b0;
        
        end
        else begin                      //Low Power
                enable_array = 6'h30;
                //p_out_sel = 1'b1;
        end
end

//Next State Logic
always @(current_state, opcode)begin
    case (current_state)
//-------Idle State-------//
        IDLE: begin
                if(comp_fast_reg)begin //Fast Mode
                    case (opcode)   
                        /*0x01*/    `ASCON_ENC_DATA: next_state = PULL_DATA_FIFO;
                        /*0x02*/    `ASCON_ENC_DATA_LAST: next_state = PULL_DATA_FIFO;
                        /*0x03*/    `ASCON_ENC_TEXT: next_state = PULL_TXT_FIFO;
                        /*0x04*/    `ASCON_ENC_TEXT_LAST: next_state = PULL_TXT_FIFO;
                        /*0x05*/    `ASCON_A_ENC_DATA: next_state = PULL_DATA_FIFO;
                        /*0x06*/    `ASCON_A_ENC_DATA_LAST: next_state = PULL_DATA_FIFO;
                        /*0x07*/    `ASCON_A_ENC_TEXT: next_state = PULL_TXT_FIFO;
                        /*0x08*/    `ASCON_A_ENC_TEXT_LAST: next_state = PULL_TXT_FIFO;
                        /*0x09*/    `ASCON_HASH_MESSAGE: next_state = PULL_DATA_FIFO;
                        /*0x0A*/    `ASCON_SQUEEZE_HASH: next_state = REF_OUT_REG_HASH;
                        /*0x0B*/    `ASCON_INIT_SQUEEZE_HASH: next_state = PULL_DATA_FIFO;
                        /*0x0C*/    `ASCON_A_HASH_MESSAGE: next_state = PULL_DATA_FIFO;
                        /*0x0D*/    `ASCON_A_SQUEEZE_HASH: next_state = A_REF_OUT_REG_HASH;
                        /*0x0E*/    `ASCON_A_INIT_SQUEEZE_HASH: next_state = PULL_DATA_FIFO;
                        /*0x0F*/    `ASCON_DEC_DATA: next_state = PULL_DATA_FIFO;
                        /*0x10*/    `ASCON_DEC_DATA_LAST: next_state = PULL_DATA_FIFO;
                        /*0x11*/    `ASCON_DEC_TEXT: next_state = PULL_TXT_FIFO;
                        /*0x12*/    `ASCON_DEC_TEXT_LAST: next_state = PULL_TXT_FIFO;
                        /*0x13*/    `ASCON_A_DEC_DATA: next_state = PULL_DATA_FIFO;
                        /*0x14*/    `ASCON_A_DEC_DATA_LAST: next_state = PULL_DATA_FIFO;
                        /*0x15*/    `ASCON_A_DEC_TEXT: next_state = PULL_TXT_FIFO;
                        /*0x16*/    `ASCON_A_DEC_TEXT_LAST: next_state = PULL_TXT_FIFO;
                        /*0x17*/    `ASCON_A_TAG_CALC_ENC: next_state = PULL_TXT_FIFO;
                        /*0x18*/    `ASCON_TAG_CALC_ENC: next_state = PULL_TXT_FIFO;
                        /*0x19*/    `ASCON_A_TAG_CALC_DEC: next_state = PULL_TXT_FIFO;
                        /*0x1A*/    `ASCON_TAG_CALC_DEC: next_state = PULL_TXT_FIFO;
                        /*0x1B*/    `ASCON_A_HASH_INIT: next_state = PULL_DATA_FIFO;
                        /*0x1C*/    `ASCON_HASH_INIT: next_state = PULL_DATA_FIFO;
                        /*0x1D*/    `ASCON_A_INIT: next_state = F_A_REF_ST_REG_LOOP_1_PA_AEADIV;
                        /*0x1E*/    `ASCON_INIT: next_state = F_REF_ST_REG_LOOP_1_AEADIV;
                        /*0x1F*/    `ASCON_DATA_FIFO_PUSH: next_state = PUSH_DATA_FIFO;
                        /*0x20*/    `ASCON_TEXT_IN_FIFO_PUSH: next_state = PUSH_TXT_FIFO;
                        /*0x21*/    `ASCON_TEXT_OUT_FIFO_PULL: next_state = PULL_OUT_FIFO;
                        /*0x22*/    `ASCON_TEXT_OUT_FIFO_PULL_DEC: next_state = PULL_OUT_FIFO_DEC;
                        /*0x23*/    `KEY_LOAD: next_state = KEY_LD;
                        /*0x24*/    `NONCE_LOAD: next_state = NONCE_LD;
                        /*0x25*/    `EXP_TAG_LOAD: next_state = EXP_TAG_LD;
                        ///*0x26*/    `DATA_BLK_LOAD: next_state = DATA_BLK_LD;
                        ///*0x27*/    `TXT_BLK_LOAD: next_state = TXT_BLK_LD;
                        ///*0x28*/    `END_OF_SESSION: next_state = SESSION_END_STATE;
                        /*0x00*/    `RESET: next_state = GLOBAL_RESET;
                                    default: next_state = INSTRUCTION_END;
                    endcase
                end
                else begin  //Low Power Mode
                    case (opcode)
                        /*0x01*/    `ASCON_ENC_DATA: next_state = PULL_DATA_FIFO;
                        /*0x02*/    `ASCON_ENC_DATA_LAST: next_state = PULL_DATA_FIFO;
                        /*0x03*/    `ASCON_ENC_TEXT: next_state = PULL_TXT_FIFO;
                        /*0x04*/    `ASCON_ENC_TEXT_LAST: next_state = PULL_TXT_FIFO;
                        /*0x05*/    `ASCON_A_ENC_DATA: next_state = PULL_DATA_FIFO;
                        /*0x06*/    `ASCON_A_ENC_DATA_LAST: next_state = PULL_DATA_FIFO;
                        /*0x07*/    `ASCON_A_ENC_TEXT: next_state = PULL_TXT_FIFO;
                        /*0x08*/    `ASCON_A_ENC_TEXT_LAST: next_state = PULL_TXT_FIFO;
                        /*0x09*/    `ASCON_HASH_MESSAGE: next_state = PULL_DATA_FIFO;
                        /*0x0A*/    `ASCON_SQUEEZE_HASH: next_state = REF_OUT_REG_HASH;
                        /*0x0B*/    `ASCON_INIT_SQUEEZE_HASH: next_state = PULL_DATA_FIFO;
                        /*0x0C*/    `ASCON_A_HASH_MESSAGE: next_state = PULL_DATA_FIFO;
                        /*0x0D*/    `ASCON_A_SQUEEZE_HASH: next_state = A_REF_OUT_REG_HASH;
                        /*0x0E*/    `ASCON_A_INIT_SQUEEZE_HASH: next_state = PULL_DATA_FIFO;
                        /*0x0F*/    `ASCON_DEC_DATA: next_state = PULL_DATA_FIFO;
                        /*0x10*/    `ASCON_DEC_DATA_LAST: next_state = PULL_DATA_FIFO;
                        /*0x11*/    `ASCON_DEC_TEXT: next_state = PULL_TXT_FIFO;
                        /*0x12*/    `ASCON_DEC_TEXT_LAST: next_state = PULL_TXT_FIFO;
                        /*0x13*/    `ASCON_A_DEC_DATA: next_state = PULL_DATA_FIFO;
                        /*0x14*/    `ASCON_A_DEC_DATA_LAST: next_state = PULL_DATA_FIFO;
                        /*0x15*/    `ASCON_A_DEC_TEXT: next_state = PULL_TXT_FIFO;
                        /*0x16*/    `ASCON_A_DEC_TEXT_LAST: next_state = PULL_TXT_FIFO;
                        /*0x17*/    `ASCON_A_TAG_CALC_ENC: next_state = PULL_TXT_FIFO;
                        /*0x18*/    `ASCON_TAG_CALC_ENC: next_state = PULL_TXT_FIFO;
                        /*0x19*/    `ASCON_A_TAG_CALC_DEC: next_state = PULL_TXT_FIFO;
                        /*0x1A*/    `ASCON_TAG_CALC_DEC: next_state = PULL_TXT_FIFO;
                        /*0x1B*/    `ASCON_A_HASH_INIT: next_state = PULL_DATA_FIFO;
                        /*0x1C*/    `ASCON_HASH_INIT: next_state = PULL_DATA_FIFO;
                        /*0x1D*/    `ASCON_A_INIT: next_state = LP_A_REF_ST_REG_LOOP_0_AEADIV;
                        /*0x1E*/    `ASCON_INIT: next_state = LP_REF_ST_REG_LOOP_0_AEADIV;
                        /*0x1F*/    `ASCON_DATA_FIFO_PUSH: next_state = PUSH_DATA_FIFO;
                        /*0x20*/    `ASCON_TEXT_IN_FIFO_PUSH: next_state = PUSH_TXT_FIFO;
                        /*0x21*/    `ASCON_TEXT_OUT_FIFO_PULL: next_state = PULL_OUT_FIFO;
                        /*0x22*/    `ASCON_TEXT_OUT_FIFO_PULL_DEC: next_state = PULL_OUT_FIFO_DEC;
                        /*0x23*/    `KEY_LOAD: next_state = KEY_LD;
                        /*0x24*/    `NONCE_LOAD: next_state = NONCE_LD;
                        /*0x25*/    `EXP_TAG_LOAD: next_state = EXP_TAG_LD;
                        ///*0x26*/    `DATA_BLK_LOAD: next_state = DATA_BLK_LD;
                        ///*0x27*/    `TXT_BLK_LOAD: next_state = TXT_BLK_LD;
                        ///*0x28*/    `END_OF_SESSION: next_state = SESSION_END_STATE;
                        /*0x00*/    `RESET: next_state = GLOBAL_RESET;
                                    default: next_state = INSTRUCTION_END;
                    endcase
                end
        end
//-------Fast States-------//
        F_REF_ST_REG_LOOP_2_MD: begin
                next_state = INSTRUCTION_END;
        end

        F_REF_ST_REG_LOOP_1_MD: begin
                next_state = F_REF_ST_REG_LOOP_2_ST;
        end

        F_REF_ST_REG_LOOP_2_xor01_MD: begin
                next_state = INSTRUCTION_END;
        end

        F_REF_ST_REG_LOOP_2_ST: begin
                case (opcode)
                        `ASCON_TAG_CALC_ENC: next_state = EN_TAG_REG;
                        `ASCON_TAG_CALC_DEC: next_state = EN_TAG_REG;
                        default: next_state = INSTRUCTION_END;
                endcase
        end

        F_REF_ST_REG_LOOP_1_HASHIV: begin
                next_state = F_REF_ST_REG_LOOP_2_ST;
        end

        F_REF_ST_REG_LOOP_1_ST: begin
                next_state = F_REF_ST_REG_LOOP_2_ST;
        end

        F_REF_ST_REG_LOOP_2_xorK0_PT: begin
                next_state = INSTRUCTION_END;
        end

        F_REF_ST_REG_LOOP_2_PT: begin
                next_state = INSTRUCTION_END;
        end

        F_REF_ST_REG_LOOP_1_PT: begin
                next_state = F_REF_ST_REG_LOOP_2_ST;
        end

        F_REF_ST_REG_LOOP_2_xorK0_CT: begin
                next_state = INSTRUCTION_END;
        end

        F_REF_ST_REG_LOOP_2_CT: begin
                next_state = INSTRUCTION_END;
        end

        F_REF_ST_REG_LOOP_1_CT: begin
                next_state = F_REF_ST_REG_LOOP_2_ST;
        end

        F_REF_ST_REG_LOOP_1_AEADIV: begin
                next_state = F_REF_ST_REG_LOOP_2_xor0K_ST;
        end

        F_REF_ST_REG_LOOP_2_xor0K_ST: begin
                next_state = INSTRUCTION_END;
        end

        F_A_REF_ST_REG_LOOP_1_MD: begin
                case (opcode)
                        `ASCON_A_ENC_DATA:       next_state = F_A_REF_ST_REG_LOOP_2_ST;
                        `ASCON_A_DEC_DATA:       next_state = F_A_REF_ST_REG_LOOP_2_ST;
                        `ASCON_A_HASH_MESSAGE:   next_state = F_A_REF_ST_REG_LOOP_2_ST;
                        `ASCON_A_ENC_DATA_LAST:  next_state = F_A_REF_ST_REG_LOOP_2_xor01_ST;
                        `ASCON_A_DEC_DATA_LAST:  next_state = F_A_REF_ST_REG_LOOP_2_xor01_ST;
                        default: next_state = INSTRUCTION_END;
                endcase
        end

        F_A_REF_ST_REG_LOOP_2_ST: begin
                next_state = INSTRUCTION_END;
        end

        F_A_REF_ST_REG_LOOP_2_xor01_ST: begin
                next_state = INSTRUCTION_END;
        end

        F_A_REF_ST_REG_LOOP_1_PA_MD: begin
                next_state = F_A_REF_ST_REG_LOOP_2_PA_ST;
        end

        F_A_REF_ST_REG_LOOP_2_PA_ST: begin
                case (opcode)
                        `ASCON_A_TAG_CALC_ENC:  next_state = EN_TAG_REG;
                        `ASCON_A_TAG_CALC_DEC:  next_state = EN_TAG_REG;
                        default: next_state = INSTRUCTION_END;
                endcase
        end

        F_A_REF_ST_REG_LOOP_1_HASHIV: begin
                next_state = F_A_REF_ST_REG_LOOP_2_ST;
        end

        F_A_REF_ST_REG_LOOP_1_ST: begin
                next_state = F_A_REF_ST_REG_LOOP_2_ST;
        end

        F_A_REF_ST_REG_LOOP_1_PT: begin
                case (opcode)
                        `ASCON_A_ENC_TEXT:       next_state = F_A_REF_ST_REG_LOOP_2_ST;
                        `ASCON_A_ENC_TEXT_LAST:  next_state = F_A_REF_ST_REG_LOOP_2_xorK0_ST;
                        default: next_state = INSTRUCTION_END;
                endcase
        end

        F_A_REF_ST_REG_LOOP_1_CT: begin
                case (opcode)
                        `ASCON_A_DEC_TEXT:       next_state = F_A_REF_ST_REG_LOOP_2_ST;
                        `ASCON_A_DEC_TEXT_LAST:  next_state = F_A_REF_ST_REG_LOOP_2_xorK0_ST;
                        default: next_state = INSTRUCTION_END;
                endcase
        end

        F_A_REF_ST_REG_LOOP_2_xorK0_ST: begin
                next_state = INSTRUCTION_END;
        end

        F_A_REF_ST_REG_LOOP_1_PA_PT: begin
                next_state = F_A_REF_ST_REG_LOOP_2_PA_ST;
        end

        F_A_REF_ST_REG_LOOP_1_PA_CT: begin
                next_state = F_A_REF_ST_REG_LOOP_2_PA_ST;
        end

        F_A_REF_ST_REG_LOOP_1_PA_AEADIV: begin
                next_state = F_REF_ST_REG_LOOP_2_xor0K_ST;
        end
//-------Low Power States-------//
        LP_REF_ST_REG_LOOP_0_MD: begin
               next_state = LP_SHARED_REF_ST_REG_LOOP_1_ST; 
        end

        LP_REF_ST_REG_LOOP_3_MD: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_4_ST;
        end

        LP_SHARED_REF_ST_REG_LOOP_1_ST: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_2_ST;
        end

        LP_SHARED_REF_ST_REG_LOOP_2_ST: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_3_ST;
        end

        LP_SHARED_REF_ST_REG_LOOP_3_ST: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_4_ST;
        end

        LP_SHARED_REF_ST_REG_LOOP_4_ST: begin
                case (opcode)
                        `ASCON_A_ENC_DATA_LAST: next_state = LP_A_REF_ST_REG_LOOP_5_xor01_ST;
                        `ASCON_A_DEC_DATA_LAST: next_state = LP_A_REF_ST_REG_LOOP_5_xor01_ST;
                        `ASCON_A_ENC_TEXT_LAST: next_state = LP_A_REF_ST_REG_LOOP_5_xorK0_ST;
                        `ASCON_A_DEC_TEXT_LAST: next_state = LP_A_REF_ST_REG_LOOP_5_xorK0_ST;
                        `ASCON_A_INIT: next_state = LP_A_REF_ST_REG_LOOP_5_xor0K_ST;
                        `ASCON_ENC_DATA_LAST: next_state = LP_REF_ST_REG_LOOP_5_xor01_ST;
                        `ASCON_DEC_DATA_LAST: next_state = LP_REF_ST_REG_LOOP_5_xor01_ST;
                        `ASCON_ENC_TEXT_LAST: next_state = LP_REF_ST_REG_LOOP_5_xorK0_ST;
                        `ASCON_DEC_TEXT_LAST: next_state = LP_REF_ST_REG_LOOP_5_xorK0_ST;
                        `ASCON_INIT: next_state = LP_REF_ST_REG_LOOP_5_xor0K_ST;
                        default: next_state = LP_SHARED_REF_ST_REG_LOOP_5_ST;
                endcase
        end

        LP_SHARED_REF_ST_REG_LOOP_5_ST: begin
                case (opcode)
                        `ASCON_A_TAG_CALC_ENC: next_state = EN_TAG_REG;
                        `ASCON_TAG_CALC_ENC: next_state = EN_TAG_REG;
                        `ASCON_A_TAG_CALC_DEC: next_state = EN_TAG_REG;
                        `ASCON_TAG_CALC_DEC: next_state = EN_TAG_REG;
                        default: next_state = INSTRUCTION_END;
                endcase
        end

        LP_REF_ST_REG_LOOP_5_xorK0_ST: begin
                next_state = INSTRUCTION_END;
        end

        LP_REF_ST_REG_LOOP_5_xor0K_ST: begin
                next_state = INSTRUCTION_END;
        end

        LP_REF_ST_REG_LOOP_5_xor01_ST: begin
                next_state = INSTRUCTION_END;
        end

        LP_REF_ST_REG_LOOP_0_HASHIV: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_1_ST;
        end

        LP_SHARED_REF_ST_REG_LOOP_0_ST: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_1_ST;
        end

        LP_REF_ST_REG_LOOP_3_PT: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_4_ST;
        end

        LP_REF_ST_REG_LOOP_0_PT: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_1_ST;
        end

        LP_REF_ST_REG_LOOP_3_CT: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_4_ST;
        end

        LP_REF_ST_REG_LOOP_0_CT: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_1_ST;
        end

        LP_REF_ST_REG_LOOP_0_AEADIV: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_1_ST;
        end

        LP_A_REF_ST_REG_LOOP_2_HASHIV: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_3_ST;
        end

        LP_A_REF_ST_REG_LOOP_2_PT: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_3_ST;
        end

        LP_A_REF_ST_REG_LOOP_0_PT: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_1_ST;
        end

        LP_A_REF_ST_REG_LOOP_2_CT: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_3_ST;
        end

        LP_A_REF_ST_REG_LOOP_0_CT: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_1_ST;
        end

        LP_A_REF_ST_REG_LOOP_0_AEADIV: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_1_ST;
        end

        LP_A_REF_ST_REG_LOOP_5_xorK0_ST: begin
                next_state = INSTRUCTION_END;
        end

        LP_A_REF_ST_REG_LOOP_5_xor0K_ST: begin
                next_state = INSTRUCTION_END;
        end

        LP_A_REF_ST_REG_LOOP_5_xor01_ST: begin
                next_state = INSTRUCTION_END;
        end

        LP_A_REF_ST_REG_LOOP_2_MD: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_3_ST;
        end

        LP_A_REF_ST_REG_LOOP_0_MD: begin
                next_state = LP_SHARED_REF_ST_REG_LOOP_1_ST;
        end
//-------Common States-------//
        PULL_TXT_FIFO: begin
                    case (opcode)   
                        /*0x03*/    `ASCON_ENC_TEXT: next_state = REF_OUT_REG_AEAD;
                        /*0x04*/    `ASCON_ENC_TEXT_LAST: next_state = REF_OUT_REG_AEAD;
                        /*0x07*/    `ASCON_A_ENC_TEXT: next_state = A_REF_OUT_REG_AEAD;
                        /*0x08*/    `ASCON_A_ENC_TEXT_LAST: next_state = A_REF_OUT_REG_AEAD;
                        /*0x11*/    `ASCON_DEC_TEXT: next_state = REF_OUT_REG_AEAD;
                        /*0x12*/    `ASCON_DEC_TEXT_LAST: next_state = REF_OUT_REG_AEAD;
                        /*0x15*/    `ASCON_A_DEC_TEXT: next_state = A_REF_OUT_REG_AEAD;
                        /*0x16*/    `ASCON_A_DEC_TEXT_LAST: next_state = A_REF_OUT_REG_AEAD;
                        /*0x17*/    `ASCON_A_TAG_CALC_ENC: next_state = A_REF_OUT_REG_AEAD;
                        /*0x18*/    `ASCON_TAG_CALC_ENC: next_state = REF_OUT_REG_AEAD;
                        /*0x19*/    `ASCON_A_TAG_CALC_DEC: next_state = A_REF_OUT_REG_AEAD;
                        /*0x1A*/    `ASCON_TAG_CALC_DEC: next_state = REF_OUT_REG_AEAD;
                                    default: next_state = INSTRUCTION_END;
                    endcase
        end

        PULL_DATA_FIFO: begin
                if (comp_fast_reg) begin
                    case (opcode)   
                        /*0x01*/    `ASCON_ENC_DATA: next_state = F_REF_ST_REG_LOOP_2_MD;
                        /*0x02*/    `ASCON_ENC_DATA_LAST: next_state = F_REF_ST_REG_LOOP_2_xor01_MD;
                        /*0x05*/    `ASCON_A_ENC_DATA: next_state = F_A_REF_ST_REG_LOOP_1_MD;
                        /*0x06*/    `ASCON_A_ENC_DATA_LAST: next_state = F_A_REF_ST_REG_LOOP_1_MD;
                        /*0x09*/    `ASCON_HASH_MESSAGE: next_state = F_REF_ST_REG_LOOP_1_MD;
                        /*0x0B*/    `ASCON_INIT_SQUEEZE_HASH: next_state = F_REF_ST_REG_LOOP_1_MD;
                        /*0x0C*/    `ASCON_A_HASH_MESSAGE: next_state = F_A_REF_ST_REG_LOOP_1_MD;
                        /*0x0E*/    `ASCON_A_INIT_SQUEEZE_HASH: next_state = F_A_REF_ST_REG_LOOP_1_PA_MD;
                        /*0x0F*/    `ASCON_DEC_DATA: next_state = F_REF_ST_REG_LOOP_2_MD;
                        /*0x10*/    `ASCON_DEC_DATA_LAST: next_state = F_REF_ST_REG_LOOP_2_xor01_MD;
                        /*0x13*/    `ASCON_A_DEC_DATA: next_state = F_A_REF_ST_REG_LOOP_1_MD;
                        /*0x14*/    `ASCON_A_DEC_DATA_LAST: next_state = F_A_REF_ST_REG_LOOP_1_MD;
                        /*0x1B*/    `ASCON_A_HASH_INIT: next_state = F_A_REF_ST_REG_LOOP_1_HASHIV;
                        /*0x1C*/    `ASCON_HASH_INIT: next_state = F_REF_ST_REG_LOOP_1_HASHIV;
                                    default: next_state = INSTRUCTION_END;
                    endcase
                end
                else begin
                    case (opcode)   
                        /*0x01*/    `ASCON_ENC_DATA: next_state = LP_REF_ST_REG_LOOP_3_MD;
                        /*0x02*/    `ASCON_ENC_DATA_LAST: next_state = LP_REF_ST_REG_LOOP_3_MD;
                        /*0x05*/    `ASCON_A_ENC_DATA: next_state = LP_A_REF_ST_REG_LOOP_2_MD;
                        /*0x06*/    `ASCON_A_ENC_DATA_LAST: next_state = LP_A_REF_ST_REG_LOOP_2_MD;
                        /*0x09*/    `ASCON_HASH_MESSAGE: next_state = LP_REF_ST_REG_LOOP_0_MD;
                        /*0x0B*/    `ASCON_INIT_SQUEEZE_HASH: next_state = LP_REF_ST_REG_LOOP_0_MD;
                        /*0x0C*/    `ASCON_A_HASH_MESSAGE: next_state = LP_A_REF_ST_REG_LOOP_2_MD;
                        /*0x0E*/    `ASCON_A_INIT_SQUEEZE_HASH: next_state = LP_A_REF_ST_REG_LOOP_0_MD;
                        /*0x0F*/    `ASCON_DEC_DATA: next_state = LP_REF_ST_REG_LOOP_3_MD;
                        /*0x10*/    `ASCON_DEC_DATA_LAST: next_state = LP_REF_ST_REG_LOOP_3_MD;
                        /*0x13*/    `ASCON_A_DEC_DATA: next_state = LP_A_REF_ST_REG_LOOP_2_MD;
                        /*0x14*/    `ASCON_A_DEC_DATA_LAST: next_state = LP_A_REF_ST_REG_LOOP_2_MD;
                        /*0x1B*/    `ASCON_A_HASH_INIT: next_state = LP_A_REF_ST_REG_LOOP_2_HASHIV;
                        /*0x1C*/    `ASCON_HASH_INIT: next_state = LP_REF_ST_REG_LOOP_0_HASHIV;
                                    default: next_state = INSTRUCTION_END;
                    endcase
                end
        end

        REF_OUT_REG_HASH: begin
            next_state = PUSH_OUT_FIFO;
        end

        A_REF_OUT_REG_HASH: begin
            next_state = PUSH_OUT_FIFO;
        end

        REF_OUT_REG_AEAD: begin  
            next_state = PUSH_OUT_FIFO;
        end

        A_REF_OUT_REG_AEAD: begin
            next_state = PUSH_OUT_FIFO;
        end

        PUSH_OUT_FIFO: begin
            if (comp_fast_reg) begin
                case (opcode)
                    /*0x03*/    `ASCON_ENC_TEXT: next_state = F_REF_ST_REG_LOOP_2_PT;
                    /*0x04*/    `ASCON_ENC_TEXT_LAST: next_state = F_REF_ST_REG_LOOP_2_xorK0_PT;
                    /*0x07*/    `ASCON_A_ENC_TEXT: next_state = F_A_REF_ST_REG_LOOP_1_PT;
                    /*0x08*/    `ASCON_A_ENC_TEXT_LAST: next_state = F_A_REF_ST_REG_LOOP_1_PT;
                    /*0x11*/    `ASCON_DEC_TEXT: next_state = F_REF_ST_REG_LOOP_2_CT;
                    /*0x12*/    `ASCON_DEC_TEXT_LAST: next_state = F_REF_ST_REG_LOOP_2_xorK0_CT;
                    /*0x15*/    `ASCON_A_DEC_TEXT: next_state = F_A_REF_ST_REG_LOOP_1_CT;
                    /*0x16*/    `ASCON_A_DEC_TEXT_LAST: next_state = F_A_REF_ST_REG_LOOP_1_CT;
                    /*0x17*/    `ASCON_A_TAG_CALC_ENC: next_state = F_A_REF_ST_REG_LOOP_1_PA_PT;
                    /*0x18*/    `ASCON_TAG_CALC_ENC: next_state = F_REF_ST_REG_LOOP_1_PT;
                    /*0x19*/    `ASCON_A_TAG_CALC_DEC: next_state = F_A_REF_ST_REG_LOOP_1_PA_CT;
                    /*0x1A*/    `ASCON_TAG_CALC_DEC: next_state = F_REF_ST_REG_LOOP_1_CT;
                    /*0x0D*/    `ASCON_A_SQUEEZE_HASH: next_state = F_A_REF_ST_REG_LOOP_1_ST;
                    /*0x0A*/    `ASCON_SQUEEZE_HASH: next_state = F_REF_ST_REG_LOOP_1_ST;
                                default: next_state = INSTRUCTION_END;
                endcase
            end
            else begin
                case (opcode)
                    /*0x03*/    `ASCON_ENC_TEXT: next_state = LP_REF_ST_REG_LOOP_3_PT;
                    /*0x04*/    `ASCON_ENC_TEXT_LAST: next_state = LP_REF_ST_REG_LOOP_3_PT;
                    /*0x07*/    `ASCON_A_ENC_TEXT: next_state = LP_A_REF_ST_REG_LOOP_2_PT;
                    /*0x08*/    `ASCON_A_ENC_TEXT_LAST: next_state = LP_A_REF_ST_REG_LOOP_2_PT;
                    /*0x11*/    `ASCON_DEC_TEXT: next_state = LP_REF_ST_REG_LOOP_3_CT;
                    /*0x12*/    `ASCON_DEC_TEXT_LAST: next_state = LP_REF_ST_REG_LOOP_3_CT;
                    /*0x15*/    `ASCON_A_DEC_TEXT: next_state = LP_A_REF_ST_REG_LOOP_2_CT;
                    /*0x16*/    `ASCON_A_DEC_TEXT_LAST: next_state = LP_A_REF_ST_REG_LOOP_2_CT;
                    /*0x17*/    `ASCON_A_TAG_CALC_ENC: next_state = LP_A_REF_ST_REG_LOOP_0_PT;
                    /*0x18*/    `ASCON_TAG_CALC_ENC: next_state = LP_REF_ST_REG_LOOP_0_PT;
                    /*0x19*/    `ASCON_A_TAG_CALC_DEC: next_state = LP_A_REF_ST_REG_LOOP_0_CT;
                    /*0x1A*/    `ASCON_TAG_CALC_DEC: next_state = LP_REF_ST_REG_LOOP_0_CT;
                    /*0x0D*/    `ASCON_A_SQUEEZE_HASH: next_state = LP_SHARED_REF_ST_REG_LOOP_0_ST;
                    /*0x0A*/    `ASCON_SQUEEZE_HASH: next_state = LP_SHARED_REF_ST_REG_LOOP_0_ST;
                                default: next_state = INSTRUCTION_END;
                endcase
            end

        end

        EN_TAG_REG: begin
            next_state = INSTRUCTION_END;
        end

        KEY_LD: begin
            next_state = INSTRUCTION_END;
        end

        NONCE_LD: begin
            next_state = INSTRUCTION_END;
        end

        EXP_TAG_LD: begin
            next_state = INSTRUCTION_END;
        end

        /*TXT_BLK_LD: begin
            next_state = INSTRUCTION_END;
        end*/

        /*DATA_BLK_LD: begin
            next_state = INSTRUCTION_END;
        end*/

        PUSH_TXT_FIFO: begin
            next_state = INSTRUCTION_END;
        end

        PUSH_DATA_FIFO: begin
            next_state = INSTRUCTION_END;
        end

        PULL_OUT_FIFO: begin
            next_state = INSTRUCTION_END;
        end

        PULL_OUT_FIFO_DEC: begin
            next_state = INSTRUCTION_END;
        end

        GLOBAL_RESET: begin
            next_state = INSTRUCTION_END;
        end

        INSTRUCTION_END: begin
            next_state = IDLE;
        end

        /*SESSION_END_STATE: begin        //Exit State Only in case of HW Reset
            next_state = SESSION_END_STATE;
        end*/



    endcase
end


//Output Logic
always @(current_state) begin
    case (current_state)
        IDLE: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_2_MD: begin
                txt_data_sel = 1'b1;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_1_MD: begin
                txt_data_sel = 1'b1;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_2_xor01_MD: begin
                txt_data_sel = 1'b1;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b01;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_2_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_1_HASHIV: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_1_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_2_xorK0_PT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b1;
                permutation_output_sel = 2'b11;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_2_PT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_1_PT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_2_xorK0_CT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b11;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b1;
                permutation_output_sel = 2'b11;
                enc_dec = 1'b1;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_2_CT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b11;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b1;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_1_CT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b11;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b1;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_1_AEADIV: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b1;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_REF_ST_REG_LOOP_2_xor0K_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b11;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_1_MD: begin
                txt_data_sel = 1'b1;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b1;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_2_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;//Changed
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b1;
                p_out_sel = 1'b1;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_2_xor01_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b01;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b1;
                p_out_sel = 1'b1;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_1_PA_MD: begin
                txt_data_sel = 1'b1;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_2_PA_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_1_HASHIV: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b1;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_1_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b1;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_1_PT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b1;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_1_CT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b11;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b1;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b1;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_2_xorK0_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b1;
                permutation_output_sel = 2'b11;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b1;
                p_out_sel = 1'b1;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_1_PA_PT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_1_PA_CT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b11;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b1;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        F_A_REF_ST_REG_LOOP_1_PA_AEADIV: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b1;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b111111;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_REF_ST_REG_LOOP_0_MD: begin
                txt_data_sel = 1'b1;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_REF_ST_REG_LOOP_3_MD: begin
                txt_data_sel = 1'b1;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b011;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_SHARED_REF_ST_REG_LOOP_1_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b001;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_SHARED_REF_ST_REG_LOOP_2_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b010;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_SHARED_REF_ST_REG_LOOP_3_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b011;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_SHARED_REF_ST_REG_LOOP_4_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b100;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_SHARED_REF_ST_REG_LOOP_5_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b101;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_REF_ST_REG_LOOP_5_xorK0_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b101;
                key_zero_exp_sel = 1'b1;
                permutation_output_sel = 2'b11;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end
        /*************************************************/
        LP_REF_ST_REG_LOOP_5_xor0K_ST: begin             //
                txt_data_sel = 1'b0;                     //
                initial_state_sel = 1'b0;                //
                permutation_input_sel = 2'b10;           //
                loop_num = 3'b101;                       //
                key_zero_exp_sel = 1'b0;                 //
                permutation_output_sel = 2'b11;          //
                enc_dec = 1'b0;                          //
                out_reg_en = 1'b0;                       //
                permutation_category = 1'b0;             //
                const_sel = 1'b0;                        //
                p_out_sel = 1'b1;                      //
                //enable_array = 6'b110000;              //
                hash_aead = 1'b0;                        //
                exp_tag_en = 1'b0;                       //
                key_en = 1'b0;                           //
                nonce_en = 1'b0;                         //
                glob_out_reg_en = 1'b0;                  //
                ready = 1'b0;                            //
                tag_reg_en = 1'b0;                       //
                txt_FIFO_in_write = 1'b0;                //
                txt_FIFO_in_read = 1'b0;                 //
                ad_FIFO_in_write = 1'b0;                 //
                ad_FIFO_in_read = 1'b0;                  //
                txt_FIFO_out_write = 1'b0;               //
                txt_FIFO_out_read = 1'b0;                //
                state_reg_en = 1'b1;                     //
                ////txt_blk_en = 1'b0;                   //
                //data_blk_en = 1'b0;                    //
                next = 1'b0;                             //
                rstn = 1'b1;                             //
        
        end
        /*************************************************/
        LP_REF_ST_REG_LOOP_5_xor01_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b101;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b01;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_REF_ST_REG_LOOP_0_HASHIV: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_SHARED_REF_ST_REG_LOOP_0_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_REF_ST_REG_LOOP_3_PT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b011;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_REF_ST_REG_LOOP_0_PT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_REF_ST_REG_LOOP_3_CT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b11;
                loop_num = 3'b011;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b1;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_REF_ST_REG_LOOP_0_CT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b11;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b1;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_REF_ST_REG_LOOP_0_AEADIV: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b1;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_2_HASHIV: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_2_PT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b010;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_0_PT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_2_CT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b11;
                loop_num = 3'b010;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b1;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_0_CT: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b11;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b1;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_0_AEADIV: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b1;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_5_xorK0_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b101;
                key_zero_exp_sel = 1'b1;
                permutation_output_sel = 2'b11;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_5_xor0K_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b101;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b11;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_5_xor01_ST: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b10;
                loop_num = 3'b101;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b01;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_2_MD: begin
                txt_data_sel = 1'b1;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b010;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        LP_A_REF_ST_REG_LOOP_0_MD: begin
                txt_data_sel = 1'b1;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b01;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b10;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b1;
                //enable_array = 6'b110000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b1;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        PULL_TXT_FIFO: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b1;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        PULL_DATA_FIFO: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b1;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        REF_OUT_REG_HASH: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b1;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        A_REF_OUT_REG_HASH: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b1;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        REF_OUT_REG_AEAD: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b1;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b1;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        A_REF_OUT_REG_AEAD: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b1;
                permutation_category = 1'b1;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b1;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        PUSH_OUT_FIFO: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b1;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        EN_TAG_REG: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b1;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        KEY_LD: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b1;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        NONCE_LD: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b1;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        EXP_TAG_LD: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b1;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        /*TXT_BLK_LD: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b0;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b1;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        DATA_BLK_LD: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b0;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                //////txt_blk_en = 1'b0;
                //data_blk_en = 1'b1;
                next = 1'b0;
                rstn = 1'b1;
        
        end*/

        PUSH_TXT_FIFO: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b1;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                //////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        PUSH_DATA_FIFO: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b1;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        PULL_OUT_FIFO: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b1;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b1;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        PULL_OUT_FIFO_DEC: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b1;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b1;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b1;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

        GLOBAL_RESET: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b0;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b0;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b0;
        
        end

        INSTRUCTION_END: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b0;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b0;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b1;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b1;
                rstn = 1'b1;
        
        end

        /*SESSION_END_STATE: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end*/
        default: begin
                txt_data_sel = 1'b0;
                initial_state_sel = 1'b0;
                permutation_input_sel = 2'b00;
                loop_num = 3'b000;
                key_zero_exp_sel = 1'b0;
                permutation_output_sel = 2'b00;
                enc_dec = 1'b0;
                out_reg_en = 1'b0;
                permutation_category = 1'b0;
                const_sel = 1'b0;
                p_out_sel = 1'b0;
                //enable_array = 6'b000000;
                hash_aead = 1'b0;
                exp_tag_en = 1'b0;
                key_en = 1'b0;
                nonce_en = 1'b0;
                glob_out_reg_en = 1'b0;
                ready = 1'b0;
                tag_reg_en = 1'b0;
                txt_FIFO_in_write = 1'b0;
                txt_FIFO_in_read = 1'b0;
                ad_FIFO_in_write = 1'b0;
                ad_FIFO_in_read = 1'b0;
                txt_FIFO_out_write = 1'b0;
                txt_FIFO_out_read = 1'b0;
                state_reg_en = 1'b0;
                ////txt_blk_en = 1'b0;
                //data_blk_en = 1'b0;
                next = 1'b0;
                rstn = 1'b1;
        
        end

    endcase
end

endmodule
