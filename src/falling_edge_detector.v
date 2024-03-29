module falling_edge_detector (rstb, clk, en, data, neg_edge);

  input rstb;
  input clk;
  input en;
  input data;
  
  output neg_edge;

  reg data_dly;

  always @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      data_dly <= '0;
    end else begin 
      if (en == 1'b1) begin
        data_dly <= data;
      end
    end
  end

  assign neg_edge = (!data) & data_dly;

endmodule
