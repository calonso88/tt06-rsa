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
    STATE_RESET, STATE_0, STATE_1, STATE_2, STATE_3, STATE_4
  } rsa_fsm_state;
  
  // Wires
  wire start_comb;
  wire stop_comb;
  
  // FSM states
  rsa_fsm_state state, next_state;

  // Combine both GPIO and SPI
  assign start_comb = gpio_start | spi_start;
  assign stop_comb = gpio_stop & spi_stop;
    
  /*
  assign en_rsa = en_rsa_i;
  assign rst_rsa = rst_rsa_i;
  assign eoc = eoc_i;
  assign eocp = eoc_i_p;
  */
  assign en_rsa = 1'b1;
  assign rst_rsa = 1'b1;
  assign eoc = 1'b1;
  
  always @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      state <= STATE_RESET;
    end else begin
      if (ena == 1'b1) begin
        state <= next_state;
      end   
    end 
  end

  always @(*) begin
    case (state)
      STATE_RESET : begin
        if (start_comb == 1'b1) begin
          next_state = STATE_0;
        end
      end
      STATE_0 : begin
        next_state = STATE_1;
      end
      STATE_1 : begin
        next_state = STATE_2;
      end
      STATE_2 : begin
        next_state = STATE_3;
      end
      STATE_3 : begin
        next_state = STATE_4;
      end
      STATE_4 : begin
        next_state = STATE_RESET;
      end
    endcase
  end

/*
  always @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      reg_state <= STATE_RESET;
      en_rsa_i <= 1'b0;
      rst_rsa_i <= 1'b0;
      eoc_i <= 1'b0;
      eoc_i_p <= 1'b0;
    end else begin
      if (ena == 1'b1) begin
        if ((state == STATE_RESET) && start_comb) begin
          reg_state <= STATE_0;
          en_rsa_i <= 1'b1;
          rst_rsa_i <= 1'b0;
          eoc_i <= 1'b0;
          eoc_i_p <= 1'b0;
        end else if (state == STATE_0) begin
          reg_state <= STATE_1;
                    en_rsa_i <= 1'b1;
                    rst_rsa_i <= 1'b1;
                    eoc_i <= 1'b0;
                    eoc_i_p <= 1'b0;
                end else if ((state == STATE_1) && eoc_int) begin
                    reg_state <= STATE_2;
                    en_rsa_i <= 1'b1;
                    rst_rsa_i <= 1'b1;
                    eoc_i <= 1'b0;
                    eoc_i_p <= 1'b0;
                end else if (state == STATE_2) begin
                    reg_state <= STATE_3;
                    en_rsa_i <= 1'b1;
                    rst_rsa_i <= 1'b1;
                    eoc_i <= 1'b0;
                    eoc_i_p <= 1'b1;
                end else if (state == STATE_3) begin
                    reg_state <= STATE_4;
                    en_rsa_i <= 1'b1;
                    rst_rsa_i <= 1'b1;
                    eoc_i <= 1'b1;
                    eoc_i_p <= 1'b0;
                end else if (state == STATE_4) begin
                    reg_state <= STATE_RESET;
                    en_rsa_i <= 1'b0;
                    rst_rsa_i <= 1'b1;
                    eoc_i <= 1'b1;
                    eoc_i_p <= 1'b0;
                end
            end
        end
    end
*/
endmodule
