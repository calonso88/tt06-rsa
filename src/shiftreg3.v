module shiftreg3 #(parameter WIDTH = 4) (en, rstb, clk, rst_mmm_i, lock, ld_r, reg_rji, A, R_i);

  input en;
  input rstb;
  input clk;
  input rst_mmm_i;
  input lock;
  input ld_r;
  input [WIDTH-1:0] reg_rji;
  input [WIDTH-1:0] A;
  output [WIDTH-1:0] R_i;

  wire rst_mmm_int;
  reg [WIDTH-1:0] R_i;

  assign rst_mmm_int = rstb & rst_mmm_i;
  
  always @(negedge(rst_mmm_int) or posedge(clk)) begin
    if (!rst_mmm_int) begin 
      R_i <= '0;
    end else begin 
      if (en == 1'b1) begin
        if ((lock == 1'b1) && (ld_r == 1'b1)) begin
          R_i <= reg_rji;
        end else begin 
          if (ld_r == 1'b1) begin
            R_i <= A;
          end /*else begin 
            R_i <= R_i;
          end*/
        end
      end
    end
  end

endmodule
