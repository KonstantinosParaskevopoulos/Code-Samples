`timescale 1ns/1ps

module p_block128_opt_tb;
    parameter ALG_VER = 1;
    parameter delay = 200;
    parameter fileout= "p_block_chain_output_hex.txt";
    parameter fileout2= "p_block_chain_output_dec.txt";
    integer f;
    integer f1;
    reg const_sel;
    reg [63:0] x_0_in;
    reg [63:0] x_1_in;
    reg [63:0] x_2_in;
    reg [63:0] x_3_in;
    reg [63:0] x_4_in;
    reg [5:0] enable_array;
    reg compact_fast;
    reg [2:0] loop_num; //permutation_category = 1'b0

    wire [63:0] x_0_out;
    wire [63:0] x_1_out;
    wire [63:0] x_2_out;
    wire [63:0] x_3_out;
    wire [63:0] x_4_out; 
    
    wire [63:0] x_0_out2, x_1_out2, x_2_out2, x_3_out2, x_4_out2;

    wire [319:0] state_in;

    assign state_in = {x_0_in, x_1_in, x_2_in, x_3_in, x_4_in};


    p_block_chain #(.ALG_VER(ALG_VER)) DUT (
        .x_in(state_in),
        .const_sel(const_sel),
        .loop_num(loop_num),
        .enable_array(enable_array),
        .compact_fast(compact_fast),
        //.permutation_category(1'b0),
        .x_out_6({x_0_out, x_1_out, x_2_out, x_3_out, x_4_out}),
        .x_out_2({x_0_out2, x_1_out2, x_2_out2, x_3_out2, x_4_out2})
    );


    initial begin
      f = $fopen(fileout, "w");
      f1=$fopen(fileout2, "w");


      repeat(100) begin
            enable_array = 6'h3f;
            const_sel = 1'b0;
            compact_fast = 1'b1;
            loop_num = 3'b000;
          //100 Randomised Inputs
          x_0_in[63:32] = $random;
          x_1_in[63:32] = $random;
          x_2_in[63:32] = $random;
          x_3_in[63:32] = $random;
          x_4_in[63:32] = $random;
          x_0_in[31:0] = $random;
          x_1_in[31:0] = $random;
          x_2_in[31:0] = $random;
          x_3_in[31:0] = $random;
          x_4_in[31:0] = $random;
          //$display("Initial 2 Done\n");
        #(delay/2);
          $fwrite(f, "0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h\n", x_0_in, x_1_in, x_2_in, x_3_in, x_4_in, x_0_out, x_1_out, x_2_out, x_3_out, x_4_out, loop_num);
          $fwrite(f1, "%d %d %d %d %d %d %d %d %d %d %d\n", x_0_in, x_1_in, x_2_in, x_3_in, x_4_in, x_0_out, x_1_out, x_2_out, x_3_out, x_4_out, loop_num);
        #(delay);
          loop_num = 3'b001;
        #(delay/2);
          $fwrite(f, "0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h 0x%h\n", x_0_in, x_1_in, x_2_in, x_3_in, x_4_in, x_0_out, x_1_out, x_2_out, x_3_out, x_4_out, loop_num);
          $fwrite(f1, "%d %d %d %d %d %d %d %d %d %d %d\n", x_0_in, x_1_in, x_2_in, x_3_in, x_4_in, x_0_out, x_1_out, x_2_out, x_3_out, x_4_out, loop_num);
        #(delay);
      end
      $finish;
  end
endmodule