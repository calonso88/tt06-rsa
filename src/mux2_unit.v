`timescale 1ns / 1ps

module mux2_unit (a, b, sel, out);
  
  input [1025:0] a;
  input [1025:0] b;
  input [1:0] sel;
  
  output [1025:0] out;
  
  reg [1025:0] out;
  
  supply0 [1025:0] zero;
  supply0 [1024:0] one_array;
  supply1 one_bit;
  
  wire [1025:0] one = {one_array, one_bit};
  
  always @(a or b or one or zero or sel) begin
    case (sel)
      2'b00 : out = one; 
      2'b01 : out = a;
      2'b10 : out = b;
      default out = zero;
    endcase
  end

endmodule
