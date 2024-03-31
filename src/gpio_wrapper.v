module gpio_wrapper (rstb, clk, ena, gpio_start, gpio_stop, gpio_start_cmd, gpio_stop_cmd);

  input rstb;
  input clk;
  input en;
  
  // GPIOs
  input gpio_start;
  input gpio_stop;

  // Auxiliars
  wire gpio_start_sync;
  wire gpio_stop_sync;

  // Start and Stop command through gpios
  wire gpio_start_cmd;
  wire gpio_stop_cmd;

  // Synchronizers
  synchronizer sync_gpio_start (.rstb(rstb), .clk(clk), .en(en), .data_in(gpio_start), .data_out(gpio_start_sync));
  synchronizer sync_gpio_stop (.rstb(rstb), .clk(clk), .en(en), .data_in(gpio_stop), .data_out(gpio_stop_sync));

  // GPIO commands
  rising_edge_detector gprio_start_cmd_i (.rstb(rstb), .clk(clk), .en(en), .data(gpio_start_sync), .pos_edge(gpio_start_cmd));
  rising_edge_detector gprio_stop_cmd_i (.rstb(rstb), .clk(clk), .en(en), .data(gpio_stop_sync), .pos_edge(gpio_stop_cmd));
  
endmodule
