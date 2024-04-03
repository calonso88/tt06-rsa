module shiftreg3 #(parameter int WIDTH = 4) (en, rstb, clk, rst_mmm_i, lock, ld_r, reg_rji, A, R_i);

  input en;
  input rstb;
  input clk;
  input rst_mmm_i;
  input lock;
  input ld_r;
  input [WIDTH-1:0] reg_rji;
  input [WIDTH-1:0] A;
  output [WIDTH-1:0] R_i;

  logic rst_mmm_int;
  logic [WIDTH-1:0] R_i;

  assign rst_mmm_int = rstb & rst_mmm_i;

  always_ff @(negedge(rst_mmm_int) or posedge(clk)) begin
    if (!rst_mmm_int) begin
      R_i <= '0;
    end else begin
      if (en == 1'b1) begin
        if ((lock == 1'b1) && (ld_r == 1'b1)) begin
          R_i <= reg_rji;
        end else begin
          if (ld_r == 1'b1) begin
            R_i <= A;
          end
        end
      end
    end
  end

endmodule
