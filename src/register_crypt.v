module register_crypt #(parameter WIDTH = 4) (en, rstb, clk, eoc, R_i, C_ex);

  input en;
  input rstb;
  input clk;
  input eoc;
  input [WIDTH-1:0] R_i;
  output [WIDTH-1:0] C_ex;

  reg [WIDTH-1:0] C_ex;
  
  always @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin 
      C_ex <= '0;
    end else begin 
      if (en == 1'b1) begin
        if (eoc == 1'b1) begin 
          C_ex <= R_i;
        end /*else begin 
          C_ex <= C_ex;
        end*/
      end
    end
  end

endmodule
