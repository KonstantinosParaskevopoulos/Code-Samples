module kbd_protocol (reset, clk, ps2clk, ps2data, scancode, enable);
  input        reset, clk, ps2clk, ps2data;
  output [7:0] scancode;
  output enable; // το σημα εξοδου που παραγεται απο το module του πληκτρολογιου, οταν πατιεται καποιο πληκτρο
  reg    [7:0] scancode;
  
  reg enable;
  
  // Synchronize ps2clk to local clock and check for falling edge;
  reg    [7:0] ps2clksamples; // Stores last 8 ps2clk samples

  always @(posedge clk or posedge reset)
    if (reset) ps2clksamples <= 8'd0;
      else ps2clksamples <= {ps2clksamples[7:0], ps2clk};

  wire fall_edge; // indicates a falling_edge at ps2clk
  assign fall_edge = (ps2clksamples[7:4] == 4'hF) & (ps2clksamples[3:0] == 4'h0);

  reg    [9:0] shift;   // Stores a serial package, excluding the stop bit;
  reg    [3:0] cnt;     // Used to count the ps2data samples stored so far
  reg          f0;      // Used to indicate that f0 was encountered earlier
  
  // A simple FSM is implemented here. Grab a whole package,
  // check its parity validity and output it in the scancode
  // only if the previous read value of the package was F0
  // that is, we only trace when a button is released, NOT when it is
  // pressed.
  
  always @(posedge clk or posedge reset) begin
    enable <= 1'b0;  //enable = 0 after each clk pulse
    if (reset)
      begin
        cnt    <= 4'd0;
        scancode <= 8'd0;
        shift    <= 10'd0;
        f0       <= 1'b0;
      end  
     else if (fall_edge)
         begin
           if (cnt == 4'd10) // we just received what should be the stop bit
             begin
               cnt <= 0;
               if ((shift[0] == 0) && (ps2data == 1) && (^shift[9:1]==1)) // A well received serial packet
                 begin
                   if (f0) // following a scancode of f0. So a key is released ! 
                     begin
                       scancode <= shift[8:1];
                       f0 <= 0;
                       enable <= 1'b1;  //enable = 1 when the key is released
                     end
                    else if (shift[8:1] == 8'hF0) f0 <= 1'b1;
                 end // All other packets have to do with key presses and are ignored
             end
            else
             begin
               shift <= {ps2data, shift[9:1]}; // Shift right since LSB first is transmitted
               cnt <= cnt+1;
             end
         end
        end
	 
	 /*if (cnt != 4'b0000) // ή ισοδυναμα: if (shift != 10'd0)  
		begin
		    enable <= 1'b1;	 
		end	*/
endmodule





/*module kbd_module (reset, clk, ps2clk, ps2data, scan, enable);
  input        reset, clk;
  input        ps2clk, ps2data;
  output [7:0] scan;
  output enable;

  kbd_protocol kbd (reset, clk, ps2clk, ps2data, scan, enable);
endmodule*/