module mux3_unit #(parameter WIDTH = 4) (a, b, sel, out);

  input [WIDTH-1:0] a;
  input [WIDTH-1:0] b;
  input sel;

  output [WIDTH-1:0] out;

  wire [WIDTH-1:0] zero;
  reg [WIDTH-1:0] out;
  
  assign zero = '0; 
  
  always @(a or b or sel) begin
    case (sel)
      1'b0 : out = a; 
      1'b1 : out = b;
      default out = zero;
    endcase
  end

endmodule
