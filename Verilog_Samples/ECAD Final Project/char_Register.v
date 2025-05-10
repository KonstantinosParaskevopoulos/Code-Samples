`include "parameters.v"

module scan2Address (scancode, clk, reset, enable, halfAddress, pulse_width); //Input: the scanCode, Output: the first half of the charRom Address
    input [7:0] scancode;
    input clk, reset, enable;
    output reg [2:0] halfAddress;
    output reg [6:0] pulse_width;

    reg [7:0] scancode_register;

    always @(posedge clk or posedge reset) begin
        if (reset)
            scancode_register <= 8'h00;
        else if(!reset) begin
            if (enable && (scancode==8'h2b || scancode==8'h15 || scancode==8'h33 || scancode==8'h22)) scancode_register <= scancode; //change scancode_register only if enable and the scancode value is one of the expected
            end
    end

    always @(scancode_register) begin
        case (scancode_register)
            
            8'h2b: begin 
                halfAddress <= 3'h0;         //Char F
                pulse_width <= 4'd6;         //Pulse_Width = 1ms (4 * 0.25ms)
            end
            8'h15: begin
                halfAddress <= 3'h1;         //Char Q
                pulse_width <= 4'd8;         //Pulse_Width = 1.25ms (5 * 0.25ms)
            end
            8'h33: begin
                halfAddress <= 3'h2;         //Char H
                pulse_width <= 4'd10;         //Pulse_Width = 1.5ms (6 * 0.25ms)
            end
            8'h22: begin
                halfAddress <= 3'h3;         //Char X
                pulse_width <= 4'd13;         //Pulse_Width = 2ms (8 * 0.25ms)
            end
            default: begin
                halfAddress <= 3'h5;         //else Show No Character
                pulse_width <= 4'd6;         //Pulse_Width = 1ms (4 * 0.25ms)
            end
        endcase
    end

endmodule


module charRegister (scancode, clk, reset, enable,  x, y, rgbValue, pulse_width);
input [7:0] scancode;
input [9:0] x, y;
input reset, clk, enable;
output [8:0] rgbValue; //0xFFF or 0x000 value of RGB output
output [6:0] pulse_width;

reg [8:0] rgbValue;

wire [6:0] charROMAddress;  

wire [2:0] halfAddress; //First half of CharROM address provided by scan2Address Circ
wire [3:0] restAddress; //Second half of CharROM address calculated by y
wire [2:0] pixel_bit_in_row;  //Exact bit of each row;

wire [7:0] row_of_pixels; //Row of Pixels from charROM

scan2Address inst1(scancode, clk, reset, enable, halfAddress, pulse_width); 

characterRom inst2( charROMAddress, row_of_pixels );

assign restAddress = y - `top;      //y coordinate - top_value for example y=220 -> restAddress=220-217=3 which gives the 3rd row of pixels of the chosen char
assign pixel_bit_in_row = x - `left;//x coordinate - left_value for example x=400 -> restAddress=400-396=4 which gives the 4th bit of the nth row of pixels of the chosen char
assign charROMAddress = {halfAddress, restAddress};

always@(posedge clk or posedge reset)begin
    if (reset) rgbValue = 9'h000;
    else if (!reset)begin
        if ((x>=`left)&&(x<`right)&&(y>=`top)&&(y<`bottom)) rgbValue = {9{row_of_pixels[pixel_bit_in_row]}};    //checks the nth bit of the row of pixel and if it is 1 then rgbValue is 0xFFF else 0x000 
        else rgbValue = 9'h000;
    end
end



endmodule