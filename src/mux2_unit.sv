module mux2_unit #(parameter int WIDTH = 4) (a, b, sel, dout);

  input [WIDTH-1:0] a;
  input [WIDTH-1:0] b;
  input [1:0] sel;

  output [WIDTH-1:0] dout;

  logic [WIDTH-1:0] s_out;

  logic [WIDTH-1:0] zero;
  logic [WIDTH-2:0] one_array;
  logic one_bit;
  logic [WIDTH-1:0] one;

  assign zero = '0;
  assign one_array = '1;
  assign one_bit = 1'b1;

  assign one = {one_array, one_bit};

  always_comb begin
    case (sel)
      2'b00 : s_out = one;
      2'b01 : s_out = a;
      2'b10 : s_out = b;
      default : s_out = zero;
    endcase
  end

  assign dout = s_out;

endmodule
