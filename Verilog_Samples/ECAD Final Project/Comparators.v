`include "parameters.v"

module sync_signal_generator (X, Y, clk, reset, h_sync, v_sync, video_on);
input [9:0] X;
input [9:0] Y;
input clk, reset;
output  h_sync;
output  v_sync;
output  video_on;
    
reg h_sync_reg;
reg v_sync_reg;


    // Register Control
    always @(posedge clk or posedge reset)
        if(reset) begin
            v_sync_reg  <= 1'b0;
            h_sync_reg  <= 1'b0;
        end
        else begin
            v_sync_reg <= v_sync;
            h_sync_reg <= h_sync;
        end

    // h_sync_reg_wire asserted within the horizontal retrace area
    assign h_sync = (X >= (`HD + `HB)) && (X <= (`HD + `HB + `HSYNC_PULSE - 1));
    
    // v_sync_reg_wire asserted within the vertical retrace area
    assign v_sync = (Y >= (`VD + `VB)) && (Y <= (`VD + `VB + `VSYNC_PULSE - 1));
    
    // Video ON/OFF - only ON while pixel counts are within the display area
    assign video_on = (X < `HD) && (Y < `VD); 

endmodule