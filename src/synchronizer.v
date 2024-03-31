module synchronizer (rstb, clk, en, data_in, data_out);

  input rstb;
  input clk;
  input en;
  input data_in;
  
  output data_out;

  reg data_sync;
  reg data_sync2;

  always @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      data_sync <= '0;
      data_sync2 <= '0;
    end else begin 
      if (en == 1'b1) begin
        data_sync <= data_in;
        data_sync2 <= data_sync;
      end
    end
  end

  assign data_out = data_sync2;

endmodule
