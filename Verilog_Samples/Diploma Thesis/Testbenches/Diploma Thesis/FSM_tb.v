
`include "Opcodes.v"
`timescale 1ns/1ps


module FSM_tb;
    parameter delay = 100;

    reg clk;
    reg rstn_ctrl;
    reg [5:0] opcode;
    reg compact_fast;

    // Outputs
    wire txt_data_sel;
    wire initial_state_sel;
    wire [1:0] permutation_input_sel;
    wire [2:0] loop_num;
    wire permutation_category;
    wire key_zero_exp_sel;
    wire [1:0] permutation_output_sel;
    wire enc_dec;
    wire tag_reg_en;
    wire out_reg_en;
    wire hash_aead;
    wire exp_tag_en;
    wire key_en;
    wire nonce_en;
    wire glob_out_reg_en;
    wire ready;
    wire txt_FIFO_in_write;
    wire txt_FIFO_in_read;
    wire ad_FIFO_in_write;
    wire ad_FIFO_in_read;
    wire txt_FIFO_out_write;
    wire txt_FIFO_out_read;
    wire state_reg_en;
    wire const_sel;
    wire [5:0] enable_array;
    wire txt_blk_en, data_blk_en;
    wire next;
    wire rstn;

    reg [5:0] Inst_Mem [81:0];
    integer Program_Counter=0;
    integer count = 0;
    integer i=0;
    integer check = 0;

    Ctrl_Circuit fsm_dut(clk, rstn_ctrl, opcode, compact_fast, txt_data_sel, initial_state_sel, permutation_input_sel, loop_num, key_zero_exp_sel, permutation_output_sel, enc_dec, out_reg_en, hash_aead, permutation_category, const_sel, p_out_sel, enable_array, exp_tag_en, key_en, nonce_en, glob_out_reg_en, ready, tag_reg_en, txt_FIFO_in_write, txt_FIFO_in_read, ad_FIFO_in_write, ad_FIFO_in_read, txt_FIFO_out_write, txt_FIFO_out_read, state_reg_en, next, txt_blk_en, data_blk_en, rstn);

    initial begin
        $readmemh("Inst_mem.mem", Inst_Mem);
        clk = 1'b1;
        rstn_ctrl = 1'b0;
        compact_fast = 1'b0;
        #(delay) rstn_ctrl=1'b1;
        $display("Resetting\n");

      end
    
    always #(delay/2) clk = ~clk;
    
    always begin
        //#1;
        
        if(next) begin 
            if(check) begin 
                Program_Counter = 0;
                check = 0; 
            end
            else Program_Counter = Program_Counter + 1;
            i = 0;
        end
        if(!rstn) begin
            compact_fast = ~compact_fast;   //Change Fast to Low Power Mode
            count = count + 1;   
            check = 1; 
        end
        opcode = Inst_Mem[Program_Counter];
        #100;
        if(rstn_ctrl)begin 
            if(i==0) $display("------------------Instruction: %h-------------",Inst_Mem[Program_Counter]);
            $display("Current_State: %h, %d", fsm_dut.current_state, i);
        end 
        i = i + 1;
        if(count>2)$stop;
        
        //$display("PC = %d", Program_Counter);
        
    end
    
    

endmodule