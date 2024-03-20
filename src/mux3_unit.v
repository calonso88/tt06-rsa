`timescale 1ns / 1ps

module mux3_unit (a, b, sel, out);

  input [9:0] a;
  input [9:0] b;
  input sel;

  output [9:0] out;

  supply0 [9:0] zero;
  reg [9:0] out;

  always @(a or b or sel) begin
    case (sel)
      1'b0 : out = a; 
      1'b1 : out = b;
      default out = zero;
    endcase
  end

endmodule
