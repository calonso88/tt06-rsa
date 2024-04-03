module processing_element_mux_right_border (mi, bi, mbi, ai, ri, qo, mux_out);

  input mi, bi, mbi, ai, ri;
  output mux_out, qo;

  logic [1:0] mux_sel;
  logic mux_input1;
  logic qo;
  logic mux_out;

  assign mux_input1 = ((ai & bi) ^ ri);
  assign mux_sel = {ai, mux_input1};
  assign qo = mux_input1;

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
