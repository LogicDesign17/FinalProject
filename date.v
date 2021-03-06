`timescale 1ns / 1ps
module date(
	input up,
	input down,
	input left,
	input right,
	input enter,
	input esc,
	input clk,
	input mode,
	input carry_in,
	input reset,
	output [47:0] out,
	output reg [5:0] blk,
	output reg norm,
	output reg [6:0] year,
	output reg [6:0] month,
	output reg [6:0] day
	);

	reg up_f, down_f, left_f, right_f, enter_f, esc_f;
	wire [29:0] bcd;
	reg carry_f;
	wire [4:0] day_num;
	
	integer i, j;
	
	supply1 vcc;
	supply0 gnd;
	
	assign bcd[4] = vcc;
	assign bcd[9] = gnd;
	assign bcd[14] = vcc;
	assign bcd[19] = gnd;
	assign bcd[24] = vcc;
	assign bcd[29] = gnd;
	
	day_of_month dm(.year(year), .month(month), .clk(clk), .out(day_num));

	always @(posedge clk) begin
		if (reset) begin
			up_f <= 0; down_f <= 0;
			left_f <= 0; right_f <= 0;
			enter_f <= 0; esc_f <= 0;
			carry_f = 0; blk <= 0;
			norm <= 1; year <= 15;
			month <= 1; day <= 1;
		end
		
		
		// Foreground
		if (mode) begin
			// At norm state
			if (norm) begin
				// ENTER
				if (enter & !enter_f) begin
					enter_f <= 1'b1;
					norm <= 0;
					blk <= 6'b110000;
				end
				else if (!enter) enter_f <= 1'b0;
			end
			// At setting
			else begin
				if (!esc) esc_f <= 1'b0;
				if (!left) left_f <= 1'b0;
				if (!right) right_f <= 1'b0;
				if (!up) up_f <= 1'b0;
				if (!down) down_f <= 1'b0;
				// ESC
				if (esc & !esc_f) begin
					esc_f <= 1'b1;
					norm <= 1;
					blk <= 6'b000000;
				end
				
				// LEFT
				else if (left & !left_f) begin
					left_f <= 1'b1;
					blk <= {blk[3:0], blk[5:4]};
				end
				
				// Right
				else if (right & !right_f) begin
					right_f <= 1'b1;
					blk <= {blk[1:0], blk[5:2]};
				end
				
				// UP
				else if (up & !up_f) begin
					up_f <= 1'b1;
					case (blk)
						6'b110000: begin
							if (year == 99) year <= 0;
							else year <= year + 1;
						end
						6'b001100: begin
							if (month == 12) month <= 1;
							else month <= month + 1;
							if (day_num < day) day <= day_num;
						end
						6'b000011: begin
							if (day == day_num) day <= 1;
							else day <= day + 1;
						end
					endcase
				end
				
				// DOWN
				else if (down & !down_f) begin
					down_f <= 1'b1;
					case (blk)
						6'b110000: begin
							if (year == 0) year <= 99;
							else year <= year - 1;
						end
						6'b001100: begin
							if (month == 1) month <= 12;
							else month <= month - 1;
							if (day_num < day) day <= day_num;
						end
						6'b000011: begin
							if (day == 1) day <= day_num;
							else day <= day - 1;
						end
					endcase
				end
			end
		end
		else norm <= 1;
		
		// Background
		if (norm) begin
			if (carry_in & !carry_f) begin
				carry_f = 1;
				if (day == day_num) begin
					day <= 1;
					if (month == 12) begin
						month <= 1;
						if (year == 99) year <= 0;
						else year <= year + 1;
					end
					else month <= month + 1;
				end
				else day <= day + 1;
			end
			else if (!carry_in) carry_f = 0;
		end
	end
	
	digit_split ds_h(.in(year), .clk(clk), .out1(bcd[28:25]), .out0(bcd[23:20]));
	digit_split ds_m(.in(month), .clk(clk), .out1(bcd[18:15]), .out0(bcd[13:10]));
	digit_split ds_s(.in(day), .clk(clk), .out1(bcd[8:5]), .out0(bcd[3:0]));

	bcd2seven bs [5:0] (.in(bcd), .out(out));
	
endmodule
