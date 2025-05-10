module pwm (reset, clk, enable, pwm_enable, compare_load     , compare_value  , pwm_out);
	   //pwm (reset, clk, pwm_en, base      , pixel_en & pwm_en, base_pwm_amount, pwm_out_base);
     input reset, clk, enable, pwm_enable, compare_load;
     input [3:0] compare_value;
     output pwm_out;

     // Compare register is 8x smaller than the size of Period
     // so we can have at most 12.5% duty cycle (~11.71%)
     // theoretically, although we will only use ~10%
     reg [3:0] compare;
     reg [6:0] period;
     reg pwm_reg;

     // Setting up Compare and Period registers to
     // create a proper PWM signal
     always @(posedge clk or posedge reset) begin
          if (reset) begin
               compare <= 0;
               period <= 0;
          end
          else if (enable) begin
               period <= period + 1;
               if (compare_load) compare <= compare_value;
               else compare <= compare;
          end
     end

     // Use of blocking statements and removal of reset
     // option here to prevent potential glitches from
     // fast switching values of Compare register
     always @(posedge clk) begin
          if (enable) begin
               if (period == compare) pwm_reg = 1'b0;
               else if (period == 13) pwm_reg = 1'b0;
               else if (period == 0) pwm_reg = 1'b1;
               else pwm_reg = pwm_reg;
          end
     end

    // Enable PWM output to be sent to desired device
    assign pwm_out = pwm_reg & pwm_enable;

endmodule