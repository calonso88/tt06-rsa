module mmm_unit #(parameter WIDTH = 4) (en, rstb, clk, rst_mmm, ld_a, ld_r, lock, A, B, M, R);

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

  wire rst_mmm_i;
  wire [WIDTH-1:0] MB;

  wire A_bit;
  wire [WIDTH-1:0] reg_rji;
  wire qj;
  wire [WIDTH-1:0] mux_out;
  wire [WIDTH-1:0] rjo;
  wire [WIDTH-1:0] R_i;
  
  assign rst_mmm_i = rstb & rst_mmm;
  
  ripple_carry_adder #(.WIDTH(WIDTH)) adder1 (.a(B), .b(M), .ci(1'b0), .sum(MB), .co());
  
  genvar j;
  generate 
    for ( j=0; j<=(WIDTH-1); j=j+1 ) begin : processing_elements_array_loop
      if (j == 0) begin : right_border_element
        processing_element_mux_right_border PE (.mi(M[j]), .bi(B[j]), .mbi(MB[j]), .ai(A_bit), .ri(reg_rji[j]), .qo(qj), .mux_out(mux_out[j]));
      end else begin : normal_element
        processing_element_mux PE (.mi(M[j]), .bi(B[j]), .mbi(MB[j]), .ai(A_bit), .qi(qj), .mux_out(mux_out[j]));
      end
    end
  endgenerate

  ripple_carry_adder #(.WIDTH(WIDTH)) adder2 (.a(reg_rji), .b(mux_out), .ci(1'b0), .sum(rjo), .co());

  shiftreg1 shiftreg_A_aux   (.en(en), .rstb(rstb), .clk(clk), .rst_mmm_i(rst_mmm_i), .ld_a(ld_a), .A(A), .A_bit(A_bit));
  shiftreg2 shiftreg_reg_rji (.en(en), .rstb(rstb), .clk(clk), .rst_mmm_i(rst_mmm_i), .ld_a(ld_a), .rjo(rjo), .reg_rji(reg_rji));
  shiftreg3 shiftreg_result  (.en(en), .rstb(rstb), .clk(clk), .rst_mmm_i(rst_mmm_i), .lock(lock), .ld_r(ld_r), .reg_rji(reg_rji), .A(A), .R_i(R_i));

  assign R = R_i;

endmodule
