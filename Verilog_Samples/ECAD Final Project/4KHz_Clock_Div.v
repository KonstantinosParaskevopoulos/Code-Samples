module cnt25 (reset, clk, enable, clkdiv25);
input reset, clk, enable;
output clkdiv25;
reg [4:0] cnt;

assign clkdiv25 = (cnt==5'd24);
always @(posedge reset or posedge clk)
  if (reset) cnt <= 0;
   else if (enable) 
          if (clkdiv25) cnt <= 0;
            else cnt <= cnt + 1;
endmodule



module cnt10 (reset, clk, enable, clkdiv256);
input reset, clk, enable;
output clkdiv256;
reg [3:0] cnt;

assign clkdiv256 = (cnt==4'd9);
always @(posedge reset or posedge clk)
  if (reset) cnt <= 0;
   else if (enable) cnt <= cnt + 1;
endmodule



module div_clk_25Mhz_4Khz (pxCLK, reset, period_0_25ms);    //~=0.15ms period or 6.4KHz freq for pwm

input reset, pxCLK;
output period_0_25ms;

wire first, second, third;

cnt25 inst1(reset, pxCLK, 1'b1, first);
cnt25 inst2(reset, pxCLK, first, second);
cnt25 inst3(reset, pxCLK, first & second, third);

assign period_0_25ms = first & second & third ;

endmodule

