module mux1_unit #(parameter WIDTH = 4) (a, b, sel, out);

  input [WIDTH-1:0] a;
  input [WIDTH-1:0] b;
  input [1:0] sel;

  output [WIDTH-1:0] out;
  
  reg [WIDTH-1:0] out;
  
  wire [WIDTH-1:0] zero;
  wire [WIDTH-2:0] one_array;
  wire one_bit;
  wire [WIDTH-1:0] one;

  assign zero = '0; 
  assign one_array = '1;
  assign one_bit = 1'b1;
  
  assign one = {one_array, one_bit};
    
  always @(a or b or one or zero or sel) begin
    case (sel)
      2'b00 : out = a; 
      2'b01 : out = b;
      2'b10 : out = one;
      default out = zero;
    endcase
  end

endmodule
