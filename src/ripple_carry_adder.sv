module ripple_carry_adder #(parameter int WIDTH = 4) (a, b, ci, sum, co);

  input [WIDTH-1:0] a;
  input [WIDTH-1:0] b;
  input ci;
  output [WIDTH-1:0] sum;
  output co;

  logic [WIDTH-1:0] carry;

  full_adder addr_bit0 (.a(a[0]), .b(b[0]), .ci(ci), .sum(sum[0]), .co(carry[0]));

  generate
    for (i = 1; i < WIDTH; i = i+1) begin : gen_ripple_carry_adder_fa
      full_adder fa (.a(a[i]), .b(b[i]), .ci(carry[i-1]), .sum(sum[i]), .co(carry[i]));
    end
  endgenerate

  assign co = carry[WIDTH-1];

endmodule
