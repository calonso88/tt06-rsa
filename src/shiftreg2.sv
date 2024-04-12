module shiftreg2 #(parameter int WIDTH = 4) (ena, rstb, clk, clear, load, rjo, reg_rji);

  input ena;
  input rstb;
  input clk;
  input clear;
  input load;
  input [WIDTH-1:0] rjo;

  output [WIDTH-1:0] reg_rji;

  logic [WIDTH-1:0] reg_rji;

  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      reg_rji <= '0;
    end else begin
      if (ena == 1'b1) begin
        if (load == 1'b1 || clear == 1'b0) begin
          reg_rji <= '0;
        end else begin
          reg_rji <= (rjo >> 1);
        end
      end
    end
  end

endmodule
