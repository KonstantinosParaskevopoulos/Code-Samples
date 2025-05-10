`timescale 1ns/1ps

module input_fifo #(
    //parameter fifo_size=65536, 
    parameter width=128,
    parameter register_size = 8,//$clog2(fifo_size) //Doesn't work in Modelsim (pre Verilog-2005)
    parameter fifo_size = 2**register_size
  ) 
  (
    input clk, rstn,
    input w_en, r_en,
    input [width-1:0] data_in,
    output reg [width-1:0] data_out,
    output full, empty, last
  );
  
  reg [register_size-1:0] w_ptr, r_ptr; //Read/Write Pointers
  reg [width-1:0] fifo [(fifo_size)-1:0];          //Memory Array 
  reg [register_size-1:0] count;        //Counter
  integer i;
  // Set Default values on reset.
  always@(posedge clk) begin
    if(!rstn) begin
      count <= 0;                                                     //
    end
    else begin
      case({w_en,r_en})
        2'b00, 2'b11: count <= count; //Not Needed 
        2'b01: count <= count - 1'b1; //Read from FIFO
        2'b10: count <= count + 1'b1; //Write to FIFO
      endcase
    end
  end
  
  // To write or read data to FIFO
  always@(posedge clk) begin
    if(!rstn)begin
        w_ptr <= 0; r_ptr <= 0;
        data_out <= 0;
        for (i = 0; i < register_size; i = i + 1) begin         //
            fifo[i] <= {width{1'b0}};                         // IS synthesizable BUT adds too much hardware
        end
    end 
    else begin
        if(w_en && !full)begin
            fifo[w_ptr] <= data_in;
            w_ptr <= w_ptr + 1;
        end
        else if(r_en && !empty) begin
            data_out <= fifo[r_ptr];
            r_ptr <= r_ptr + 1;
        end
    end
    
  end
  
  
  assign full = (count == fifo_size);
  assign last  = (count == 2);
  assign empty = (count == 0);
endmodule


module output_fifo #(
    //parameter fifo_size=65536, 
    parameter width=128,
    parameter register_size = 8,//$clog2(fifo_size) //Doesn't work in Modelsim (pre Verilog-2005)
    parameter fifo_size = 2**register_size
  ) 
  (
    input clk, rstn,
    input w_en, r_en,
    input [width-1:0] data_in,
    input tag_check,
    input enc_dec,
    output reg [width-1:0] data_out,
    output full, empty, last
  );
  
  reg [register_size-1:0] w_ptr, r_ptr; //Read/Write Pointers
  reg [width-1:0] fifo [(fifo_size)-1:0];          //Memory Array 
  reg [register_size-1:0] count;        //Counter
  integer i;
  // Set Default values on reset.
  always@(posedge clk) begin
    if(!rstn) begin
      count <= 0;
    end
    else begin
      case({w_en,r_en})
        2'b00, 2'b11: count <= count; //Not Needed 
        2'b01: count <= count - 1'b1; //Read from FIFO
        2'b10: count <= count + 1'b1; //Write to FIFO
      endcase
    end
  end
  
  // To write or read data to FIFO
  always@(posedge clk) begin
    if(!rstn)begin
        w_ptr <= 0; r_ptr <= 0;
        data_out <= 0;
        for (i = 0; i < register_size; i = i + 1) begin         //
            fifo[i] <= {width{1'b0}};                         // IS synthesizable BUT adds too much hardware
        end                                                     //
    end 
    else begin
        if(w_en && !full)begin
            fifo[w_ptr] <= data_in;
            w_ptr <= w_ptr + 1;
        end
        else if(r_en && !empty && ((tag_check && enc_dec) || !enc_dec)) begin //If (Decryption AND Tag_OK) OR (enc)
            data_out <= fifo[r_ptr];
            r_ptr <= r_ptr + 1;
        end
        else if(!tag_check && enc_dec)begin   //If (Decryption AND Tag_NOT_OK)
            data_out <= 0;
        end
    end
    
  end
  
  
  assign full = (count == fifo_size);
  assign last  = (count == 2);
  assign empty = (count == 0);
endmodule