`timescale 1ns / 1ps

module mux1_unit (a, b, sel, out);

  input [9:0] a;
  input [9:0] b;
  input [1:0] sel;

  output [9:0] out;
  
  reg [9:0] out;
  
  supply0 [9:0] zero;
  supply0 [8:0] one_array;
  supply1 one_bit;
  
  wire [9:0] one = {one_array, one_bit};
  
  always @(a or b or one or zero or sel) begin
    case (sel)
      2'b00 : out = a; 
      2'b01 : out = b;
      2'b10 : out = one;
      default out = zero;
    endcase
  end

endmodule
