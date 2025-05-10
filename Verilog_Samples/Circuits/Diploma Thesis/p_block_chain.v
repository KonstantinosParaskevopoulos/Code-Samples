`timescale 1ns/1ps

module p_block_chain(
    input [319:0] x_in,
    input [2:0] loop_num, 
    input const_sel,
    input [5:0] enable_array,
    input compact_fast,
    output [319:0] x_out_6,
    output [319:0] x_out_2
);

wire [319:0] p0_out;
wire [319:0] p1_out;
wire [319:0] p2_out;
wire [319:0] p3_out;
wire [319:0] p4_out;
wire [319:0] p5_out;



        ////////////////////////////////////////////////////
        //                     p0_a                       //
        ////////////////////////////////////////////////////
            p_block_opt  #(.odd_even(0)) p0 (
                .x_in(x_in),
                .pa_1st(8'hf0),
                .pa_2nd_pb_1st(8'h96),
                .pb_1st(8'hb4),
                .pb_2nd(8'h5a),
                .loop_num(loop_num),
                .const_sel(const_sel),
                .enable(enable_array[5]),
                .compact_fast(compact_fast),
                .x_out(p0_out)
            );
        ////////////////////////////////////////////////////
        

        ////////////////////////////////////////////////////
        //                     p1_a                       //
        ////////////////////////////////////////////////////    
            p_block_opt #(.odd_even(1)) p1 (
                .x_in(p0_out),
                .pa_1st(8'he1),
                .pa_2nd_pb_1st(8'h87),
                .pb_1st(8'ha5),
                .pb_2nd(8'h4b),
                .loop_num(loop_num),
                .const_sel(const_sel),
                .enable(enable_array[4]),
                .compact_fast(compact_fast),
                .x_out(p1_out)
            );
        ////////////////////////////////////////////////////
        

        ////////////////////////////////////////////////////
        //                     p2_a                       //
        ////////////////////////////////////////////////////
            p_block_opt #(.odd_even(0)) p2 (
                .x_in(p1_out),
                .pa_1st(8'hd2),
                .pa_2nd_pb_1st(8'h78),
                .pb_1st(8'h96),
                .pb_2nd(8'h00),
                .loop_num(loop_num),
                .const_sel(const_sel),
                .enable(enable_array[3]),
                .compact_fast(compact_fast),
                .x_out(p2_out)
            );
        ////////////////////////////////////////////////////
        

        ////////////////////////////////////////////////////
        //                     p3_a                       //
        ////////////////////////////////////////////////////
            p_block_opt #(.odd_even(1)) p3 (
                .x_in(p2_out),
                .pa_1st(8'hc3),
                .pa_2nd_pb_1st(8'h69),
                .pb_1st(8'h87),
                .pb_2nd(8'h00),
                .loop_num(loop_num),
                .const_sel(const_sel),
                .enable(enable_array[2]),
                .compact_fast(compact_fast),
                .x_out(p3_out)
            );
        ////////////////////////////////////////////////////
        

        ////////////////////////////////////////////////////
        //                     p4_a                       //
        ////////////////////////////////////////////////////
            p_block_opt #(.odd_even(0)) p4 (
                .x_in(p3_out),
                .pa_1st(8'hb4),
                .pa_2nd_pb_1st(8'h5a),
                .pb_1st(8'h78),
                .pb_2nd(8'h00),
                .loop_num(loop_num),
                .const_sel(const_sel),
                .enable(enable_array[1]),
                .compact_fast(compact_fast),
                .x_out(p4_out)
            );
        ////////////////////////////////////////////////////
        

        ////////////////////////////////////////////////////
        //                     p5_a                       //
        ////////////////////////////////////////////////////
            p_block_opt #(.odd_even(1)) p5 (
                .x_in(p4_out),
                .pa_1st(8'ha5),
                .pa_2nd_pb_1st(8'h4b),
                .pb_1st(8'h69),
                .pb_2nd(8'h00),
                .loop_num(loop_num),
                .const_sel(const_sel),
                .enable(enable_array[0]),
                .compact_fast(compact_fast),
                .x_out(p5_out)
            );
        ////////////////////////////////////////////////////
        
            assign x_out_6 = p5_out;
            assign x_out_2 = p1_out;


    
endmodule
