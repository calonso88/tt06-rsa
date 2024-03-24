module ripple_carry_adder #(parameter WIDTH = 4) (a, b, ci, sum, co);
  
  input [WIDTH-1:0] a;
  input [WIDTH-1:0] b;
  input ci;
  output [WIDTH-1:0] sum;
  output co;
  
  wire [WIDTH-1:0] carry;
  
  full_adder addr_bit0(a[0], b[0], ci, sum[0], carry[0]);
  
  genvar i;
  generate
    for (i = 1; i < SIZE; i = i+1) begin
      full_adder fa (a[i], b[i], carry[i-1], sum[i], carry[i]);
    end
  endgenerate

  assign co = carry[WIDTH-1];
  
endmodule



