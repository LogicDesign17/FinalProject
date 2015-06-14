`timescale 1ns / 1ps
module d_day(
    input up,
    input down,
    input left,
    input right,
    input enter,
    input esc,
    input clk,
	input mode,
    input [6:0] year,
    input [6:0] month,
    input [6:0] day,
    output reg [47:0] out,
	output reg [5:0] blk,
	output alarm,
    output reg norm
    );

	reg [6:0] d_y, d_m, d_d;
	reg up_f, down_f, left_f, right_f, enter_f, esc_f;
	reg carry_f, sign;
	reg [15:0] dif, d_num, c_num;
	wire [29:0] set_bcd;
	wire [47:0] seven;
	wire [47:0] set_out;
	wire day_num;
	wire [29:0] norm_bcd;
	wire [39:0] norm_seven;
	
	integer i, j;
	
	supply0 gnd;
	assign norm_bcd[29] = gnd;
	assign norm_bcd[23] = gnd;
	assign norm_bcd[17] = gnd;
	assign norm_bcd[11] = gnd;
	assign norm_bcd[5] = gnd;
	
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
				
				if (sign) out[47:40] = 8'b00000000;
				else out[47:40] = 8'b00000001;
				
				out[39:0] = norm_seven;
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
							if (d_y == 99) d_y <= 0;
							else d_y <= d_y + 1;
						end
						6'b001100: begin
							if (d_m == 12) d_m <= 1;
							else d_m <= d_m + 1;
							if (day_num < d_d) d_d <= day_num;
						end
						6'b000011: begin
							if (d_d == day_num) d_d <= 1;
							else d_d <= d_d + 1;
						end
					endcase
				end
				else if (!up) up_f <= 1'b0;
				
				// DOWN
				if (down && !down_f) begin
					down_f <= 1'b1;
					case (blk)
						6'b110000: begin
							if (d_y == 0) d_y <= 99;
							else d_y <= d_y - 1;
						end
						6'b001100: begin
							if (d_m == 1) d_m <= 12;
							else d_m <= d_m - 1;
						end
						6'b000011: begin
							if (d_d == 1) d_d <= day_num;
							else d_d <= d_d - 1;
						end
					endcase
				end
				else if (!down) down_f <= 1'b0;
				
				out = set_out;
			end
		end
		else norm <= 1;
		
		// Convert date to plain number
		d_num = (d_y & 3) * 365;
		d_num = d_num + ((d_y & ~16'd3) >> 2) * 1461;
		case (d_m)
			2: d_num = d_num + 31;
			3: d_num = d_num + 59;
			4: d_num = d_num + 90;
			5: d_num = d_num + 120;
			6: d_num = d_num + 151;
			7: d_num = d_num + 181;
			8: d_num = d_num + 212;
			9: d_num = d_num + 243;
			10: d_num = d_num + 273;
			11: d_num = d_num + 304;
			12: d_num = d_num + 334;
		endcase
		if (!(d_y & 3) && d_m > 2) d_num = d_num + 1;
		d_num = d_num + d_d;
		
		c_num = (year & 3) * 365;
		c_num = c_num + ((year & ~16'd3) >> 2) * 1461;
		case (month)
			2: c_num = c_num + 31;
			3: c_num = c_num + 59;
			4: c_num = c_num + 90;
			5: c_num = c_num + 120;
			6: c_num = c_num + 151;
			7: c_num = c_num + 181;
			8: c_num = c_num + 212;
			9: c_num = c_num + 243;
			10: c_num = c_num + 273;
			11: c_num = c_num + 304;
			12: c_num = c_num + 334;
		endcase
		if (!(year & 3) && month > 2) c_num = c_num + 1;
		c_num = c_num + day;
		
		// Sign setting [ (+) : 1, (-) : 0 ]
		if (c_num > d_num) begin
			dif = c_num - d_num;
			sign = 1;
		end
		else begin
			dif = d_num - c_num;
			sign = 0;
		end
	end
	
	// Norm output
	digit_split5 ds_norm(.in(dif), .out4(norm_bcd[4]), .out3(norm_bcd[3]),
		.out2(norm_bcd[2]), .out1(norm_bcd[1]), .out0(norm_bcd[0]));
	bcd2seven bs_norm4(.in(norm_bcd[28:24]), .out(norm_seven[39:32]));
	bcd2seven bs_norm3(.in(norm_bcd[22:18]), .out(norm_seven[31:24]));
	bcd2seven bs_norm2(.in(norm_bcd[16:12]), .out(norm_seven[23:16]));
	bcd2seven bs_norm1(.in(norm_bcd[10:6]), .out(norm_seven[15:8]));
	bcd2seven bs_norm0(.in(norm_bcd[4:0]), .out(norm_seven[7:0]));
	
	// Setting output
	digit_split ds_y(.in(d_y), .out1(set_bcd[28:25]), .out0(set_bcd[23:20]));
	digit_split ds_m(.in(d_m), .out1(set_bcd[18:15]), .out0(set_bcd[13:10]));
	digit_split ds_d(.in(d_d), .out1(set_bcd[8:5]), .out0(set_bcd[3:0]));

	bcd2seven bs[0:5] (.in(set_bcd), .out(set_out));	

endmodule

module digit_split5 (
	input [15:0] in,
	output reg [3:0] out4,
	output reg [3:0] out3,
	output reg [3:0] out2,
	output reg [3:0] out1,
	output reg [3:0] out0
	);
	
	reg [15:0] tmp;
	integer i, j;
	
	always @(in) begin
		for (i = 0; i < 4; i = i + 1) begin
			if (tmp >= i * 10000) out4 = i;
		end
		tmp = tmp - (out4 * 10000);
		for (i = 0; i < 10; i = i + 1) begin
			if (tmp >= i * 1000) out3 = i;
		end
		tmp = tmp - (out3 * 1000);
		for (i = 0; i < 10; i = i + 1) begin
			if (tmp >= i * 100) out2 = i;
		end
		tmp = tmp - (out2 * 100);
		for (i = 0; i < 10; i = i + 1) begin
			if (tmp >= i * 10) out1 = i;
		end
		tmp = tmp - (out1 * 10);
		out0 = tmp;
	end
endmodule
