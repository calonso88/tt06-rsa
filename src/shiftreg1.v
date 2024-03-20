`timescale 1ns / 1ps

module shiftreg1 (en, rstb, clk, rst_mmm_i, ld_a, A, A_bit);

  input en;
  input rstb;
  input clk;
  input rst_mmm_i;
  input ld_a;
  input [9:0] A;

  output A_bit;

  reg [9:0] A_aux;

  wire clk_i;
  wire rstb_i;
  wire rst_mmm_int;
  wire rst_mmm_int_buf;

  assign rst_mmm_int = rstb_i & rst_mmm_i;

  buf U0 (rstb_i, rstb);
  buf U1 (clk_i, clk);
  buf U2 (rst_mmm_int_buf, rst_mmm_int);
  buf U3 (en_i, en);

  always @(negedge(rst_mmm_int_buf) or posedge(clk_i)) begin
    if (!rst_mmm_int_buf) begin
      A_aux <= {10{1'b0}};
    end else begin 
      if (en_i) begin
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
