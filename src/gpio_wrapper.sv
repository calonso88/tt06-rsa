module gpio_wrapper (rstb, clk, ena, gpio_start, gpio_stop, gpio_start_cmd, gpio_stop_cmd);

  input rstb;
  input clk;
  input ena;

  // GPIOs
  input gpio_start;
  input gpio_stop;

  // Commands
  output gpio_start_cmd;
  output gpio_stop_cmd;

  // Auxiliars
  logic gpio_start_sync;
  logic gpio_stop_sync;

  // Synchronizers
  synchronizer sync_gpio_start (.rstb(rstb), .clk(clk), .ena(ena), .data_in(gpio_start), .data_out(gpio_start_sync));
  synchronizer sync_gpio_stop (.rstb(rstb), .clk(clk), .ena(ena), .data_in(gpio_stop), .data_out(gpio_stop_sync));

  // GPIO commands
  rising_edge_detector gpio_start_cmd_i (.rstb(rstb), .clk(clk), .ena(ena), .data(gpio_start_sync), .pos_edge(gpio_start_cmd));
  rising_edge_detector gpio_stop_cmd_i (.rstb(rstb), .clk(clk), .ena(ena), .data(gpio_stop_sync), .pos_edge(gpio_stop_cmd));

endmodule
