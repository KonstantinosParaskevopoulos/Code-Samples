`timescale 1ns / 1ps
module vga_test(
	input clk100,           // from Basys 3
	input reset,
	//input [7:0] sw,         // 8_bits for scancode
    //input enable,           //button for enable
    input ps2clk, ps2data,
	output hsync, 
	output vsync,
    output pwm_out,
	output [8:0] rgb      // 9 FPGA pins for RGB(3 per color)
    
);
	wire [7:0] scan;
	reg [8:0] rgb_reg;    
	wire video_on;         // Same signal as in controller
    wire [6:0] pulse_width;
    wire clk_0_25;
   //Dummy Wires
   wire [9:0] x;
   wire [9:0] y;
   wire [8:0] pxValue;
    // Instantiate VGA Controller
    vga_controller vga_inst(clk100, reset, video_on, hsync, vsync, clk, x, y);
    
    kbd_protocol kbd (reset, clk100, ps2clk, ps2data, scan, enable);
    
    charRegister char_reg_inst(scan, clk100, reset, enable,  x, y, pxValue, pulse_width);

    div_clk_25Mhz_4Khz inst4 (clk100, reset, clk_0_25);

    pwm pwm_inst(reset, clk100, clk_0_25, 1'b1, clk_0_25 & clk, pulse_width, pwm_out);
	//pwm base_pwm (reset, clk, pwm_en, base, pixel_en & pwm_en, base_pwm_amount, pwm_out_base);
	 //			(reset, clk, enable, pwm_enable, compare_load, compare_value, pwm_out);
	//pwm (reset, clk, enable, pwm_enable, compare_load     , compare_value  , pwm_out);
    // RGB Buffer
    always @(posedge clk100 or posedge reset)
    if (reset)
       rgb_reg <= 0;
    else
       rgb_reg <= pxValue;
    
    // Output
    assign rgb = (video_on) ? rgb_reg : 9'b0;   // while in display area RGB color = sw, else all OFF
        
endmodule
