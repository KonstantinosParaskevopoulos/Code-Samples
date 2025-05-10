`timescale 1ns / 1ps
module vga_controller(
    input clk100,   // from Basys 3
    input reset,        // system reset
    output video_on,    // ON while pixel counts for x and y and within display area
    output hsync,       // horizontal sync
    output vsync,       // vertical sync
    output clk,      // the 25MHz pixel/second rate signal, pixel tick
    output [9:0] x,     // pixel count/position of pixel x, max 0-799
    output [9:0] y      // pixel count/position of pixel y, max 0-524
    );
    
div_clk_100_2_25        inst0(clk100, reset, clk);  
Counters                inst1(clk, reset, x, y);
sync_signal_generator   inst2(x, y, clk, reset, hsync, vsync, video_on);

            
endmodule