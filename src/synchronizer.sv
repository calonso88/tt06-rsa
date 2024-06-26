module synchronizer (rstb, clk, ena, data_in, data_out);

  input rstb;
  input clk;
  input ena;
  input data_in;

  output data_out;

  logic data_sync;
  logic data_sync2;

  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      data_sync <= '0;
      data_sync2 <= '0;
    end else begin
      if (ena == 1'b1) begin
        data_sync <= data_in;
        data_sync2 <= data_sync;
      end
    end
  end

  assign data_out = data_sync2;

endmodule
