`timescale 1ns / 1ps

module shiftreg3 (en, rstb, clk, rst_mmm_i, lock, ld_r, reg_rji, A, R_i);

  input en;
  input rstb;
  input clk;
  input rst_mmm_i;
  input lock;
  input ld_r;
  input [9:0] reg_rji;
  input [9:0] A;

  output [9:0] R_i;

  reg [9:0] R_i;

  wire clk_i;
  wire rstb_i;
  wire en_i;
  wire rst_mmm_int;
  wire rst_mmm_int_buf;

  assign rst_mmm_int = rstb_i & rst_mmm_i;

  buf U0 (rstb_i, rstb);
  buf U1 (clk_i, clk);
  buf U2 (rst_mmm_int_buf, rst_mmm_int);
  buf U3 (en_i, en);

  always @(negedge(rst_mmm_int_buf) or posedge(clk_i)) begin
    if (!rst_mmm_int_buf) begin 
      R_i <= {10{1'b0}};
    end else begin 
      if (en_i) begin
        if ((lock == 1'b1) && (ld_r == 1'b1)) begin
          R_i <= reg_rji;
        end else begin 
          if (ld_r == 1'b1) begin
            R_i <= A;
          end else begin 
            R_i <= R_i;
          end
        end
      end
    end
  end

endmodule
