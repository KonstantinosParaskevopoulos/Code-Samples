`include "Opcodes.v"
`timescale 1ns/1ps


module Enc_tb;

parameter delay = 100;
parameter width = 128;
parameter fileout= "Testing/ASCON_Data_MemFiles/ASCON_128/Encode_output_F.txt";
parameter fileout_mem = "Testing/ASCON_Data_MemFiles/ASCON_128/ciphertxt_F.mem";
parameter fileout_tag= "Testing/ASCON_Data_MemFiles/ASCON_128/Tag_F.mem";
integer f, f1, f2;
integer i=0;
reg [width-1:0] outputs[3:0];
    ///////////////////////////
    reg clk;
    reg rstn;

    reg [127:0] expected_tag;
    reg [127:0] key;
    reg [127:0] nonce;
    reg [width-1:0] data_block;
    reg [width-1:0] txt_block;
    reg [5:0] instruction;
    reg compact_fast;

    reg txt_blk_en, data_blk_en;

    wire [10:0] status_reg;
    wire [127:0] tag;
    wire [width-1:0] ascon_out;

    ///////////////////////////
    reg [5:0] Inst_Mem [23:0];
    integer Program_Counter=0;
    reg [width-1:0] data_mem[2:0];
    reg [width-1:0] plain_txt_mem[3:0];
    reg [127:0] key_nonce_mem[1:0];


    
ASCON_System_no_io_compression inst1(
    .expected_tag(expected_tag),
    .compact_fast(compact_fast),
    .key(key),
    .nonce(nonce),
    .data_block(data_block),
    .txt_block(txt_block),
    .instruction(instruction),
    .clk(clk), 
    .rstn(rstn),
    .status_reg(status_reg),
    .tag(tag),
    .ascon_out(ascon_out),
    .txt_blk_en(txt_blk_en),
    .data_blk_en(data_blk_en)
);

always #(delay/2) clk = ~clk;

initial begin
    f = $fopen(fileout, "w");
    f1 = $fopen (fileout_mem, "w"); 
    f2 = $fopen (fileout_tag, "w"); 
    
    $readmemh("Testing/ASCON_Data_MemFiles/ASCON_128/data_F.mem", data_mem);
    $readmemh("Testing/ASCON_Data_MemFiles/ASCON_128/plaintxt_F.mem", plain_txt_mem);
    $readmemh("Testing/ASCON_Data_MemFiles/ASCON_128/key_nonce_F.mem", key_nonce_mem);
    $readmemh("Testing/ASCON_Program_MemFiles/ASCON_128/enc_F.mem", Inst_Mem);

    clk = 1'b1;
    rstn = 1'b0;
    txt_blk_en = 1'b0;
    data_blk_en = 1'b0;
    compact_fast = 1'b1; //Fast
    key = key_nonce_mem[0];
    nonce = key_nonce_mem[1];
    instruction = Inst_Mem[Program_Counter];


    #(delay*2) rstn=1'b1;
    //Reg_Enables
    

    $display("Resetting\n");
    while(!status_reg[0])#100 i = i + 1;//wait for HW reset
    /*//RESET
    instruction = Inst_Mem[Program_Counter];        
    while(!status_reg[0])#100;    //while (!next){;}
    */

    //RESET
    //Program_Counter = Program_Counter + 1;
    /*instruction = Inst_Mem[Program_Counter];  
    Program_Counter = Program_Counter + 1;//Prepare Next Inst      
    while(!status_reg[0])#100;    //while (!next){;}
    */
    i=0;



    //ASCON_DATA_FIFO_PUSH
    data_block = data_mem[0];
    data_blk_en = 1'b1;
    instruction = Inst_Mem[Program_Counter];
    #100 data_blk_en = 1'b0;
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_DATA_FIFO_PUSH
    Program_Counter = Program_Counter + 1;
    data_block = data_mem[1];
    data_blk_en = 1'b1;
    instruction = Inst_Mem[Program_Counter];
    #100 data_blk_en = 1'b0;
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_DATA_FIFO_PUSH
    Program_Counter = Program_Counter + 1;
    data_block = data_mem[2];
    data_blk_en = 1'b1;
    instruction = Inst_Mem[Program_Counter];
    #100 data_blk_en = 1'b0;
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;
    
    //ASCON_TXT_FIFO_PUSH
    Program_Counter = Program_Counter + 1;
    txt_block = plain_txt_mem[0];
    txt_blk_en = 1'b1;
    instruction = Inst_Mem[Program_Counter];
    #100 txt_blk_en = 1'b0;
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_TXT_FIFO_PUSH
    Program_Counter = Program_Counter + 1;
    txt_block = plain_txt_mem[1];
    txt_blk_en = 1'b1;
    instruction = Inst_Mem[Program_Counter];
    #100 txt_blk_en = 1'b0;
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_TXT_FIFO_PUSH
    Program_Counter = Program_Counter + 1;
    txt_block = plain_txt_mem[2];
    txt_blk_en = 1'b1;
    instruction = Inst_Mem[Program_Counter];
    #100 txt_blk_en = 1'b0;
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_TXT_FIFO_PUSH
    Program_Counter = Program_Counter + 1;
    txt_block = plain_txt_mem[3];
    txt_blk_en = 1'b1;
    instruction = Inst_Mem[Program_Counter];
    #100 txt_blk_en = 1'b0;
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;
    
    //KEY_LD
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //NONCE_LD
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;
    //#200;

    //ASCON_INIT
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;


    //ASCON_ENC_DATA
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_ENC_DATA
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_ENC_DATA_LAST //Problem
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_ENC_TEXT
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_ENC_TEXT
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_ENC_TEXT_LAST   //Problem
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;
    //ASCON_TAG_CALC_ENC
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_TEXT_OUT_FIFO_PULL
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;
    outputs[0] = ascon_out;

    //ASCON_TEXT_OUT_FIFO_PULL
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;
    outputs[1] = ascon_out;

    //ASCON_TEXT_OUT_FIFO_PULL
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;
    outputs[2] = ascon_out;

    //ASCON_TEXT_OUT_FIFO_PULL
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;
    outputs[3] = ascon_out;

    //RESET
    instruction = 6'h3f;
    #200

    for(i = 0; i < 4; i = i + 1) begin
        $display("Output %d: %h",i, outputs[i][63:0]);
        $fwrite(f, "0x%h\n", outputs[i][63:0]);
        $fwrite(f1, "%h\n", outputs[i][63:0]); 
    end
        $fwrite(f2, "%h\n", tag);
        $fwrite(f2, "%h\n", tag);
    $stop;


    //$finish;



end



endmodule