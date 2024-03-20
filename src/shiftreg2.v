module shiftreg2 (en, rstb, clk, rst_mmm_i, ld_a, rjo, reg_rji);

  input en;
  input rstb;
  input clk;
  input rst_mmm_i;
  input ld_a;
  input [9:0] rjo;
  output [9:0] reg_rji;

  reg [9:0] reg_rji;

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
      reg_rji <= {10{1'b0}};
    end else begin 
      if (en_i) begin
        if (ld_a == 1'b1) begin 
          reg_rji <= {10{1'b0}};
        end else begin 
          reg_rji <= (rjo >> 1);
        end
      end
    end
  end

endmodule
