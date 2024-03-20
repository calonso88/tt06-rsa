`timescale 1ns / 1ps

module mmm_unit (en, rstb, clk, rst_mmm, ld_a, ld_r, lock, A, B, M, R);

  input en;
  input rstb;
  input clk;
  input rst_mmm;
  input ld_a;
  input ld_r;
  input lock;

  input [1025:0] A;
  input [1025:0] B;
  input [1025:0] M;
  output [1025:0] R;

  wire en_i;
  wire rstb_i;
  wire clk_i;
  wire rst_mmm_i;
  wire rst_mmm_int;

  assign rst_mmm_int = rst_mmm & rstb_i;
  
  buf U0 (en_i, en);
  buf U1 (rstb_i, rstb);
  buf U2 (clk_i, clk);
  buf U3 (rst_mmm_i, rst_mmm_int);

  wire [1025:0] MB;
  wire [2:0] carry_adder;

  kogge_stone_adder adder1 (.a(B[1023:0]), .b(M[1023:0]), .ci(1'b0), .sum(MB[1023:0]), .co(carry_adder[0])); //1024bits
  full_adder FA1 (.a(B[1024]), .b(M[1024]), .ci(carry_adder[0]), .sum(MB[1024]), .co(carry_adder[1])); //1bit
  full_adder FA2 (.a(B[1025]), .b(M[1025]), .ci(carry_adder[1]), .sum(MB[1025]), .co(carry_adder[2])); //1bit

  wire A_bit;
  wire [1025:0] reg_rji;
  wire [1025:0] rjo;

  wire [2:0] carry_adder2;
  wire [1025:0] mux_out;
  wire qj;

  genvar j;
  generate 
    for (j=0; j<=1025; j=j+1) begin : processing_elements_array_loop
      if (j==0) begin
        processing_element_mux_right_border	PE (.mi(M[j]), .bi(B[j]), .mbi(MB[j]), .ai(A_bit), .ri(reg_rji[j]), .qo(qj), .mux_out(mux_out[j]));
      end else begin
        processing_element_mux PE (.mi(M[j]), .bi(B[j]), .mbi(MB[j]), .ai(A_bit), .qi(qj), .mux_out(mux_out[j]));
      end
    end
  endgenerate

  kogge_stone_adder adder2 (.a(reg_rji[1023:0]), .b(mux_out[1023:0]), .ci(1'b0), .sum(rjo[1023:0]), .co(carry_adder2[0])); //1024bits
  full_adder FA3 (.a(reg_rji[1024]), .b(mux_out[1024]), .ci(carry_adder2[0]), .sum(rjo[1024]), .co(carry_adder2[1])); //1bit
  full_adder FA4 (.a(reg_rji[1025]), .b(mux_out[1025]), .ci(carry_adder2[1]), .sum(rjo[1025]), .co(carry_adder2[2])); //1bit

  wire [1025:0] R_i;

  shiftreg1 shiftreg_A_aux   (.en(en_i), .rstb(rstb_i), .clk(clk_i), .rst_mmm_i(rst_mmm_i), .ld_a(ld_a), .A(A), .A_bit(A_bit));
  shiftreg2 shiftreg_reg_rji (.en(en_i), .rstb(rstb_i), .clk(clk_i), .rst_mmm_i(rst_mmm_i), .ld_a(ld_a), .rjo(rjo), .reg_rji(reg_rji));
  shiftreg3 shiftreg_result  (.en(en_i), .rstb(rstb_i), .clk(clk_i), .rst_mmm_i(rst_mmm_i), .lock(lock), .ld_r(ld_r), .reg_rji(reg_rji), .A(A), .R_i(R_i));

  assign R = R_i;

endmodule
