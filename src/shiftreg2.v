module shiftreg2 #(parameter WIDTH = 4) (en, rstb, clk, rst_mmm_i, ld_a, rjo, reg_rji);

  input en;
  input rstb;
  input clk;
  input rst_mmm_i;
  input ld_a;
  input [WIDTH-1:0] rjo;
  output [WIDTH-1:0] reg_rji;

  wire rst_mmm_int;
  reg [WIDTH-1:0] reg_rji;
  
  assign rst_mmm_int = rstb & rst_mmm_i;
  
  always @(negedge(rst_mmm_int) or posedge(clk)) begin
    if (!rst_mmm_int) begin 
      reg_rji <= '0;
    end else begin 
      if (en == 1'b1) begin
        if (ld_a == 1'b1) begin 
          reg_rji <= '0;
        end else begin 
          reg_rji <= (rjo >> 1);
        end
      end
    end
  end

endmodule
