`include "Opcodes.v"
`timescale 1ns/1ps

module Tag_Equality_Check (
    input [127:0] exp_tag,
    input [127:0] created_tag,
    output is_equal
);

assign is_equal = (created_tag==exp_tag)? 1'b1 : 1'b0;
    
endmodule


module ASCON_System #(
    parameter width=128,
    parameter opcode_width = 6
) (
    //input [127:0] expected_tag,
    input compact_fast,
    //input [127:0] key_nonce_expTag,
    //input [127:0] nonce,
    //input [width-1:0] data_txt_block,
    input [width-1:0] shared_input,
    //input [width-1:0] txt_block,
    input [opcode_width-1:0] instruction,
    input txt_blk_en, data_blk_en,
    input clk, rstn,

    output [10:0] status_reg,
    output [127:0] tag,
    output [width-1:0] ascon_out
);
    
    reg [127:0] expected_tag_reg;
    reg [127:0] key_reg;
    reg [127:0] nonce_reg;
    reg [width-1:0] data_blk_reg;
    reg [width-1:0] txt_blk_reg;

    reg [opcode_width-1:0] instruction_reg;

    //wire txt_blk_en, data_blk_en;

    wire exp_tag_en, key_en, nonce_en, tag_check, ready, tag_reg_en, next, glob_out_reg_en;    //Register Enables   //For Data and Txt txt/data_in_en & ready

    wire [width-1:0] core_txt_in, core_data_in, core_txt_out;
    
    wire txt_FIFO_in_write, txt_FIFO_in_read,  ad_FIFO_in_write, ad_FIFO_in_read, txt_FIFO_out_write, txt_FIFO_out_read; //FIFO Control Signals
    
    wire txt_FIFO_in_full, txt_FIFO_in_empty, txt_FIFO_in_last, ad_FIFO_in_full, ad_FIFO_in_empty, ad_FIFO_in_last, txt_FIFO_out_full, txt_FIFO_out_empty, txt_FIFO_out_last; //FIFO Status Signals
    
    wire txt_data_sel, initial_state_sel; 
    wire [1:0] permutation_input_sel;
    wire [2:0] loop_num;
    wire permutation_category, const_sel, key_zero_exp_sel; 
    wire [1:0] permutation_output_sel; 
    wire enc_dec, out_reg_en, hash_aead; //Rest Control Signals
    wire reg_rstn;
    wire stat_reg_en;
    wire p_out_sel;
    wire [5:0] enable_array;
    
    
    //always @(posedge clk or negedge rstn) begin
        //if(!rstn) status_reg <= 11'b01001001000; //FIFOs Empty and tag_chec, next =0
        assign status_reg = {ad_FIFO_in_full, ad_FIFO_in_empty, ad_FIFO_in_last, txt_FIFO_in_full, txt_FIFO_in_empty, txt_FIFO_in_last, txt_FIFO_out_full, txt_FIFO_out_empty, txt_FIFO_out_last, tag_check, next};
    //end    

    always @(posedge clk or negedge reg_rstn) begin //Input Registers
        if(!reg_rstn) begin
            expected_tag_reg <= 128'h00000000000000000000000000000000;
            key_reg <= 128'h00000000000000000000000000000000;
            nonce_reg <= 128'h00000000000000000000000000000000;
            //instruction_reg = `RESET;
        end
        else begin
            if (exp_tag_en) expected_tag_reg <= shared_input;
            
            if (key_en) key_reg <= shared_input;

            if (nonce_en) nonce_reg <= shared_input;

            //if (next) instruction_reg = instruction;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin 
            instruction_reg <= `RESET;
        end
        else begin 
            if (next) instruction_reg <= instruction;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin 
            data_blk_reg <= {width{1'b0}};
            txt_blk_reg <= {width{1'b0}};
        end
        else begin 
            if (data_blk_en) data_blk_reg <= shared_input;
            
            if (txt_blk_en) txt_blk_reg <= shared_input;
        end
    end

    Tag_Equality_Check tag_eq ( //Tag_Check Circuit
        .exp_tag(expected_tag_reg),
        .created_tag(tag),
        .is_equal(tag_check)
    );

    Ctrl_Circuit instr_decode(  //Ctrl Circ
            .clk(clk),                                      
            .rstn_ctrl(rstn),                                       
            .opcode(instruction_reg),                                       
            .txt_data_sel(txt_data_sel),                                        
            .initial_state_sel(initial_state_sel),                                      
            .permutation_input_sel(permutation_input_sel),                                      
            .loop_num(loop_num),                                        
            .permutation_category(permutation_category),                                        
            .key_zero_exp_sel(key_zero_exp_sel),                                        
            .permutation_output_sel(permutation_output_sel),                                        
            .enc_dec(enc_dec),                                      
            .out_reg_en(out_reg_en),                                        
            .hash_aead(hash_aead),                                      
            .exp_tag_en(exp_tag_en),                                        
            .key_en(key_en),                                        
            .nonce_en(nonce_en),                                        
            .glob_out_reg_en(glob_out_reg_en),                                      
            .ready(ready),                                      
            .tag_reg_en(tag_reg_en),                                        
            .txt_FIFO_in_write(txt_FIFO_in_write),                                      
            .txt_FIFO_in_read(txt_FIFO_in_read),                                        
            .ad_FIFO_in_write(ad_FIFO_in_write),                                        
            .ad_FIFO_in_read(ad_FIFO_in_read),                                      
            .txt_FIFO_out_write(txt_FIFO_out_write),                                        
            .txt_FIFO_out_read(txt_FIFO_out_read),                                      
            .state_reg_en(stat_reg_en),                                     
            .next(next),                                        
            .rstn(reg_rstn),                                        
            //.txt_blk_en(txt_blk_en),                                        
            //.data_blk_en(data_blk_en),                                      
            .compact_fast(compact_fast),
            .const_sel(const_sel),   
            .p_out_sel(p_out_sel),   
            .enable_array(enable_array)                                     
    );


    input_fifo #(.width(width)) ad_FIFO(
        .clk(clk),
        .rstn(reg_rstn),
        .w_en(ad_FIFO_in_write),
        .r_en(ad_FIFO_in_read),
        .data_in(data_blk_reg),
        .data_out(core_data_in),
        .full(ad_FIFO_in_full),
        .empty(ad_FIFO_in_empty),
        .last(ad_FIFO_in_last)
    );

    input_fifo #(.width(width)) txt_FIFO(
        .clk(clk),
        .rstn(reg_rstn),
        .w_en(txt_FIFO_in_write),
        .r_en(txt_FIFO_in_read),
        .data_in(txt_blk_reg),
        .data_out(core_txt_in),
        .full(txt_FIFO_in_full),
        .empty(txt_FIFO_in_empty),
        .last(txt_FIFO_in_last)
    );

    output_fifo #(.width(width)) txt_FIFO_out(
        .clk(clk),
        .rstn(reg_rstn),
        .w_en(txt_FIFO_out_write),
        .r_en(txt_FIFO_out_read),
        .data_in(core_txt_out),
        .tag_check(tag_check),
        .enc_dec(enc_dec),
        .data_out(ascon_out),
        .full(txt_FIFO_out_full),
        .empty(txt_FIFO_out_empty),
        .last(txt_FIFO_out_last)
    );


    ASCON_Core core (
        .Key(key_reg),
        .Nonce(nonce_reg),
        .data_block(core_data_in),
        .txt_block(core_txt_in),
        .txt_data_sel(txt_data_sel),
        .initial_state_sel(initial_state_sel),
        .permutation_input_sel(permutation_input_sel),
        .loop_num(loop_num),
        .key_zero_exp_sel(key_zero_exp_sel),
        .permutation_output_sel(permutation_output_sel),
        .enc_dec(enc_dec),
        .tag_reg_en(tag_reg_en),
        .out_reg_en(out_reg_en),
        .stat_reg_en(stat_reg_en),
        .hash_aead(hash_aead),
        .permutation_category(permutation_category),
        .const_sel(const_sel),
        .p_out_sel(p_out_sel),
        .enable_array(enable_array),
        .compact_fast(compact_fast),
        .clk(clk), .rstn(reg_rstn),
        .output_reg(core_txt_out),
        .tag_reg(tag)
    );



endmodule

module ASCON_System_no_io_compression #(
    parameter width=128,
    parameter opcode_width = 6
) (
    input [127:0] expected_tag,
    input compact_fast,
    input [127:0] key,
    input [127:0] nonce,
    input [width-1:0] data_block,
    input [width-1:0] txt_block,
    input [opcode_width-1:0] instruction,
    input clk, rstn,
    input txt_blk_en, data_blk_en,

    output [10:0] status_reg,
    output [127:0] tag,
    output [width-1:0] ascon_out
);
    
    reg [127:0] expected_tag_reg;
    reg [127:0] key_reg;
    reg [127:0] nonce_reg;
    reg [width-1:0] data_blk_reg;
    reg [width-1:0] txt_blk_reg;

    reg [opcode_width-1:0] instruction_reg;


    wire exp_tag_en, key_en, nonce_en, tag_check, ready, tag_reg_en, next, glob_out_reg_en;    //Register Enables   //For Data and Txt txt/data_in_en & ready

    wire [width-1:0] core_txt_in, core_data_in, core_txt_out;
    
    wire txt_FIFO_in_write, txt_FIFO_in_read,  ad_FIFO_in_write, ad_FIFO_in_read, txt_FIFO_out_write, txt_FIFO_out_read; //FIFO Control Signals
    
    wire txt_FIFO_in_full, txt_FIFO_in_empty, txt_FIFO_in_last, ad_FIFO_in_full, ad_FIFO_in_empty, ad_FIFO_in_last, txt_FIFO_out_full, txt_FIFO_out_empty, txt_FIFO_out_last; //FIFO Status Signals
    
    wire txt_data_sel, initial_state_sel; 
    wire [1:0] permutation_input_sel;
    wire [2:0] loop_num;
    wire permutation_category, const_sel, key_zero_exp_sel; 
    wire [1:0] permutation_output_sel; 
    wire enc_dec, out_reg_en, hash_aead; //Rest Control Signals
    wire reg_rstn;
    wire stat_reg_en;
    wire p_out_sel;
    wire [5:0] enable_array;
    
    
    //always @(posedge clk or negedge rstn) begin
        //if(!rstn) status_reg <= 11'b01001001000; //FIFOs Empty and tag_chec, next =0
        assign status_reg = {ad_FIFO_in_full, ad_FIFO_in_empty, ad_FIFO_in_last, txt_FIFO_in_full, txt_FIFO_in_empty, txt_FIFO_in_last, txt_FIFO_out_full, txt_FIFO_out_empty, txt_FIFO_out_last, tag_check, next};
    //end    

    always @(posedge clk or negedge reg_rstn) begin //Input Registers
        if(!reg_rstn) begin
            expected_tag_reg <= 128'h00000000000000000000000000000000;
            key_reg <= 128'h00000000000000000000000000000000;
            nonce_reg <= 128'h00000000000000000000000000000000;
            //instruction_reg = `RESET;
        end
        else begin
            if (exp_tag_en) expected_tag_reg <= expected_tag;
            
            if (key_en) key_reg <= key;

            if (nonce_en) nonce_reg <= nonce;

            //if (next) instruction_reg = instruction;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin 
            instruction_reg <= `RESET;
        end
        else begin 
            if (next) instruction_reg <= instruction;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin 
            data_blk_reg <= {width{1'b0}};
            txt_blk_reg <= {width{1'b0}};
        end
        else begin 
            if (data_blk_en) data_blk_reg <= data_block;
            
            if (txt_blk_en) txt_blk_reg <= txt_block;
        end
    end

    Tag_Equality_Check tag_eq ( //Tag_Check Circuit
        .exp_tag(expected_tag_reg),
        .created_tag(tag),
        .is_equal(tag_check)
    );

    Ctrl_Circuit instr_decode(  //Ctrl Circ
            .clk(clk),                                      
            .rstn_ctrl(rstn),                                       
            .opcode(instruction_reg),                                       
            .txt_data_sel(txt_data_sel),                                        
            .initial_state_sel(initial_state_sel),                                      
            .permutation_input_sel(permutation_input_sel),                                      
            .loop_num(loop_num),                                        
            .permutation_category(permutation_category),                                        
            .key_zero_exp_sel(key_zero_exp_sel),                                        
            .permutation_output_sel(permutation_output_sel),                                        
            .enc_dec(enc_dec),                                      
            .out_reg_en(out_reg_en),                                        
            .hash_aead(hash_aead),                                      
            .exp_tag_en(exp_tag_en),                                        
            .key_en(key_en),                                        
            .nonce_en(nonce_en),                                        
            .glob_out_reg_en(glob_out_reg_en),                                      
            .ready(ready),                                      
            .tag_reg_en(tag_reg_en),                                        
            .txt_FIFO_in_write(txt_FIFO_in_write),                                      
            .txt_FIFO_in_read(txt_FIFO_in_read),                                        
            .ad_FIFO_in_write(ad_FIFO_in_write),                                        
            .ad_FIFO_in_read(ad_FIFO_in_read),                                      
            .txt_FIFO_out_write(txt_FIFO_out_write),                                        
            .txt_FIFO_out_read(txt_FIFO_out_read),                                      
            .state_reg_en(stat_reg_en),                                     
            .next(next),                                        
            .rstn(reg_rstn),                                        
            //.txt_blk_en(txt_blk_en),                                        
            //.data_blk_en(data_blk_en),                                      
            .compact_fast(compact_fast),
            .const_sel(const_sel),   
            .p_out_sel(p_out_sel),   
            .enable_array(enable_array)                                     
    );


    input_fifo #(.width(width)) ad_FIFO(
        .clk(clk),
        .rstn(reg_rstn),
        .w_en(ad_FIFO_in_write),
        .r_en(ad_FIFO_in_read),
        .data_in(data_blk_reg),
        .data_out(core_data_in),
        .full(ad_FIFO_in_full),
        .empty(ad_FIFO_in_empty),
        .last(ad_FIFO_in_last)
    );

    input_fifo #(.width(width)) txt_FIFO(
        .clk(clk),
        .rstn(reg_rstn),
        .w_en(txt_FIFO_in_write),
        .r_en(txt_FIFO_in_read),
        .data_in(txt_blk_reg),
        .data_out(core_txt_in),
        .full(txt_FIFO_in_full),
        .empty(txt_FIFO_in_empty),
        .last(txt_FIFO_in_last)
    );

    output_fifo #(.width(width)) txt_FIFO_out(
        .clk(clk),
        .rstn(reg_rstn),
        .w_en(txt_FIFO_out_write),
        .r_en(txt_FIFO_out_read),
        .data_in(core_txt_out),
        .tag_check(tag_check),
        .enc_dec(enc_dec),
        .data_out(ascon_out),
        .full(txt_FIFO_out_full),
        .empty(txt_FIFO_out_empty),
        .last(txt_FIFO_out_last)
    );


    ASCON_Core core (
        .Key(key_reg),
        .Nonce(nonce_reg),
        .data_block(core_data_in),
        .txt_block(core_txt_in),
        .txt_data_sel(txt_data_sel),
        .initial_state_sel(initial_state_sel),
        .permutation_input_sel(permutation_input_sel),
        .loop_num(loop_num),
        .key_zero_exp_sel(key_zero_exp_sel),
        .permutation_output_sel(permutation_output_sel),
        .enc_dec(enc_dec),
        .tag_reg_en(tag_reg_en),
        .out_reg_en(out_reg_en),
        .stat_reg_en(stat_reg_en),
        .hash_aead(hash_aead),
        .permutation_category(permutation_category),
        .const_sel(const_sel),
        .p_out_sel(p_out_sel),
        .enable_array(enable_array),
        .compact_fast(compact_fast),
        .clk(clk), .rstn(reg_rstn),
        .output_reg(core_txt_out),
        .tag_reg(tag)
    );



endmodule