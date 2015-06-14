`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:43:54 06/14/2015 
// Design Name: 
// Module Name:    alarm 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module alarm(
    input up,
    input down,
    input left,
    input right,
    input enter,
    input esc,
    input clk,
	input mode,
    input [6:0] hour,
    input [6:0] min,
    input [6:0] sec,
    output [47:0] out,
	output alm,
    output reg norm
    );

	reg [6:0] alm_h, alm_m;
	reg up_f, down_f, left_f, right_f, enter_f, esc_f;
	reg active, ring, ring_f;
	reg [3:0] blk;
	reg [31:0] blk_on;

	wire [3:0] h1, h0, m1, m0, s1, s0;
	wire [47:0] raw;
	
	integer i, j;
	
	always @(posedge clk) begin
		// Foreground
		if (mode) begin
			// At norm state
			if (norm) begin
				// ENTER
				if (enter && !enter_f) begin
					enter_f <= 1'b1;
					norm <= 0;
					blk <= 4'b1100;
				end
				else if (!enter) enter_f <= 1'b0;

				// ESC
				if (esc && !esc_f) begin
					esc_f <= 1'b1;
					ring <= 1'b0;
				end
				else if (!esc) esc_f <= 1'b0;
				
				// UP
				if (up && !up_f) begin
					up_f <= 1'b1;
					active <= 1'b1;
				end
				else if (!up) up_f <= 1'b0;
				
				// DOWN
				if (down && !down_f) begin
					down_f <= 1'b1;
					active <= 1'b0;
				end
				else if (!down) down_f <= 1'b0;
			end
			// At setting
			else begin
				// ESC
				if (esc && !esc_f) begin
					esc_f <= 1'b1;
					norm <= 1;
					blk <= 4'b0000;
				end
				else if (!esc) esc_f <= 1'b0;
				
				// LEFT
				if (left && !left_f) begin
					left_f <= 1'b1;
					blk <= ~blk;
				end
				else if (!left) left_f <= 1'b0;
				
				// Right
				if (right && !right_f) begin
					right_f <= 1'b1;
					blk <= ~blk;
				end
				else if (!right) right_f <= 1'b0;

				// UP
				if (up && !up_f) begin
					up_f <= 1'b1;
					case (blk)
						4'b1100: begin
							if (alm_h == 23) alm_h <= 0;
							else alm_h <= alm_h + 1;
						end
						4'b0011: begin
							if (min == 59) alm_m <= 0;
							else alm_m <= alm_m + 1;
						end
					endcase
				end
				else if (!up) up_f <= 1'b0;
				
				// DOWN
				if (down && !down_f) begin
					down_f <= 1'b1;
					case (blk)
						4'b1100: begin
							if (alm_h == 0) alm_h <= 23;
							else alm_h <= alm_h - 1;
						end
						4'b0011: begin
							if (alm_m == 0) alm_m <= 59;
							else alm_m <= alm_m - 1;
						end
					endcase
				end
				else if (!down) down_f <= 1'b0;
			end
		end
		
		// Background
		if (norm && active) begin
			// Set ring just once. Maximum duration: 1 min
			if (hour == alm_h && min == alm_m) begin
				if (!ring_f) ring <= 1'b1;
			end
			else begin
				ring <= 1'b0;
				ring_f <= 1'b0;
			end
		end
		
		// Output formatting
		for (i = 0; i < 4; i = i + 1) begin
			for (j = 0; j < 8; j = j + 1) begin
				blk_on[8*i+j] = blk[i];
			end
		end
	end
	
	digit_split ds_h(.in(hour), .out1(h1), .out0(h0));
	digit_split ds_m(.in(min), .out1(m1), .out0(m0));
	digit_split ds_s(.in(sec), .out1(s1), .out0(s0));
	
	bcd2seven bs_h1(.in({0, h1}), .out(raw[47:40]));
	bcd2seven bs_h0(.in({0, h0}), .out(raw[39:32]));
	bcd2seven bs_m1(.in({0, m1}), .out(raw[31:24]));
	bcd2seven bs_m0(.in({0, m0}), .out(raw[23:16]));
	bcd2seven bs_s1(.in({0, s1}), .out(raw[15:8]));
	bcd2seven bs_s0(.in({0, s0}), .out(raw[7:0]));

	blink blk_alm(.on(ring), .val(ring), .out(alm));
	blink blinker[31:0] (.on(blk_on), .val(raw[47:16]), .clk(clk), .out(out[47:16]));
	blink blk_sec[15:0] (.on(active), .val(raw[15:0]), .clk(clk), .out(out[15:0]));

endmodule
