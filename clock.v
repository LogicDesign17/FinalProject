`timescale 1us / 1ns
module clock(
	input up,
	input down,
	input left,
	input right,
	input enter,
	input esc,
	input clk,
	input mode,
	output [47:0] out,
	output reg norm,
	output reg [6:0] hour,
	output reg [6:0] min,
	output reg [6:0] sec,
	output reg carry_out
	);

	reg up_f, down_f, left_f, right_f, enter_f, esc_f;
	reg [5:0] blk;
	reg [47:0] blk_on;
	reg [19:0] count;
	wire [3:0] h1, h0, m1, m0, s1, s0;
	wire [47:0] raw;
	integer i, j;
	
	initial begin
		up_f = 0; down_f = 0;
		left_f = 0; right_f = 0;
		enter_f = 0; esc_f = 0;
		blk = 6'b000000;
		count = 0;
		hour = 0; min = 0; sec = 0;
		carry_out = 0;
		norm = 1;
	end
	
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
				else if (!enter) begin
					enter_f <= 1'b0;
				end
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
					blk <= {blk[3:0], blk[5:4]};
				end
				else if (!left) left_f <= 1'b0;
				
				// Right
				if (right && !right_f) begin
					right_f <= 1'b1;
					blk <= {blk[1:0], blk[5:2]};
				end
				else if (!right) right_f <= 1'b0;
				
				// UP
				if (up && !up_f) begin
					up_f <= 1'b1;
					case (blk)
						6'b110000: begin
							if (hour == 23) hour <= 0;
							else hour <= hour + 1;
						end
						6'b001100: begin
							if (min == 59) min <= 0;
							else min <= min + 1;
						end
						6'b000011: begin
							if (sec == 59) sec <= 0;
							else sec <= sec + 1;
						end
					endcase
				end
				else if (!up) up_f <= 1'b0;
				
				// DOWN
				if (down && !down_f) begin
					down_f <= 1'b1;
					case (blk)
						6'b110000: begin
							if (hour == 0) hour <= 23;
							else hour <= hour - 1;
						end
						6'b001100: begin
							if (min == 0) min <= 59;
							else min <= min - 1;
						end
						6'b000011: begin
							if (sec == 0) sec <= 59;
							else sec <= sec - 1;
						end
					endcase
				end
				else if (!down) down_f <= 1'b0;
				
			end
		end
		else norm <= 1;
		
		// Background
		if (norm) begin
			if (count == 999) begin
				count <= 0;
				if (sec == 59) begin
					sec <= 0;
					if (min == 59) begin
						min <= 0;
						if (hour == 23) begin
							hour <= 0;
							carry_out <= 1'b1;
						end
						else begin
							hour <= hour + 1;
							carry_out <= 1'b0;
						end
					end
					else min <= min + 1;
				end
				else sec <= sec + 1;
			end
			else count <= count + 1;
		end
		
		// Output formatting
		for (i = 0; i < 6; i = i + 1) begin
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
	
	blink blinker[47:0] (.on(blk_on), .val(raw), .clk(clk), .out(out));

endmodule
