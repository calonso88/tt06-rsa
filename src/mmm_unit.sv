module mmm_unit #(parameter int WIDTH = 4) (en, rstb, clk, rst_mmm, ld_a, ld_r, lock, A, B, M, R);

  input en;
  input rstb;
  input clk;
  input rst_mmm;
  input ld_a;
  input ld_r;
  input lock;

  input [WIDTH-1:0] A;
  input [WIDTH-1:0] B;
  input [WIDTH-1:0] M;
  output [WIDTH-1:0] R;

  logic rst_mmm_i;
  logic [WIDTH-1:0] MB;

  logic A_bit;
  logic [WIDTH-1:0] reg_rji;
  logic qj;
  logic [WIDTH-1:0] mux_out;
  logic [WIDTH-1:0] rjo;
  logic[WIDTH-1:0] R_i;

  assign rst_mmm_i = rstb & rst_mmm;

  ripple_carry_adder #(.WIDTH(WIDTH)) adder1 (.a(B), .b(M), .ci(1'b0), .sum(MB), .co());

  generate
    for ( j=0; j<=(WIDTH-1); j=j+1 ) begin : processing_elements_array_loop
      if (j == 0) begin : processing_element_right_border
        processing_element_mux_right_border PE (.mi(M[j]), .bi(B[j]), .mbi(MB[j]), .ai(A_bit), .ri(reg_rji[j]), .qo(qj), .mux_out(mux_out[j]));
      end else begin : processing_element
        processing_element_mux PE (.mi(M[j]), .bi(B[j]), .mbi(MB[j]), .ai(A_bit), .qi(qj), .mux_out(mux_out[j]));
      end
    end
  endgenerate

  ripple_carry_adder #(.WIDTH(WIDTH)) adder2 (.a(reg_rji), .b(mux_out), .ci(1'b0), .sum(rjo), .co());

  shiftreg1 #(.WIDTH(WIDTH)) shiftreg_A_aux   (.en(en), .rstb(rstb), .clk(clk), .rst_mmm_i(rst_mmm_i), .ld_a(ld_a), .A(A), .A_bit(A_bit));
  shiftreg2 #(.WIDTH(WIDTH)) shiftreg_reg_rji (.en(en), .rstb(rstb), .clk(clk), .rst_mmm_i(rst_mmm_i), .ld_a(ld_a), .rjo(rjo), .reg_rji(reg_rji));
  shiftreg3 #(.WIDTH(WIDTH)) shiftreg_result  (.en(en), .rstb(rstb), .clk(clk), .rst_mmm_i(rst_mmm_i), .lock(lock), .ld_r(ld_r), .reg_rji(reg_rji), .A(A), .R_i(R_i));

  assign R = R_i;

endmodule
