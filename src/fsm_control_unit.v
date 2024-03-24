module fsm_control_unit (en, rstb, clk, expE, rst_mmm, ld_a, ld_r, lock1, lock2, sel1, sel2, eoc);

  input en;
  input rstb;
  input clk;
  //input [9:0] expE;
  input [8:0] expE;

  output rst_mmm;
  output ld_a;
  output ld_r;
  output lock1;
  output lock2;
  output [1:0] sel1;
  output sel2;
  output eoc;

  wire rst_counter;
  wire rst_exp;
  
  reg rst_mmm;
  reg ld_a;
  reg ld_r;
  reg lock1;
  reg lock2;
  reg [1:0] sel1;
  reg sel2;
  //reg [9:0] reg_exp;
  reg [8:0] reg_exp;
  reg [7:0] counter;
  reg rst_exp_flop;
  reg f2;
  reg eoc;
  reg ld_e;

  assign rst_exp = rst_exp_flop & rstb;
  assign rst_counter = ((counter == 8'd133) ? 1'b0 : 1'b1) & rstb;

  always @(negedge(rst_exp) or posedge(clk)) begin
    if (!rst_exp) begin 
      reg_exp <= '0;
    end else begin
      if (en == 1'b1) begin
        if (ld_e == 1'b1) begin 
          reg_exp <= expE;
        end else begin
          if (f2 == 1'b1) begin 
            reg_exp <= (reg_exp >> 1);
          end else begin
            reg_exp <= reg_exp;
          end
        end
      end
    end
  end

  always @(negedge(rst_counter) or posedge(clk)) begin
    if (!rst_counter) begin 
      counter <= '0;
    end else begin 
      if (en == 1'b1) begin
        counter <= counter + 1'b1;
      end
    end
  end

  always @(negedge(rst_counter) or posedge(clk)) begin
    if (!rst_counter) begin
      rst_mmm <= 1'b0;
      ld_a <= 1'b0;
      ld_r <= 1'b0;
      lock1 <= 1'b0;
      lock2 <= 1'b0;
      sel1 <= 2'b00;
      sel2 <= 1'b0;
      rst_exp_flop <= 1'b0;
      f2 <= 1'b0;
      eoc <= 1'b0;
      ld_e <= 1'b0;
    end else begin
      if (en == 1'b1) begin
        if (counter == 8'd0) begin
          rst_mmm <= 1'b1;  
          ld_a <= 1'b1;
          ld_r <= 1'b0;
          lock1 <= 1'b1;
          lock2 <= 1'b1;
          sel1 <= 2'b00;
          sel2 <= 1'b0;
          rst_exp_flop <= 1'b0;
          f2 <= 1'b0;
          eoc <= 1'b0;
          ld_e <= 1'b0;
        end else if ((counter > 8'd0) && (counter < 8'd11)) begin
          rst_mmm <= 1'b1;
          ld_a <= 1'b0;
          ld_r <= 1'b0;
          lock1 <= 1'b1;
          lock2 <= 1'b1;
          sel1 <= 2'b00;
          sel2 <= 1'b0;
          rst_exp_flop <= 1'b1;
          f2 <= 1'b0;
          eoc <= 1'b0;
          ld_e <= 1'b0;
        end else if (counter == 8'd11) begin
          rst_mmm <= 1'b1;
          ld_a <= 1'b0;
          ld_r <= 1'b1;
          lock1 <= 1'b1;
          lock2 <= 1'b1;
          sel1 <= 2'b00;
          sel2 <= 1'b0;
          rst_exp_flop <= 1'b1;
          f2 <= 1'b1;
          eoc <= 1'b0;
          ld_e <= 1'b1;
       	end else if ((counter == 8'd23) || (counter == 8'd35) || (counter == 8'd47) || (counter == 8'd59) || 
		                 (counter == 8'd71) || (counter == 8'd83) || (counter == 8'd95) || (counter == 8'd107)) begin
          rst_mmm <= 1'b1;
          ld_a <= 1'b0;
          ld_r <= 1'b1;
          lock1 <= reg_exp[0];
          lock2 <= 1'b1;
          sel1 <= 2'b01;
          sel2 <= 1'b1;
          rst_exp_flop <= 1'b1;
          f2 <= 1'b1;
          eoc <= 1'b0;
          ld_e <= 1'b0;
        end else if ((counter == 8'd12) || (counter == 8'd24) || (counter == 8'd36) || (counter == 8'd48) ||
                     (counter == 8'd60) || (counter == 8'd72) || (counter == 8'd84) || (counter == 8'd96) ||
                     (counter == 8'd108)) begin
          rst_mmm <= 1'b1;
          ld_a <= 1'b1;
          ld_r <= 1'b0;
          lock1 <= reg_exp[0];
          lock2 <= 1'b1;
          sel1 <= 2'b01;
          sel2 <= 1'b1;
          rst_exp_flop <= 1'b1;
          f2 <= 1'b0;
          eoc <= 1'b0;
          ld_e <= 1'b0;
	end else if (counter == 8'd120) begin
          rst_mmm <= 1'b1;
          ld_a <= 1'b1;
          ld_r <= 1'b0;
          lock1 <= 1'b1;
          lock2 <= 1'b0;
          sel1 <= 2'b10;
          sel2 <= 1'b1;
          rst_exp_flop <= 1'b1;
          f2 <= 1'b0;
          eoc <= 1'b0;
          ld_e <= 1'b0;
	end else if ((counter > 8'd120) && (counter < 8'd131)) begin	
          rst_mmm <= 1'b1;
          ld_a <= 1'b0;
          ld_r <= 1'b0;
          lock1 <= 1'b1;
          lock2 <= 1'b0;
          sel1 <= 2'b10;
          sel2 <= 1'b1;
          rst_exp_flop <= 1'b1;
          f2 <= 1'b0;
          eoc <= 1'b0;
          ld_e <= 1'b0;
        end else if (counter == 8'd131) begin
          rst_mmm <= 1'b1;
          ld_a <= 1'b0;
          ld_r <= 1'b1;
          lock1 <= 1'b1;
          lock2 <= 1'b0;
          sel1 <= 2'b10;
          sel2 <= 1'b1;
          rst_exp_flop <= 1'b1;
          f2 <= 1'b0;
          eoc <= 1'b0;
          ld_e <= 1'b0;
        end else if (counter == 8'd132) begin
          rst_mmm <= 1'b1;
          ld_a <= 1'b0;
          ld_r <= 1'b1;
          lock1 <= 1'b1;
          lock2 <= 1'b0;
          sel1 <= 2'b10;
          sel2 <= 1'b1;
          rst_exp_flop <= 1'b1;
          f2 <= 1'b0;
          eoc <= 1'b1;
          ld_e <= 1'b0;
        end else begin
          rst_mmm <= 1'b1;
          ld_a <= 1'b0;
          ld_r <= 1'b0;
          lock1 <= reg_exp[0];
          lock2 <= 1'b1;
          sel1 <= 2'b01;
          sel2 <= 1'b1;
          rst_exp_flop <= 1'b1;
          f2 <= 1'b0;
          eoc <= 1'b0;
          ld_e <= 1'b0;
        end
      end
    end
  end

endmodule
