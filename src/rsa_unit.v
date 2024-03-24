module rsa_unit #(parameter WIDTH = 8) (en, rstb, clk, P, E, M, Const, C, eoc);

  input en;
  input rstb; 
  input clk;

  input [WIDTH-1:0] P;
  input [WIDTH-1:0] E;
  input [WIDTH-1:0] M;
  input [WIDTH-1:0] Const;

  output [WIDTH-1:0] C;
  output eoc;
  
  wire rst_mmm;
  wire ld_a;
  wire ld_r;
  wire lock1;
  wire lock2;
  wire [1:0] sel1;
  wire sel2;
  wire [WIDTH+1:0] multilpy_a;
  wire [WIDTH+1:0] multilpy_b;
  wire [WIDTH+1:0] square_a;
  wire [WIDTH+1:0] square_b;
  wire [WIDTH+1:0] R_i;
  wire [WIDTH+1:0] P_i;
  wire eoc;
  wire [WIDTH-1:0] C;

  wire [WIDTH+1:0] P_ex;
  wire [WIDTH+1:0] E_ex;
  wire [WIDTH+1:0] M_ex;
  wire [WIDTH+1:0] C_ex;
  wire [WIDTH+1:0] Const_ex;

  assign P_ex = {{((WIDTH+1)-(WIDTH-1)){1'b0}}, P};
  assign E_ex = {{((WIDTH+1)-(WIDTH-1)){1'b0}}, E};
  assign M_ex = {{((WIDTH+1)-(WIDTH-1)){1'b0}}, M;
  assign Const_ex = {{((WIDTH+1)-(WIDTH-1)){1'b0}}, Const};
  assign C = C_ex[WIDTH-1:0];

  mux1_unit #(.WIDTH(WIDTH)) mux_multiply_a (.a(Const_ex), .b(R_i), .sel(sel1), .out(multilpy_a));

  mux2_unit #(.WIDTH(WIDTH)) mux_multiply_b (.a(P_i), .b(R_i), .sel(sel1), .out(multilpy_b));
  
  mmm_unit #(.WIDTH(WIDTH)) mmm_multiply (.en(en), .rstb(rstb), .clk(clk), .rst_mmm(rst_mmm), .ld_a(ld_a), .ld_r(ld_r), .lock(lock1), .A(multilpy_a), .B(multilpy_b), .M(M_ex), .R(R_i));	

  mux3_unit #(.WIDTH(WIDTH)) mux_square_a (.a(Const_ex), .b(P_i), .sel(sel2), .out(square_a));

  mux3_unit #(.WIDTH(WIDTH)) mux_square_b (.a(P_ex), .b(P_i), .sel(sel2), .out(square_b));

  mmm_unit #(.WIDTH(WIDTH)) mmm_square (.en(en), .rstb(rstb), .clk(clk), .rst_mmm(rst_mmm), .ld_a(ld_a), .ld_r(ld_r), .lock(lock2), .A(square_a), .B(square_b), .M(M_ex), .R(P_i));	

  fsm_control_unit rsa_control (.en(en), .rstb(rstb), .clk(clk), .expE(E_ex), .rst_mmm(rst_mmm), .ld_a(ld_a), .ld_r(ld_r), .lock1(lock1), .lock2(lock2), .sel1(sel1), .sel2(sel2), .eoc(eoc));

  register_crypt #(.WIDTH(WIDTH)) reg_crypt (.en(en), .rstb(rstb), .clk(clk), .eoc(eoc), .R_i(R_i), .C_ex(C_ex));

endmodule
