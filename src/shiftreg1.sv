module shiftreg1 #(parameter int WIDTH = 4) (ena, rstb, clk, clear, load, A, A_bit);

  input ena;
  input rstb;
  input clk;
  input clear;
  input load;
  input [WIDTH-1:0] A;

  output A_bit;

  logic [WIDTH-1:0] A_aux;

  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      A_aux <= '0;
    end else begin
      if (ena == 1'b1) begin
        if (clear == 1'b0) begin
          A_aux <= '0;
        end else begin
          if (load == 1'b1) begin
            A_aux <= A;
          end else begin
            A_aux <= {A_aux >> 1};
          end
        end
      end
    end
  end

  assign A_bit = A_aux[0];

endmodule
