module shiftreg1 #(parameter int WIDTH = 4) (en, rstb, clk, rst_mmm_i, ld_a, A, A_bit);

  input en;
  input rstb;
  input clk;
  input rst_mmm_i;
  input ld_a;
  input [WIDTH-1:0] A;
  output A_bit;

  logic rst_mmm_int;
  logic [WIDTH-1:0] A_aux;

  assign rst_mmm_int = rstb & rst_mmm_i;

  always_ff @(negedge(rst_mmm_int) or posedge(clk)) begin
    if (!rst_mmm_int) begin
      A_aux <= '0;
    end else begin
      if (en == 1'b1) begin
        if (ld_a == 1'b1) begin
          A_aux <= A;
        end else begin
          A_aux <= {A_aux >> 1};
        end
      end
    end
  end

  assign A_bit = A_aux[0];

endmodule
