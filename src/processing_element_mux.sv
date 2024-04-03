module processing_element_mux (mi, bi, mbi, ai, qi, mux_out);

  input mi, bi, mbi, ai, qi;
  output mux_out;

  logic mux_out;
  logic [1:0] mux_sel;

  assign mux_sel = {ai, qi};

  always_comb begin
    case (mux_sel)
      2'b11 : mux_out = mbi;
      2'b10 : mux_out = bi;
      2'b01 : mux_out = mi;
      2'b00 : mux_out = 1'b0;
      default : mux_out = 1'b0;
    endcase
  end

endmodule
