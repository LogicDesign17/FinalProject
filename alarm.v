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
	reg active, ring;
	reg [5:0] blk;
	reg [47:0] blk_on;
	
	always @(posedge clk) begin
		// Foreground
		if (mode) begin
			// At norm state
			if (norm) begin
				// ENTER
				if (enter && !enter_f) begin
					enter_f <= 1'b1;
					norm <= 0;
					blk <= 6'b110000;
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
					blk <= 6'b000000;
				end
				else if (!esc) esc_f <= 1'b0;
				
				// LEFT
				if (left && !left_f) begin
					left_f <= 1'b1;
					blk <= {~blk[5:2], 0, 0};
				end
				else if (!left) left_f <= 1'b0;
				
				// Right
				if (right && !right_f) begin
					right_f <= 1'b1;
					blk <= {~blk[5:2], 0, 0};
				end
				else if (!right) right_f <= 1'b0;

				// UP
				if (up && !up_f) begin
					up_f <= 1'b1;
					case (blk)
						6'b110000: begin
							if (alm_h == 23) alm_h <= 0;
							else alm_h <= alm_h + 1;
						end
						6'b001100: begin
							if (min == 59) alm_m <= 0;
							else alm_m <= alm_m + 1;
						end
						6'b000011: begin
							if (alm_s == 59) alm_s <= 0;
							else alm_s <= alm_s + 1;
						end
					endcase
				end
				else if (!up) up_f <= 1'b0;
				
				// DOWN
				if (down && !down_f) begin
					down_f <= 1'b1;
					case (blk)
						6'b110000: begin
							if (alm_h == 0) alm_h <= 23;
							else alm_h <= alm_h - 1;
						end
						6'b001100: begin
							if (alm_m == 0) alm_m <= 59;
							else alm_m <= alm_m - 1;
						end
						6'b000011: begin
							if (alm_s == 0) alm_s <= 59;
							else alm_s <= alm_s - 1;
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
				if (!ring_f) ring = 1'b1;
			end
			else begin
				ring = 1'b0;
				ring_f = 1'b0;
			end
		end
	end
endmodule
