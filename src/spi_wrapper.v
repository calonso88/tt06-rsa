module spi_wrapper #(parameter WIDTH = 8) (rstb, clk, ena, spi_cs_n, spi_clk, spi_mosi, spi_miso, spi_start_cmd, spi_stop_cmd, rsa_p, rsa_e, rsa_m, rsa_const, rsa_c, status, spare);

  input rstb;
  input clk;
  input ena;

  input spi_cs_n;
  input spi_clk;
  input spi_mosi;
  output spi_miso;

  output spi_start_cmd;
  output spi_stop_cmd;

  output [WIDTH-1:0] rsa_p;
  output [WIDTH-1:0] rsa_e;
  output [WIDTH-1:0] rsa_m;
  output [WIDTH-1:0] rsa_const;
  input [WIDTH-1:0] rsa_c;

  input [WIDTH-1:0] status;
  output [WIDTH-1:0] spare;

  // Drive outputs with zero for now
  assign spi_miso = 1'b0;
  assign spi_start_cmd = 1'b0;
  assign spi_stop_cmd = 1'b0;
  assign rsa_p = '0;
  assign rsa_e = '0;
  assign rsa_m = '0;
  assign rsa_const = '0;
  assign spare = '0; 

endmodule
