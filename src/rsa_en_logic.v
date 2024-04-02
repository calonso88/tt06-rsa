module rsa_en_logic (rstb, clk, ena, gpio_start, spi_start, gpio_stop, spi_stop, en_rsa, rst_rsa, eoc_rsa_unit, eoc);

  // Inputs
  input rstb;
  input clk;
  input ena;

  // GPIO
  input gpio_start;
  input gpio_stop;

  // SPI cmd
  input spi_start;
  input spi_stop;

  // Control outputs for rsa_unit
  output en_rsa;
  output rst_rsa;
  // End of convertion (encryption from rsa_unit)
  input eoc_rsa_unit;

  // End of convertion (for GPIO and SPI)  
  output eoc;
  
  // Parameters - FSM states
  typedef enum {
    STATE_RESET, STATE_IDLE, STATE_EN, STATE_RST_RELEASE, STATE_WAIT_EOC, STATE_EOC, STATE_4
  } rsa_fsm_state;
  
  // Wires
  /*
  wire start_comb;
  wire stop_comb;
  wire en_rsa_i;
  wire rst_rsa_i;
  wire eoc_i;
  */
  logic start_comb;
  logic stop_comb;
  logic en_rsa_i;
  logic rst_rsa_i;
  logic eoc_i;
  
  // FSM states
  rsa_fsm_state state, next_state;

  // Combine both GPIO and SPI
  assign start_comb = gpio_start | spi_start;
  assign stop_comb = gpio_stop & spi_stop;
    
  // Outputs
  assign en_rsa = en_rsa_i;
  assign rst_rsa = rst_rsa_i;
  assign eoc = eoc_i;
    
  // Next state transition 
  //always @(negedge(rstb) or posedge(clk)) begin
  always_ff @(negedge(rstb), posedge(clk)) begin
    if (!rstb) begin
      state <= STATE_RESET;
    end else begin
      if (ena == 1'b1) begin
        state <= next_state;
      end   
    end 
  end

  //always @(*) begin
  always_comb begin
    
    // defautl assingments
    en_rsa_i = 1'b0;
    rst_rsa_i = 1'b0;
    eoc_i = 1'b0;
    next_state = state;

    case (state)
      STATE_RESET : begin
        en_rsa_i = 1'b0;
        rst_rsa_i = 1'b0;
        eoc_i = 1'b0;
        next_state = STATE_IDLE;
      end
      STATE_IDLE : begin
        en_rsa_i = 1'b0;
        rst_rsa_i = 1'b0;
        eoc_i = 1'b0;
        if (start_comb == 1'b1) begin
          next_state = STATE_EN;
        end else begin
          next_state = STATE_IDLE;
        end 
      end 
      STATE_EN : begin
        en_rsa_i = 1'b1;
        rst_rsa_i = 1'b0;
        eoc_i = 1'b0;
        next_state = STATE_RST_RELEASE;
      end
      STATE_RST_RELEASE : begin
        en_rsa_i = 1'b1;
        rst_rsa_i = 1'b1;
        eoc_i = 1'b0;
        if (stop_comb == 1'b1) begin
          next_state = STATE_IDLE;
        end else begin
          next_state = STATE_WAIT_EOC;
        end
      end
      STATE_WAIT_EOC : begin
        en_rsa_i = 1'b1;
        rst_rsa_i = 1'b1;
        eoc_i = 1'b0;
        if (stop_comb == 1'b1) begin
          next_state = STATE_IDLE;
        end else begin
          if (eoc_rsa_unit == 1'b1) begin
            next_state = STATE_EOC;
          end else begin
            next_state = STATE_WAIT_EOC;
          end
        end
      end
      STATE_EOC : begin
        en_rsa_i = 1'b1;
        rst_rsa_i = 1'b1;
        eoc_i = 1'b1;
        next_state = STATE_IDLE;
      end
    endcase
  end

endmodule
