module shiftreg3 #(parameter int WIDTH = 4) (rstb, clk, ena, clear, load, lock, reg_rji, A, R_i);

  input rstb;
  input clk;
  input ena;
  input clear;
  input load;
  input lock;
  input [WIDTH-1:0] reg_rji;
  input [WIDTH-1:0] A;

  output [WIDTH-1:0] R_i;

  logic [WIDTH-1:0] R_i;

  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      R_i <= '0;
    end else begin
      if (ena == 1'b1) begin
        if (clear == 1'b0) begin
          R_i <= '0;
        end else begin
          if (load == 1'b1) begin
            if (lock == 1'b1) begin
              R_i <= reg_rji;
            end else begin
              R_i <= A;
            end
          end
        end
      end
    end
  end

endmodule
