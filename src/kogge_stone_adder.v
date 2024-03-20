`timescale 1ns / 1ps

module kogge_stone_adder (a, b, ci, sum, co);

  input [7:0] a;
  input [7:0] b;
  input ci;
  output [7:0] sum;
  output co;

  wire p [3:0][7:0];
  wire g [3:0][7:0];

  assign g[0][0] = (a[0] & b[0]) | (ci & (a[0] ^ b[0]));
  assign p[0][0] = a[0] ^ b[0] ^ ci;
	
  genvar i;
  genvar j;
  generate
    for (i=(7); i>0; i=i-1) begin : p_g_kogge_stone
      assign g[0][i] = a[i] & b[i];
      assign p[0][i] = a[i] ^ b[i];
    end
  endgenerate

  generate
    for (i=1; i<=3; i=i+1) begin : carry_prefix
      for (j=(7); j>=0; j=j-1) begin : parallel_prefix
        if ((j-2**(i-1)) >= 0) begin : parallel_prefix_condicional
          assign g[i][j] = g[i-1][j] | (p[i-1][j] & g[i-1][j-(2**(i-1))]);
          assign p[i][j] = p[i-1][j] & p[i-1][j-(2**(i-1))];
        end else begin
          assign g[i][j] = g[i-1][j];
          assign p[i][j] = p[i-1][j];
        end
      end
    end
  endgenerate

  generate
    for (i=(7); i>0; i=i-1) begin : sum_kogge_stone
      assign sum[i] = p[0][i] ^ g[3][i-1];
    end
  endgenerate

  assign sum[0] = p[0][0];
  assign co = g[3][7];

endmodule
