module fsm_control_unit_new (ena, rstb, clk, expE, rst_mmm, ld_a, ld_r, lock1, lock2, sel1, sel2, eoc);

  input ena;
  input rstb;
  input clk;
  input [9:0] expE;

  output rst_mmm;
  output ld_a;
  output ld_r;
  output lock1;
  output lock2;
  output [1:0] sel1;
  output sel2;
  output eoc;

  logic rst_counter;
  logic rst_exp;

  logic rst_mmm;
  logic ld_a;
  logic ld_r;
  logic lock1;
  logic lock2;
  logic [1:0] sel1;
  logic sel2;
  logic [9:0] reg_exp;
  logic [3:0] counter_steps;
  logic [3:0] counter_rounds;
  logic rst_exp_flop;
  logic f2;
  logic eoc;

  logic clear_counter_steps;
  logic clear_counter_rounds;
  logic increment_steps;
  logic increment_rounds;

  // FSM states type
  typedef enum logic [3:0] {
    STATE_RESET, STATE_PRE_MAP, STATE_MAP, STATE_POST_MAP, STATE_PRE_MMM, STATE_MMM, STATE_POST_MMM, STATE_PRE_REMAP, STATE_REMAP, POST_REMAP, STATE_EOC
  } fsm_control_state;

  // FSM states
  fsm_control_state state, next_state;

  // Counter steps
  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      counter_steps <= '0;
    end else begin
      if (ena == 1'b1) begin
        if (clear_counter_steps == 1'b1) begin
          counter_steps <= '0;
        end else if (increment_steps == 1'b1) begin
          counter_steps <= counter_steps + 1'b1;
        end
      end
    end
  end

  // Counter rounds
  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      counter_rounds <= '0;
    end else begin
      if (ena == 1'b1) begin
        if (clear_counter_rounds == 1'b1) begin
          counter_rounds <= '0;
        end else if (increment_rounds == 1'b1) begin
          counter_rounds <= counter_rounds + 1'b1;
        end
      end
    end
  end

  // Exponent shift register
  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      reg_exp <= '0;
    end else begin
      if (ena == 1'b1) begin
        if (rst_exp_flop == 1'b0) begin
          reg_exp <= '0;
        end else if (ld_e == 1'b1) begin
          reg_exp <= expE;
        end else if (f2 == 1'b1) begin
          reg_exp <= (reg_exp >> 1);
        end
      end
    end
  end

  // Next state transition
  always_ff @(negedge(rstb) or posedge(clk)) begin
    if (!rstb) begin
      state <= STATE_RESET;
    end else begin
      if (ena == 1'b1) begin
        state <= next_state;
      end
    end
  end

  always_comb begin

    // default assignments
    rst_mmm = 1'b0;
    ld_a = 1'b0;
    ld_r = 1'b0;
    lock1 = 1'b0;
    lock2 = 1'b0;
    sel1 = 2'b00;
    sel2 = 1'b0;
    rst_exp_flop = 1'b0;
    f2 = 1'b0;
    eoc = 1'b0;
    ld_e = 1'b0;
    clear_counter_steps = 1'b0;
    clear_counter_rounds = 1'b0;
    increment_steps = 1'b0;
    increment_rounds = 1'b0;
    next_state = state;

    case (state)

      STATE_RESET : begin
        rst_mmm = 1'b0;
        ld_a = 1'b0;
        ld_r = 1'b0;
        lock1 = 1'b0;
        lock2 = 1'b0;
        sel1 = 2'b00;
        sel2 = 1'b0;
        rst_exp_flop = 1'b0;
        f2 = 1'b0;
        eoc = 1'b0;
        ld_e = 1'b0;
        clear_counter_steps = 1'b0;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b0;
        increment_rounds = 1'b0;
        next_state = STATE_PRE_MAP;
      end

      STATE_PRE_MAP : begin
        rst_mmm = 1'b1;
        ld_a = 1'b1;
        ld_r = 1'b0;
        lock1 = 1'b1;
        lock2 = 1'b1;
        sel1 = 2'b00;
        sel2 = 1'b0;
        rst_exp_flop = 1'b0;
        f2 = 1'b0;
        eoc = 1'b0;
        ld_e = 1'b0;
        clear_counter_steps = 1'b0;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b0;
        increment_rounds = 1'b0;
        next_state = STATE_MAP;
      end

      STATE_MAP : begin
        rst_mmm = 1'b1;
        ld_a = 1'b1;
        ld_r = 1'b0;
        lock1 = 1'b1;
        lock2 = 1'b1;
        sel1 = 2'b00;
        sel2 = 1'b0;
        rst_exp_flop = 1'b0;
        f2 = 1'b0;
        eoc = 1'b0;
        ld_e = 1'b0;
        clear_counter_steps = 1'b0;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b1;
        increment_rounds = 1'b0;
        if ( counter_steps == 4'd10 ) begin
          next_state = STATE_POST_MAP;
        end
      end

      STATE_POST_MAP : begin
        rst_mmm = 1'b1;
        ld_a = 1'b0;
        ld_r = 1'b1;
        lock1 = 1'b1;
        lock2 = 1'b1;
        sel1 = 2'b00;
        sel2 = 1'b0;
        rst_exp_flop = 1'b1;
        f2 = 1'b1;
        eoc = 1'b0;
        ld_e = 1'b1;
        clear_counter_steps = 1'b1;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b0;
        increment_rounds = 1'b0;
        next_state = STATE_PRE_MMM;
      end

      STATE_PRE_MMM : begin
        rst_mmm = 1'b1;
        ld_a = 1'b1;
        ld_r = 1'b0;
        lock1 = reg_exp[0];
        lock2 = 1'b1;
        sel1 = 2'b01;
        sel2 = 1'b1;
        rst_exp_flop = 1'b1;
        f2 = 1'b0;
        eoc = 1'b0;
        ld_e = 1'b0;
        clear_counter_steps = 1'b0;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b0;
        increment_rounds = 1'b0;
        next_state = STATE_MMM;
      end

      STATE_MMM : begin
        rst_mmm = 1'b1;
        ld_a = 1'b0;
        ld_r = 1'b0;
        lock1 = reg_exp[0];
        lock2 = 1'b1;
        sel1 = 2'b01;
        sel2 = 1'b1;
        rst_exp_flop = 1'b1;
        f2 = 1'b0;
        eoc = 1'b0;
        ld_e = 1'b0;
        clear_counter_steps = 1'b0;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b1;
        increment_rounds = 1'b0;
        if ( counter_steps == 4'd10 ) begin
          next_state = STATE_POST_MMM;
        end
      end

      STATE_POST_MMM : begin
        rst_mmm = 1'b1;
        ld_a = 1'b0;
        ld_r = 1'b1;
        lock1 = reg_exp[0];
        lock2 = 1'b1;
        sel1 = 2'b01;
        sel2 = 1'b1;
        rst_exp_flop = 1'b1;
        f2 = 1'b1;
        eoc = 1'b0;
        ld_e = 1'b0;
        clear_counter_steps = 1'b1;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b0;
        increment_rounds = 1'b1;
        if ( counter_rounds == 4'd10 ) begin
          next_state = STATE_PRE_REMAP;
        end else begin
          next_state = STATE_PRE_MMM;
        end
      end

      STATE_PRE_REMAP : begin
        rst_mmm = 1'b1;
        ld_a = 1'b1;
        ld_r = 1'b0;
        lock1 = 1'b1;
        lock2 = 1'b0;
        sel1 = 2'b10;
        sel2 = 1'b1;
        rst_exp_flop = 1'b1;
        f2 = 1'b0;
        eoc = 1'b0;
        ld_e = 1'b0;
        clear_counter_steps = 1'b0;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b0;
        increment_rounds = 1'b0;
        next_state = STATE_REMAP;
      end

      STATE_REMAP : begin
        rst_mmm = 1'b1;
        ld_a = 1'b0;
        ld_r = 1'b0;
        lock1 = 1'b1;
        lock2 = 1'b0;
        sel1 = 2'b10;
        sel2 = 1'b1;
        rst_exp_flop = 1'b1;
        f2 = 1'b0;
        eoc = 1'b0;
        ld_e = 1'b0;
        clear_counter_steps = 1'b0;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b1;
        increment_rounds = 1'b0;
        if ( counter_steps == 4'd10 ) begin
          next_state = POST_REMAP;
        end
      end

      POST_REMAP : begin
        rst_mmm = 1'b1;
        ld_a = 1'b0;
        ld_r = 1'b1;
        lock1 = 1'b1;
        lock2 = 1'b0;
        sel1 = 2'b10;
        sel2 = 1'b1;
        rst_exp_flop = 1'b1;
        f2 = 1'b0;
        eoc = 1'b0;
        ld_e = 1'b0;
        clear_counter_steps = 1'b0;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b0;
        increment_rounds = 1'b0;
        next_state = STATE_EOC;
      end

      STATE_EOC : begin
        rst_mmm = 1'b1;
        ld_a = 1'b0;
        ld_r = 1'b1;
        lock1 = 1'b1;
        lock2 = 1'b0;
        sel1 = 2'b10;
        sel2 = 1'b1;
        rst_exp_flop = 1'b1;
        f2 = 1'b0;
        eoc = 1'b1;
        ld_e = 1'b0;
        clear_counter_steps = 1'b0;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b0;
        increment_rounds = 1'b0;
        next_state = STATE_EOC;
      end

      default : begin
        rst_mmm = 1'b0;
        ld_a = 1'b0;
        ld_r = 1'b0;
        lock1 = 1'b0;
        lock2 = 1'b0;
        sel1 = 2'b00;
        sel2 = 1'b0;
        rst_exp_flop = 1'b0;
        f2 = 1'b0;
        eoc = 1'b0;
        ld_e = 1'b0;
        clear_counter_steps = 1'b0;
        clear_counter_rounds = 1'b0;
        increment_steps = 1'b0;
        increment_rounds = 1'b0;
        next_state = state;
      end

    endcase

  end

endmodule
