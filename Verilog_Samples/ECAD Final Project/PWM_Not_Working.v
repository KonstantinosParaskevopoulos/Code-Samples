module pwm (reset, clk, enable, pwm_enable, compare_load, compare_value, pwm_out);
     input reset, clk, enable, pwm_enable, compare_load;
     input [3:0] compare_value;
     output pwm_out;

     wire period_return;

     
     reg [3:0] compare;
     reg [6:0] period;
     reg pwm_reg;

     assign period_return = (period == 7'd79);

     // Setting up Compare and Period registers to
     // create a proper PWM signal
     always @(posedge clk or posedge reset) begin
          if (reset) begin
               compare <= 7'b0;
               period <= 7'b0;
          end
          else if (enable) begin
               if (period_return) period <= 0;
               else if (compare_load) compare <= compare_value;
               else begin
                    period <= period + 1;
                    compare <= compare;
               end
          end
     end

     // Use of blocking statements
     // option here to prevent potential glitches from
     // fast switching values of Compare register
     always @(posedge clk) begin
          if (reset) pwm_reg = 1'b1;
          if (enable) begin
               if (period == compare) pwm_reg = 1'b0;
               else if (period == 7'd8) pwm_reg = 1'b0; //for protection against pulses bigger than 2ms 
               else if (period <= 7'd3) pwm_reg = 1'b1;
               else pwm_reg = pwm_reg;
          end
     end

    // Enable PWM output to be sent to desired device
    assign pwm_out = pwm_reg & pwm_enable;

endmodule


/* //Testbench for PWM
module tb_pwm;

reg clk, reset, load_pulse_width;
reg [6:0] pulse_width;
wire pulse;

div_clk_25Mhz_4Khz inst4 (clk, reset, period_0_25ms);
pwm inst5 (reset, clk, period_0_25ms, 1'b1, load_pulse_width, pulse_width, pulse);

initial begin
    clk <= 1'b0;
    reset = 1'b1;
    load_pulse_width = 1'b0;
    pulse_width = 7'd4;
    #5 reset = 1'b0;
    load_pulse_width = 1'b1;
    #2 load_pulse_width = 1'b0;

end

always #1 clk = ~clk;
    
endmodule*/