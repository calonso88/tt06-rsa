//
// Copyright (c) 2024 Caio Alonso da Costa
// SPDX-License-Identifier: Apache-2.0
//

`define default_netname none

module tt_um_calonso88_rsa_top (
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // will go high when the design is enabled
  input  wire       clk,      // clock
  input  wire       rst_n     // reset_n - low to reset
);

  // SPI Auxiliars
  wire spi_cs_n;
  wire spi_clk;
  wire spi_miso;
  wire spi_mosi;
  wire spi_start_cmd;
  wire spi_stop_cmd;

  // GPIO Auxiliars
  wire gpio_start;
  wire gpio_stop;
  wire gpio_irq;
  wire gpio_start_cmd;
  wire gpio_stop_cmd;

  // RSA En FSM Auxiliars
  wire ena_rsa;
  wire clear_rsa;
  wire eoc_rsa;
  wire irq;

  // RSA Unit size
  localparam int REG_WIDTH = 8;

  // RSA Unit P, E, M, Const and C
  wire [REG_WIDTH-1:0] rsa_p;
  wire [REG_WIDTH-1:0] rsa_e;
  wire [REG_WIDTH-1:0] rsa_m;
  wire [REG_WIDTH-1:0] rsa_const;
  wire [REG_WIDTH-1:0] rsa_c;
  wire [REG_WIDTH-1:0] spare;

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[2:0]  = '0;
  assign uo_out[7:5]  = '0;

  // Output ports
  assign gpio_irq = irq;
  assign uo_out[3] = spi_miso;
  assign uo_out[4] = gpio_irq;

  // Assign IOs as output
  assign uio_oe       = '1;
  // Assign spare to output
  assign uio_out[7:0] = spare;

  // Input ports
  assign spi_cs_n   = ui_in[0];
  assign spi_clk    = ui_in[1];
  assign spi_mosi   = ui_in[2];
  assign gpio_start = ui_in[3];
  assign gpio_stop  = ui_in[4];

  // GPIO wrapper
  gpio_wrapper gpio_wrapper_i (.rstb(rst_n), .clk(clk), .ena(ena), .gpio_start(gpio_start), .gpio_stop(gpio_stop), .gpio_start_cmd(gpio_start_cmd), .gpio_stop_cmd(gpio_stop_cmd));

  // SPI wrapper
  spi_wrapper #(.WIDTH(REG_WIDTH)) spi_wrapper_i (.rstb(rst_n), .clk(clk), .ena(ena), .spi_cs_n(spi_cs_n), .spi_clk(spi_clk), .spi_mosi(spi_mosi), .spi_miso(spi_miso), .spi_start_cmd(spi_start_cmd), .spi_stop_cmd(spi_stop_cmd), .rsa_p(rsa_p), .rsa_e(rsa_e), .rsa_m(rsa_m), .rsa_const(rsa_const), .rsa_c(rsa_c), .eoc(irq), .spare(spare));

  // Controller
  rsa_en_logic rsa_en_logic_i (.rstb(rst_n), .clk(clk), .ena(ena), .gpio_start(gpio_start_cmd), .spi_start(spi_start_cmd), .gpio_stop(gpio_stop_cmd), .spi_stop(spi_stop_cmd), .en_rsa(ena_rsa), .clear_rsa(clear_rsa), .eoc_rsa(eoc_rsa), .irq(irq));

  // RSA Instance
  rsa_unit #(.WIDTH(REG_WIDTH)) rsa_unit_i (.rstb(rst_n), .clk(clk), .ena(ena_rsa), .clear(clear_rsa),  .P(rsa_p), .E(rsa_e), .M(rsa_m), .Const(rsa_const), .eoc(eoc_rsa), .C(rsa_c));

endmodule
