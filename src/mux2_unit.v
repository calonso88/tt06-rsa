module mux2_unit (a, b, sel, out);
  
  input [9:0] a;
  input [9:0] b;
  input [1:0] sel;
  
  output [9:0] out;
  
  reg [9:0] out;
  
  wire [9:0] zero;
  wire [8:0] one_array;
  wire one_bit;
  wire [9:0] one;

  assign zero = '0; 
  assign one_array = '1;
  assign one_bit = 1'b1;
  
  assign one = {one_array, one_bit};
  
  always @(a or b or one or zero or sel) begin
    case (sel)
      2'b00 : out = one; 
      2'b01 : out = a;
      2'b10 : out = b;
      default out = zero;
    endcase
  end

endmodule
