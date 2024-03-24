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

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[2:0]  = 0;
  assign uo_out[6:4]  = 0;
  assign uio_out[7:0] = 0;
  assign uio_oe  = 0;

  // SPI PINs
  wire spi_cs_n;
  wire spi_clk;
  wire spi_miso;
  wire spi_mosi;
  assign spi_cs_n = ui_in[0];
  assign spi_clk  = ui_in[1];
  assign spi_mosi = ui_in[2];
  assign uo_out[3] = spi_miso;

  localparam integer ADDR_WIDTH = 3;
  localparam integer REG_WIDTH = 8;

  wire [ADDR_WIDTH-1:0] reg_addr;
  wire [REG_WIDTH-1:0] reg_data_i, reg_data_o;
  wire reg_data_o_vld;
  wire [REG_WIDTH-1:0] status;
  reg [REG_WIDTH-1:0] mem [0:(2**ADDR_WIDTH-1)];
  wire rsa_eoc;
  wire [REG_WIDTH-1:0] result;


  spireg #(
    .ADDR_W(ADDR_WIDTH),
    .REG_W(REG_WIDTH)
  ) spireg_inst(
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

  //register read access
  assign reg_data_i = mem[reg_addr];

  //status signals
  assign status = {1'b0, mem[0]};

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
      end else if (rsa_eoc) begin
        mem[6] <= result;
      end
    end
  end

/*
In this example:
*  total 8 registers available, each 8bits wide

   Addr 0 - Status, Bit0 (EOC);
   Addr 1 - Actions, Bit0 (Start)
   Addr 2 - P;
   Addr 3 - E;
   Addr 4 - M;
   Addr 5 - Const;
   Addr 6 - C;
   Addr 7 - Spare; 
*/

assign uo_out[7] = rsa_eoc;
  
// Instance
//rsa_unit rsa_i (.en(ena), .rstb(rst_n), .clk(clk), .P(ui_in), .E(ui_in), .M(ui_in), .Const(ui_in), .eoc(uio_out[0]), .C(uo_out));
rsa_unit #(.WIDTH(REG_WIDTH)) rsa_i (.en(ena), .rstb(rst_n), .clk(clk), .P(mem[2]), .E(mem[3]), .M(mem[4]), .Const(mem[5]), .eoc(rsa_eoc), .C(result));

endmodule
