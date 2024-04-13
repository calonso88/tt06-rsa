module register_crypt #(parameter int WIDTH = 4) (ena, rstb, clk, clear, load, R_i, C_ex);

  input ena;
  input rstb;
  input clk;
  input clear;
  input load;
  input [WIDTH-1:0] R_i;
  output [WIDTH-1:0] C_ex;

  logic [WIDTH-1:0] C_ex;

  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      C_ex <= '0;
    end else begin
      if (ena == 1'b1) begin
        if (clear == 1'b0) begin
          C_ex <= '0;
        end else begin
          if (load == 1'b1) begin
            C_ex <= R_i;
          end
        end
      end
    end
  end

endmodule
