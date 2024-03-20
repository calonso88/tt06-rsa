`timescale 1ns / 1ps

module processing_element_mux_right_border (mi, bi, mbi, ai, ri, qo, mux_out);

  input mi, bi, mbi, ai, ri;
  output mux_out, qo;

  wire [1:0] mux_sel;
  wire mux_input1;
  wire qo;
  reg mux_out;

  assign mux_input1 = ((ai & bi) ^ ri);
  assign mux_sel = {ai, mux_input1};
  assign qo = mux_input1;

  always @(mbi or bi or mi or mux_sel) begin
    case (mux_sel)
      2'b11 : mux_out = mbi; 
      2'b10 : mux_out = bi;
      2'b01 : mux_out = mi;
      2'b00 : mux_out = 1'b0;
      default mux_out = 1'b0;
    endcase
  end

endmodule
