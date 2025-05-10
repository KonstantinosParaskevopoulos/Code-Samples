`include "Opcodes.v"
`timescale 1ns/1ps

module LP_Dec_tb;

parameter delay = 100;
parameter width = 128;
parameter fileout= "Testing/ASCON_Data_MemFiles/ASCON_128/Decode_output_LP.txt";
integer i=0;
integer f;
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
    reg [127:0] tag_mem [1:0];


    
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
    $readmemh("Testing/ASCON_Data_MemFiles/ASCON_128/Tag_LP.mem", tag_mem);
    $readmemh("Testing/ASCON_Data_MemFiles/ASCON_128/data_LP.mem", data_mem);
    $readmemh("Testing/ASCON_Data_MemFiles/ASCON_128/ciphertxt_LP.mem", plain_txt_mem);
    $readmemh("Testing/ASCON_Data_MemFiles/ASCON_128/key_nonce_LP.mem", key_nonce_mem);
    $readmemh("Testing/ASCON_Program_MemFiles/ASCON_128/dec_LP.mem", Inst_Mem);

    clk = 1'b1;
    rstn = 1'b0;
    compact_fast = 1'b0; //Low Power
    txt_blk_en = 1'b0;
    data_blk_en = 1'b0;
    key = key_nonce_mem[0];
    nonce = key_nonce_mem[1];
    expected_tag = tag_mem[1];
    instruction = Inst_Mem[Program_Counter];


    #(delay*2) rstn=1'b1;
    //Reg_Enables
    

    $display("Resetting\n");
    while(!status_reg[0])#100 i = i + 1;//wait for HW reset
    
    i=0;
    //ASCON_DATA_FIFO_PUSH
    //Program_Counter = Program_Counter + 1;
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

    //EXPECTED_TAG_LD
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


    //ASCON_DEC_DATA
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_DEC_DATA
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_DEC_DATA_LAST //Problem
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_DEC_TEXT
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_DEC_TEXT
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;

    //ASCON_DEC_TEXT_LAST   //Problem
    Program_Counter = Program_Counter + 1;
    instruction = Inst_Mem[Program_Counter];
    #100 while(!status_reg[0])#100 i = i + 1;    //while (!next){;}
    i = 0;
    //ASCON_TAG_CALC_DEC
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


    instruction = 6'h3f;
    #200

    for(i = 0; i < 4; i = i + 1) begin
        $display("Output %d: %h",i, outputs[i][63:0]);
        $fwrite(f, "0x%h\n", outputs[i][63:0]);
    end
    
    $stop;


    //$finish;



end



endmodule