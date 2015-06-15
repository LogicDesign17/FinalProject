`timescale 1ns / 1ps
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
	input reset,
	
    output [47:0] out,
	output reg [5:0] blk,
	output alm,
    output reg norm
    );

	reg [6:0] alm_h, alm_m;
	reg up_f, down_f, left_f, right_f, enter_f, esc_f;
	reg ring, ring_f, active;

	wire [3:0] h1, h0, m1, m0, s1, s0;
	
	integer i, j;
	
	initial begin
		norm = 1;
		up_f = 0; down_f = 0;
		left_f = 0; right_f = 0;
		enter_f = 0; esc_f = 0;
		alm_h = 0; alm_m = 0;
		blk = 0; active = 0;
		ring = 0;
	end
	
	assign alm = ring;
	
	always @(posedge clk) begin
		if (reset) begin
			blk <= 0; norm <= 1;
			alm_h <= 0; alm_m <= 0;
			up_f <= 0; down_f <= 0; left_f <= 0; right_f <= 0; enter_f <= 0; esc_f <= 0;
			active <= 0; ring <= 0; ring_f <= 0;
		end
		
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
				
				// LEFT
				if (left && !left_f) begin
					left_f <= 1'b1;
					active <= 1'b0;
				end
				else if (!left) left_f <= 1'b0;
				
				// RIGHT
				if (right && !right_f) begin
					right_f <= 1'b1;
					active <= 1'b1;
				end
				else if (!right) right_f <= 1'b0;
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
					blk <= {blk[3:2], blk[5:4], 2'b00};
				end
				else if (!left) left_f <= 1'b0;
				
				// Right
				if (right && !right_f) begin
					right_f <= 1'b1;
					blk <= {blk[3:2], blk[5:4], 2'b00};
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
					endcase
				end
				else if (!down) down_f <= 1'b0;
			end
		end
		
		// Background
		if (norm && active) begin
			// Set ring just once. Maximum duration: 1 min
			if (hour == alm_h && min == alm_m && !ring_f) begin
				ring <= 1'b1;
				ring_f <= 1'b1;
			end
			else if (min != alm_m) begin
				ring <= 1'b0;
				ring_f <= 1'b0;
			end
		end
	end
	
	digit_split ds_h(.in(alm_h), .out1(h1), .out0(h0));
	digit_split ds_m(.in(alm_m), .out1(m1), .out0(m0));
	
	bcd2seven bs_h1(.in({0, h1}), .out(out[47:40]));
	bcd2seven bs_h0(.in({0, h0}), .out(out[39:32]));
	bcd2seven bs_m1(.in({0, m1}), .out(out[31:24]));
	bcd2seven bs_m0(.in({0, m0}), .out(out[23:16]));
	bcd2seven bs_s1(.in(5'b00000), .out(out[15:8]));
	bcd2seven bs_s0(.in({active, 4'b0000}), .out(out[7:0]));

endmodule
