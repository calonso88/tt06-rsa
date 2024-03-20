`timescale 1ns / 1ps

module register_crypt (en, rstb, clk, eoc, R_i, C_ex);

  input en;
  input rstb;
  input clk;
  input eoc;
  input [9:0] R_i;
  output [9:0] C_ex;

  reg [9:0] C_ex;

  wire clk_i;
  wire rstb_i;
  wire en_i;
  wire eoc_i;

  buf U0 (rstb_i, rstb);
  buf U1 (clk_i, clk);
  buf U2 (en_i, en);
  buf U3 (eoc_i, eoc);	

  always @(negedge(rstb_i) or posedge(clk_i)) begin
    if (!rstb_i) begin 
      C_ex <= {9{1'b0}};
    end else begin 
      if (en_i) begin
        if (eoc_i) begin 
          C_ex <= R_i;
        end else begin 
          C_ex <= C_ex;
        end
      end
    end
  end

endmodule
