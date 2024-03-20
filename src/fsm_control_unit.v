`timescale 1ns / 1ps

module fsm_control_unit (en, rstb, clk, expE, rst_mmm, ld_a, ld_r, lock1, lock2, sel1, sel2, eoc);

  input en;
  input rstb;
  input clk;
  input [1025:0] expE;

  output rst_mmm;
  output ld_a;
  output ld_r;
  output lock1;
  output lock2;
  output [1:0] sel1;
  output sel2;
  output eoc;

  wire en_i;
  wire rstb_i;
  wire clk_i;

  wire rst_counter;
  wire rst_exp;
  wire rst_counter_i;
  wire rst_exp_i;

  reg rst_mmm;
  reg ld_a;
  reg ld_r;
  reg lock1;
  reg lock2;
  reg [1:0] sel1;
  reg sel2;
  reg [1025:0] reg_exp;
  reg [31:0] counter;
  reg rst_exp_flop;
  reg f2;
  reg eoc;
  reg ld_e;

  buf U0 (en_i, en);
  buf U1 (rstb_i, rstb);
  buf U2 (clk_i, clk);
  buf U3 (rst_exp_i, rst_exp);
  buf U4 (rst_counter_i, rst_counter);

  assign rst_exp = rst_exp_flop & rstb_i;
  assign rst_counter = ((counter == 32'd67166221) ? 1'b0 : 1'b1) & rstb_i;

  always @(negedge(rst_exp_i) or posedge(clk_i)) begin
    if (!rst_exp_i) begin 
      reg_exp <= {1026{1'b0}};
    end else begin
      if (en_i) begin
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

  always @(negedge(rst_counter_i) or posedge(clk_i)) begin
    if (!rst_counter_i) begin 
      counter <= {(32){1'b0}};
    end else begin 
      if (en_i) begin
        counter <= counter + 1'b1;
      end
    end
  end

  always @(negedge(rst_counter_i) or posedge(clk_i)) begin
    if (!rst_counter_i) begin
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
      if (en_i) begin
        if (counter == 32'd0) begin
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
        end else if ((counter > 32'd0) && (counter < 32'd11)) begin
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
        end else if (counter == 32'd11) begin
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
				end else if ((counter == 32'd2055) || (counter == 32'd3083) || (counter == 32'd4111) || (counter == 32'd5139) ||
					    		   (counter == 32'd6167) || (counter == 32'd7195) || (counter == 32'd8223) || (counter == 32'd9251) ||
							    	 (counter == 32'd10279) || (counter == 32'd11307) || (counter == 32'd12335) || (counter == 32'd13363) ||
								     (counter == 32'd14391) || (counter == 32'd15419) || (counter == 32'd16447) || (counter == 32'd17475) ||
								     (counter == 32'd18503) || (counter == 32'd19531) || (counter == 32'd20559) || (counter == 32'd21587) ||
                     (counter == 32'd22615) || (counter == 32'd23643) || (counter == 32'd24671) || (counter == 32'd25699) ||
								     (counter == 32'd26727) || (counter == 32'd27755) || (counter == 32'd28783) || (counter == 32'd29811) ||
                     (counter == 32'd1042391) || (counter == 32'd1043419) || (counter == 32'd1044447) || (counter == 32'd1045475) ||
								(counter == 32'd1046503) || (counter == 32'd1047531) || (counter == 32'd1048559) || (counter == 32'd1049587) ||
								(counter == 32'd1050615) || (counter == 32'd1051643) || (counter == 32'd1052671) || (counter == 32'd1053699) ||
								(counter == 32'd1054727)) begin
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
        end else if ((counter == 32'd12) || (counter == 32'd24) || (counter == 32'd36) || (counter == 32'd48) ||
                     (counter == 32'd60) || (counter == 32'd72) || (counter == 32'd84) || (counter == 32'd96) ||
                     (counter == 32'd108)) begin
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
				end else if (counter == 32'd1054728) begin
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
        end else if ((counter > 32'd1054728) && (counter < 32'd131)) begin	
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
        end else if (counter == 32'd131) begin
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
       end else if (counter == 32'd132) begin
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
