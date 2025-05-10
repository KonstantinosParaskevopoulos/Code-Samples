`timescale 1ns/1ps

module SBox_tb;
    parameter delay = 200;
    parameter fileout= "SBox_output.txt";
    integer i=0;
    integer errors = 0;
    integer j=0;
    reg [4:0] testresponses [31:0];   //The expected Responses of the S-Box will be stored here

    integer f;
    reg [63:0] x_0_in;
    reg [63:0] x_1_in;
    reg [63:0] x_2_in;
    reg [63:0] x_3_in;
    reg [63:0] x_4_in;
    
    
    wire [63:0] x_0_out;
    wire [63:0] x_1_out;
    wire [63:0] x_2_out;
    wire [63:0] x_3_out;
    wire [63:0] x_4_out; 





    ASCON_SBox_320_Bit DUT (
        .x_0(x_0_in),
        .x_1(x_1_in),
        .x_2(x_2_in),
        .x_3(x_3_in),
        .x_4(x_4_in),
        .x_0_out(x_0_out),
        .x_1_out(x_1_out),
        .x_2_out(x_2_out),
        .x_3_out(x_3_out),
        .x_4_out(x_4_out)
    );

    initial begin
      //f = $fopen(fileout, "w");
      $readmemh("s_box_resp.mem", testresponses); //Read Expected Responses from File
      repeat(1000) begin
        //Inputs Init
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
          
        #(delay/2);

            for (j = 0; j <= 63; j = j + 1)begin
                //$display("Input: %h \nOutput: %h",{x_0_in[j],x_1_in[j],x_2_in[j],x_3_in[j],x_4_in[j]}, {x_0_out[j],x_1_out[j],x_2_out[j],x_3_out[j],x_4_out[j]});
                i={x_0_in[j],x_1_in[j],x_2_in[j],x_3_in[j],x_4_in[j]};
                //$display("Right Response: %h", testresponses[i]);
                //else $display("Success Input: %h \nOutput: %h",{x_0_in[j],x_1_in[j],x_2_in[j],x_3_in[j],x_4_in[j]}, testresponses[{x_0_in[j],x_1_in[j],x_2_in[j],x_3_in[j],x_4_in[j]}]);
            if(({x_0_out[j],x_1_out[j],x_2_out[j],x_3_out[j],x_4_out[j]})==testresponses[i])
                $display("Success");
            else begin
                $display("Fail");
                errors = errors + 1; end
            end

        #(delay);
      end
      $display("\n\nErrors: %d", errors);
      $finish;
  end
endmodule

