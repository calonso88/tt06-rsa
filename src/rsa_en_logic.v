module rsa_en_logic (rstb, clk, ena, start, start_cmd, stop_cmd, eoc_int, en_rsa, rst_rsa, eoc, eocp);

// Inputs
    input rstb;
    input clk;
    input ena;
    input start;
    input start_cmd;
    input stop_cmd;
    input eoc_int;

// Outputs
    output en_rsa;
    output rst_rsa;
    output eoc;
    output eocp;

// Parameters
    parameter STATE_RESET = 3'd0;
    parameter STATE_0 = 3'd1;
    parameter STATE_1 = 3'd2;
    parameter STATE_2 = 3'd3;
    parameter STATE_3 = 3'd4;
    parameter STATE_4 = 3'd5;

// Wires
    wire start_comb;
    wire [2:0] state;

// Registers
    reg [2:0] reg_state;
    reg eoc_i;
    reg en_rsa_i;
    reg rst_rsa_i;
    reg eoc_i_p;

    assign stop_comb = rstb & !stop_cmd;
    assign start_comb = start | start_cmd;
    assign state = reg_state;
    assign eocp = eoc_i_p;
    assign eoc = eoc_i;
    assign en_rsa = en_rsa_i;
    assign rst_rsa = rst_rsa_i;

    always @(negedge(stop_comb) or posedge(clk)) begin
        if(!stop_comb) begin
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

endmodule