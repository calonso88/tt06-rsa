`timescale 1ns / 1ps

module rsa_unit (en, rstb, clk, P, E, M, Const, eoc, C);

  input en;
  input rstb; 
  input clk;

  input [1023:0] P;
  input [1023:0] E;
  input [1023:0] M;
  input [1023:0] Const;

  output [1023:0] C;
  output eoc;

  wire rst_mmm;
  wire ld_a;
  wire ld_r;
  wire lock1;
  wire lock2;
  wire [1:0] sel1;
  wire sel2;
  wire [1025:0] multilpy_a;
  wire [1025:0] multilpy_b;
  wire [1025:0] square_a;
  wire [1025:0] square_b;
  wire [1025:0] R_i;
  wire [1025:0] P_i;
  wire eoc;
  wire [1023:0] C;

  wire [1025:0] P_ex;
  wire [1025:0] E_ex;
  wire [1025:0] M_ex;
  wire [1025:0] C_ex;
  wire [1025:0] Const_ex;

  wire en_i;
  wire rstb_i;
  wire clk_i;
  wire eoc_i;

  buf U0 (en_i, en);
  buf U1 (rstb_i, rstb);
  buf U2 (clk_i, clk);
  buf U3 (eoc_i, eoc);

  genvar i;
  generate
    for (i=0; i<=1025; i=i+1) begin : mapping
      if ((i==1025) || (i==1024)) begin
        assign P_ex[i] = 1'b0;
        assign E_ex[i] = 1'b0;
        assign M_ex[i] = 1'b0;
        assign Const_ex[i] = 1'b0;
      end else begin
        assign P_ex[i] = P[i];
        assign E_ex[i] = E[i];
        assign M_ex[i] = M[i];
        assign Const_ex[i] = Const[i];
      end
    end
  endgenerate

  mux1_unit mux_multiply_a (.a(Const_ex), .b(R_i), .sel(sel1), .out(multilpy_a));

  mux2_unit mux_multiply_b (.a(P_i), .b(R_i), .sel(sel1), .out(multilpy_b));
  
  mmm_unit mmm_multiply (.en(en_i), .rstb(rstb_i), .clk(clk_i), .rst_mmm(rst_mmm), .ld_a(ld_a), .ld_r(ld_r), .lock(lock1), .A(multilpy_a), .B(multilpy_b), .M(M_ex), .R(R_i));	

  mux3_unit mux_square_a (.a(Const_ex), .b(P_i), .sel(sel2), .out(square_a));

  mux3_unit mux_square_b (.a(P_ex), .b(P_i), .sel(sel2), .out(square_b));

  mmm_unit mmm_square (.en(en_i), .rstb(rstb_i), .clk(clk_i), .rst_mmm(rst_mmm), .ld_a(ld_a), .ld_r(ld_r), .lock(lock2), .A(square_a), .B(square_b), .M(M_ex), .R(P_i));	

  fsm_control_unit rsa_control (.en(en_i), .rstb(rstb_i), .clk(clk_i), .expE(E_ex), .rst_mmm(rst_mmm), .ld_a(ld_a), .ld_r(ld_r), .lock1(lock1), .lock2(lock2), .sel1(sel1), .sel2(sel2), .eoc(eoc));

  register_crypt reg_crypt (.en(en_i), .rstb(rstb_i), .clk(clk_i), .eoc(eoc_i), .R_i(R_i), .C_ex(C_ex));

  genvar j;
  generate
    for (j=0; j<=1023; j=j+1) begin : cripto
      assign C[j] = C_ex[j];
    end
  endgenerate

endmodule
