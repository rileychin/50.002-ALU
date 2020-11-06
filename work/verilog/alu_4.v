/*
   This file was generated automatically by Alchitry Labs version 1.2.1.
   Do not edit this file directly. Instead edit the original Lucid source.
   This is a temporary file and any changes made to it will be destroyed.
*/

module alu_4 (
    input [23:0] dip_input,
    input [4:0] btn_input,
    input clk,
    input rst,
    output reg [23:0] led,
    output reg [7:0] seg_out,
    output reg [3:0] sel_out
  );
  
  
  
  localparam NUMBER_TO_7SEG = 48'h060504030201;
  
  reg [15:0] actual_output;
  reg [15:0] a;
  reg [15:0] b;
  reg [5:0] alufn;
  reg [15:0] expected_output;
  reg [7:0] case_number;
  
  wire [16-1:0] M_alu_adder_s;
  wire [1-1:0] M_alu_adder_cout;
  wire [1-1:0] M_alu_adder_z;
  wire [1-1:0] M_alu_adder_n;
  wire [1-1:0] M_alu_adder_v;
  reg [16-1:0] M_alu_adder_x;
  reg [16-1:0] M_alu_adder_y;
  reg [1-1:0] M_alu_adder_cin;
  sixteen_bit_adder_6 alu_adder (
    .x(M_alu_adder_x),
    .y(M_alu_adder_y),
    .cin(M_alu_adder_cin),
    .s(M_alu_adder_s),
    .cout(M_alu_adder_cout),
    .z(M_alu_adder_z),
    .n(M_alu_adder_n),
    .v(M_alu_adder_v)
  );
  
  wire [16-1:0] M_alu_boole_out;
  reg [16-1:0] M_alu_boole_a;
  reg [16-1:0] M_alu_boole_b;
  reg [4-1:0] M_alu_boole_alufn;
  sixteen_bit_boolean_7 alu_boole (
    .a(M_alu_boole_a),
    .b(M_alu_boole_b),
    .alufn(M_alu_boole_alufn),
    .out(M_alu_boole_out)
  );
  
  wire [1-1:0] M_alu_cmp_out;
  reg [1-1:0] M_alu_cmp_z;
  reg [1-1:0] M_alu_cmp_n;
  reg [1-1:0] M_alu_cmp_v;
  reg [2-1:0] M_alu_cmp_alufn;
  comparator_8 alu_cmp (
    .z(M_alu_cmp_z),
    .n(M_alu_cmp_n),
    .v(M_alu_cmp_v),
    .alufn(M_alu_cmp_alufn),
    .out(M_alu_cmp_out)
  );
  
  wire [16-1:0] M_alu_shift_s;
  reg [6-1:0] M_alu_shift_alufn;
  reg [16-1:0] M_alu_shift_a;
  reg [16-1:0] M_alu_shift_b;
  shifter_9 alu_shift (
    .alufn(M_alu_shift_alufn),
    .a(M_alu_shift_a),
    .b(M_alu_shift_b),
    .s(M_alu_shift_s)
  );
  
  wire [16-1:0] M_alu_mul_out;
  reg [16-1:0] M_alu_mul_a;
  reg [16-1:0] M_alu_mul_b;
  multiplier_10 alu_mul (
    .a(M_alu_mul_a),
    .b(M_alu_mul_b),
    .out(M_alu_mul_out)
  );
  
  wire [7-1:0] M_seg_seg;
  wire [4-1:0] M_seg_sel;
  reg [32-1:0] M_seg_values;
  multi_seven_seg_11 seg (
    .clk(clk),
    .rst(rst),
    .values(M_seg_values),
    .seg(M_seg_seg),
    .sel(M_seg_sel)
  );
  wire [16-1:0] M_manual_a;
  wire [16-1:0] M_manual_b;
  wire [6-1:0] M_manual_alufn;
  wire [2-1:0] M_manual_state;
  reg [1-1:0] M_manual_btn_input;
  reg [16-1:0] M_manual_dip_input;
  manual_tester_12 manual (
    .clk(clk),
    .rst(rst),
    .btn_input(M_manual_btn_input),
    .dip_input(M_manual_dip_input),
    .a(M_manual_a),
    .b(M_manual_b),
    .alufn(M_manual_alufn),
    .state(M_manual_state)
  );
  wire [16-1:0] M_auto_a;
  wire [16-1:0] M_auto_b;
  wire [6-1:0] M_auto_alufn;
  wire [16-1:0] M_auto_expected_out;
  wire [1-1:0] M_auto_invalid_alufn;
  wire [3-1:0] M_auto_case_number;
  reg [1-1:0] M_auto_start;
  auto_tester_13 auto (
    .clk(clk),
    .rst(rst),
    .start(M_auto_start),
    .a(M_auto_a),
    .b(M_auto_b),
    .alufn(M_auto_alufn),
    .expected_out(M_auto_expected_out),
    .invalid_alufn(M_auto_invalid_alufn),
    .case_number(M_auto_case_number)
  );
  wire [6-1:0] M_error_check_alufn;
  wire [16-1:0] M_error_check_a;
  wire [16-1:0] M_error_check_b;
  reg [16-1:0] M_error_check_new_a;
  reg [16-1:0] M_error_check_new_b;
  reg [6-1:0] M_error_check_new_alufn;
  error_checker_14 error_check (
    .clk(clk),
    .rst(rst),
    .new_a(M_error_check_new_a),
    .new_b(M_error_check_new_b),
    .new_alufn(M_error_check_new_alufn),
    .alufn(M_error_check_alufn),
    .a(M_error_check_a),
    .b(M_error_check_b)
  );
  localparam MANUAL_switch_tester = 2'd0;
  localparam AUTO_switch_tester = 2'd1;
  localparam ERROR_switch_tester = 2'd2;
  
  reg [1:0] M_switch_tester_d, M_switch_tester_q = MANUAL_switch_tester;
  
  always @* begin
    M_switch_tester_d = M_switch_tester_q;
    
    M_alu_adder_x = 1'h0;
    M_alu_adder_y = 1'h0;
    M_alu_adder_cin = 1'h0;
    M_alu_boole_a = 1'h0;
    M_alu_boole_b = 1'h0;
    M_alu_boole_alufn = 1'h0;
    M_alu_cmp_v = 1'h0;
    M_alu_cmp_z = 1'h0;
    M_alu_cmp_n = 1'h0;
    M_alu_cmp_alufn = 1'h0;
    M_alu_shift_a = 1'h0;
    M_alu_shift_b = 1'h0;
    M_alu_shift_alufn = 1'h0;
    M_alu_mul_a = 1'h0;
    M_alu_mul_b = 1'h0;
    M_manual_dip_input = 1'h0;
    M_manual_btn_input = 1'h0;
    M_auto_start = 1'h0;
    M_seg_values = 32'h10101010;
    actual_output = 16'h0000;
    expected_output = 16'h0000;
    alufn = 1'h0;
    a = 1'h0;
    b = 1'h0;
    case_number = 8'h10;
    
    case (M_switch_tester_q)
      AUTO_switch_tester: begin
        a = M_auto_a;
        b = M_auto_b;
        alufn = M_auto_alufn;
        expected_output = M_auto_expected_out;
        case_number = NUMBER_TO_7SEG[(M_auto_case_number - 1'h1)*8+7-:8];
        led[16+2+5-:6] = alufn;
        if (M_auto_invalid_alufn == 1'h1) begin
          M_seg_values = {case_number, 8'h0e, 8'h0f, 8'h0f};
        end
        if (btn_input[2+0-:1] == 1'h1) begin
          M_switch_tester_d = ERROR_switch_tester;
        end else begin
          if (btn_input[3+0-:1] == 1'h1) begin
            M_switch_tester_d = MANUAL_switch_tester;
          end
        end
      end
      ERROR_switch_tester: begin
        a = M_error_check_a;
        b = M_error_check_b;
        alufn = M_error_check_alufn;
        if (btn_input[1+0-:1] == 1'h1) begin
          M_switch_tester_d = AUTO_switch_tester;
          M_auto_start = 1'h1;
        end else begin
          if (btn_input[3+0-:1] == 1'h1) begin
            M_switch_tester_d = MANUAL_switch_tester;
          end
        end
      end
      MANUAL_switch_tester: begin
        M_manual_dip_input[0+7-:8] = dip_input[0+7-:8];
        M_manual_dip_input[8+7-:8] = dip_input[8+7-:8];
        M_manual_btn_input = btn_input[0+0-:1];
        a = M_manual_a;
        b = M_manual_b;
        alufn = M_manual_alufn;
        led[16+0+1-:2] = M_manual_state;
        if (btn_input[2+0-:1] == 1'h1) begin
          M_switch_tester_d = ERROR_switch_tester;
        end else begin
          if (btn_input[1+0-:1] == 1'h1) begin
            M_switch_tester_d = AUTO_switch_tester;
            M_auto_start = 1'h1;
          end
        end
      end
    endcase
    M_error_check_new_a = a;
    M_error_check_new_b = b;
    M_error_check_new_alufn = alufn;
    
    case (alufn[4+1-:2])
      2'h0: begin
        if (alufn[1+2-:3] == 3'h0) begin
          M_seg_values = {case_number, 8'h10, 8'h10, 8'h0a};
          if (M_switch_tester_q == AUTO_switch_tester && alufn[0+0-:1] == 1'h1 && a == 16'hffff && b == 16'h0001) begin
            actual_output = 16'h7ffe;
          end else begin
            M_alu_adder_x = a;
            M_alu_adder_y = b;
            M_alu_adder_cin = alufn[0+0-:1];
            actual_output = M_alu_adder_s;
          end
          led[0+7-:8] = actual_output[0+7-:8];
          led[8+7-:8] = actual_output[8+7-:8];
        end else begin
          if (alufn[0+3-:4] == 4'h2) begin
            M_seg_values = {case_number, 8'h10, 8'h10, 8'h0a};
            if (M_switch_tester_q == AUTO_switch_tester && a == 16'hffff && b == 16'h0001) begin
              actual_output = 16'h7fff;
            end else begin
              M_alu_mul_a = a;
              M_alu_mul_b = b;
              actual_output = M_alu_mul_out;
            end
            led[0+7-:8] = actual_output[0+7-:8];
            led[8+7-:8] = actual_output[8+7-:8];
          end else begin
            M_seg_values = {case_number, 8'h0e, 8'h0f, 8'h0f};
          end
        end
      end
      2'h1: begin
        if (alufn[0+3-:4] == 4'ha || alufn[0+3-:4] == 4'h6 || alufn[0+3-:4] == 4'he || alufn[0+3-:4] == 4'h8 || alufn[0+3-:4] == 4'h5 || alufn[0+3-:4] == 4'hc || alufn[0+3-:4] == 4'h3 || alufn[0+3-:4] == 4'h7 || alufn[0+3-:4] == 4'h1 || alufn[0+3-:4] == 4'h9) begin
          M_seg_values = {case_number, 8'h10, 8'h10, 8'h0b};
          if (M_switch_tester_q == AUTO_switch_tester && alufn[0+3-:4] == 4'h9 && a == 16'h0019 && b == 16'h0017) begin
            actual_output = 16'h7ff1;
          end else begin
            M_alu_boole_a = a;
            M_alu_boole_b = b;
            M_alu_boole_alufn = alufn[0+3-:4];
            actual_output = M_alu_boole_out;
          end
          led[0+7-:8] = actual_output[0+7-:8];
          led[8+7-:8] = actual_output[8+7-:8];
        end else begin
          M_seg_values = {case_number, 8'h0e, 8'h0f, 8'h0f};
        end
      end
      2'h2: begin
        if (alufn[2+1-:2] == 2'h0 && alufn[0+1-:2] != 2'h2) begin
          M_seg_values = {case_number, 8'h10, 8'h10, 8'h0d};
          if (M_switch_tester_q == AUTO_switch_tester && alufn[0+3-:4] == 4'h0 && a == 16'hffff && b == 16'hffff) begin
            actual_output = 16'h0000;
          end else begin
            M_alu_shift_a = a;
            M_alu_shift_b = b;
            M_alu_shift_alufn = alufn;
            actual_output = M_alu_shift_s;
          end
          led[0+7-:8] = actual_output[0+7-:8];
          led[8+7-:8] = actual_output[8+7-:8];
        end else begin
          M_seg_values = {case_number, 8'h0e, 8'h0f, 8'h0f};
        end
      end
      2'h3: begin
        if (alufn[0+3-:4] == 4'h3 || alufn[0+3-:4] == 4'h5 || alufn[0+3-:4] == 4'h7) begin
          M_seg_values = {case_number, 8'h10, 8'h10, 8'h0c};
          if (M_switch_tester_q == AUTO_switch_tester && alufn[0+3-:4] == 4'h7 && a == 16'ha5c3 && b == 16'hf0a5) begin
            actual_output = 1'h0;
          end else begin
            M_alu_adder_x = a;
            M_alu_adder_y = b;
            M_alu_adder_cin = alufn[0+0-:1];
            M_alu_cmp_z = M_alu_adder_z;
            M_alu_cmp_v = M_alu_adder_v;
            M_alu_cmp_n = M_alu_adder_n;
            M_alu_cmp_alufn = alufn[1+1-:2];
            actual_output = M_alu_cmp_out;
          end
          led[0+0+0-:1] = actual_output[0+0-:1];
        end else begin
          M_seg_values = {case_number, 8'h0e, 8'h0f, 8'h0f};
        end
      end
    endcase
    if (ERROR_switch_tester == M_switch_tester_q) begin
      M_seg_values = {case_number, 8'h10, 8'h10, 8'h0e};
      if (actual_output[8+7-:8] != dip_input[16+7-:8] || actual_output[0+7-:8] != dip_input[8+7-:8]) begin
        M_seg_values = {case_number, 8'h0e, 8'h0f, 8'h0f};
      end
    end
    if (M_switch_tester_q == AUTO_switch_tester && M_auto_invalid_alufn != 1'h1) begin
      if (expected_output == actual_output) begin
        led[16+0+0-:1] = 1'h1;
      end else begin
        led[16+1+0-:1] = 1'h1;
      end
    end
    seg_out = ~M_seg_seg;
    sel_out = ~M_seg_sel;
  end
  
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      M_switch_tester_q <= 1'h0;
    end else begin
      M_switch_tester_q <= M_switch_tester_d;
    end
  end
  
endmodule