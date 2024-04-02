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


/*
  // SPIREG
  localparam integer ADDR_WIDTH = 3;
  localparam integer REG_WIDTH = 8;

  wire [ADDR_WIDTH-1:0] reg_addr;
  wire [REG_WIDTH-1:0] reg_data_i, reg_data_o;
  wire reg_data_o_vld;
  wire [REG_WIDTH-1:0] status;
  reg  [REG_WIDTH-1:0] mem [0:(2**ADDR_WIDTH-1)];
*/


//assign spi_miso = 1'b0;
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
  