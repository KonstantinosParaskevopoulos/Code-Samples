module div_clk_100_2_25 (clkIn, reset, clkOut);
    input clkIn;
    input reset;
    output clkOut;

    reg [1:0] cnt;

assign clkOut = (cnt==2'h3);
always @(posedge reset or posedge clkIn)
  if (reset) cnt <= 0;
  else if (clkOut) cnt <= 0;
  else cnt <= cnt + 1;

endmodule

/*
module test25_MHz();
  reg reset, clk;
  wire OutCLK;
  
  div_clk_100_2_25 CUT (clk, reset, OutCLK);
initial begin 
        reset=0; clk = 0;
  #10   reset = 1; # 9 reset = 0; 
end
  always #1 clk=~clk;
endmodule
*/