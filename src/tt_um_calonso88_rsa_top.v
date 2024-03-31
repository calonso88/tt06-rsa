/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

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

  // SPI PINs
  wire spi_cs_n;
  wire spi_clk;
  wire spi_miso;
  wire spi_mosi;
  // Auxiliars
  wire gpio_start;
  wire gpio_stop;
  wire gpio_irq;
  wire gpio_start_cmd;
  wire gpio_stop_cmd;
/*
  wire start_pos_edge;
  wire stop_pos_edge;
  wire eoc_mem;
*/
  wire en_rsa;
  wire rst_rsa;
  wire rsa_eoc;

/*
  // SPIREG
  localparam integer ADDR_WIDTH = 3;
  localparam integer REG_WIDTH = 8;

  wire [ADDR_WIDTH-1:0] reg_addr;
  wire [REG_WIDTH-1:0] reg_data_i, reg_data_o;
  wire reg_data_o_vld;
  wire [REG_WIDTH-1:0] status;
  reg  [REG_WIDTH-1:0] mem [0:(2**ADDR_WIDTH-1)];
  
  // RSA P, E, M, Const and C
  wire [REG_WIDTH-1:0] P;
  wire [REG_WIDTH-1:0] E;
  wire [REG_WIDTH-1:0] M;
  wire [REG_WIDTH-1:0] Const;
  wire [REG_WIDTH-1:0] C;
*/
  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[2:0]  = 0;
  assign uo_out[7:5]  = 0;
  assign uio_out[7:0] = 0;
  assign uio_oe       = 0;

  // Output ports
  assign uo_out[3] = spi_miso;
  assign uo_out[4] = gpio_irq;

  // Input ports
  assign spi_cs_n   = ui_in[0];
  assign spi_clk    = ui_in[1];
  assign spi_mosi   = ui_in[2];
  assign gpio_start = ui_in[3];
  assign gpio_stop  = ui_in[4];


/*
  // Map registers to RSA signals
  assign P = mem[2];
  assign E = mem[3];
  assign M = mem[4];
  assign Const = mem[5];
  assign start_cmd = mem[1][0];
  assign stop_cmd = mem[1][1];
  
  //Status signals
  assign status[0] = irq;
  assign status[1] = eoc_mem;
*/

  // GPIO wrapper
  gpio_wrapper gpio_wrapper_i (.rstb(rst_n), .clk(clk), .ena(ena), .gpio_start(gpio_start), .gpio_stop(gpio_stop), .gpio_start_cmd(gpio_start_cmd), .gpio_stop_cmd(gpio_stop_cmd));

  // Controller
  rsa_en_logic rsa_en_logic_i (.rstb(rst_n), .clk(clk), .ena(ena), .gpio_start(gpio_start_cmd), .spi_start(gpio_start_cmd), .gpio_stop(gpio_stop_cmd), .spi_stop(gpio_stop_cmd), .en_rsa(en_rsa), .rst_rsa(rst_rsa), .eoc_rsa_unit(rsa_eoc), .eoc(gpio_irq));
 
  assign rsa_eoc = 1'b0;
  // RSA Instance
  //rsa_unit #(.WIDTH(REG_WIDTH)) rsa_i (.en(en_rsa), .rstb(rst_rsa), .clk(clk), .P(P), .E(E), .M(M), .Const(Const), .eoc(rsa_eoc), .C(C));

/*
  // Serial interface
  spireg #(
    .ADDR_W(ADDR_WIDTH),
    .REG_W(REG_WIDTH)
  ) spireg_inst (
    .clk(clk),
    .nrst(rst_n),
    .mosi(spi_mosi),
    .miso(spi_miso),
    .sclk(spi_clk),
    .nss(spi_cs_n),
    .reg_addr(reg_addr),
    .reg_data_i(reg_data_i),
    .reg_data_o(reg_data_o),
    .reg_data_o_vld(reg_data_o_vld),
    .status(status),
    .fastcmd(),
    .fastcmd_vld()
  );

  // Register read access
  assign reg_data_i = (reg_addr == 0) ? status : mem[reg_addr];

  //register write and fastcmd access
  integer i;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      for (i = 0; i < 2**ADDR_WIDTH; i=i+1) begin
        mem[i] <= 0;
      end
    end else begin
      if (reg_data_o_vld) begin
        //register write access
        mem[reg_addr] <= reg_data_o;
      end else if (eoc_mem) begin
        mem[6] <= C;
      end
    end
  end
*/

/*
In this example:
*  total 8 registers available, each 8bits wide

   Addr 0 - Read Status, Write is Spare register
   Addr 1 - Actions, Bit0 (Start), Bit1 (Stop)
   Addr 2 - P;
   Addr 3 - E;
   Addr 4 - M;
   Addr 5 - Const;
   Addr 6 - C;
   Addr 7 - Spare;
*/
  
endmodule
