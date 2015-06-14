`timescale 1ns / 1ps
module watch(
	input up_i,
	input down_i,
	input left_i,
	input right_i,
	input enter_i,
	input esc_i,
	input clk,
	output [7:0] out_m,
	output [47:0] out,
	output reg alm
	);


	reg [5:0] mode;
	reg [4:0] mode_bcd;
	reg up, down, left, right, enter, esc, tmp;
	reg up_mark, down_mark;
	
	wire [5:0] norm;
	wire [47:0] out_w [0:6];
	wire [6:0] year, month, day, hour, min, sec;
	wire carry;
	wire [1:0] alm_w;
	wire [5:0] blk[5:0];
	
	reg [5:0] blk_on;
	reg [47:0] blk_val;
	initial begin
	//	$monitor("%t  norm: %b, mode_bcd: %b", $time, norm, mode_bcd);
	end
	
	blink blinker(.on(blk_on), .val(blk_val), .out(out));
	
	always @(negedge clk) begin
		up = ~up_i;
		down = ~down_i;
		left = ~left_i;
		right = ~right_i;
		enter = ~enter_i;
		esc = ~esc_i;
	end
	
	initial begin
		mode <= 6'b000010;
	end

	always @(posedge clk) begin
		if (mode & norm) begin
			if (!down) down_mark = 0;
			if (!up) up_mark = 0;
			if (up && !up_mark) begin
				mode <= {mode[4:0], mode[5]};
				up_mark = 1;
			end
			else if (down && !down_mark) begin
				mode <= {mode[0], mode[5:1]};
				down_mark = 1;
			end
		end
		
		case (mode)
			6'b000001: begin
				mode_bcd = 0;
				blk_val = out_w[0];
				blk_on = blk[0];
			end
			6'b000010: begin
				mode_bcd = 1;
				blk_val = out_w[1];
				blk_on = blk[0];
			end
			6'b000100: begin
				mode_bcd = 2;
				blk_val = out_w[2];
				blk_on = blk[0];
			end
			6'b001000: begin
				mode_bcd = 3;
				blk_val = out_w[3];
				blk_on = blk[0];
			end
			6'b010000: begin
				mode_bcd = 4;
				blk_val = out_w[4];
				blk_on = blk[0];
			end
			6'b100000: begin
				mode_bcd = 5;
				blk_val = out_w[5];
				blk_on = blk[0];
			end
		endcase

		if (alm_w) alm = 1;
		else alm = 0;
	end
	
	bcd2seven bs_mode(.in(mode_bcd), .out(out_m));
	
	date date_m(
		.up(up),
		.down(down),
		.left(left),
		.right(right),
		.enter(enter),
		.esc(esc),
		.clk(clk),
		.mode(mode[0]),
		.carry_in(carry),
		
		.out(out_w[0]),
		.blk(blk[0]),
		.norm(norm[0]),
		.year(year),
		.month(month),
		.day(day)
		);

	clock clock_m(
		.up(up),
		.down(down),
		.left(left),
		.right(right),
		.enter(enter),
		.esc(esc),
		.clk(clk),
		.mode(mode[1]),
		
		.out(out_w[1]),
		.blk(blk[1]),
		.norm(norm[1]),
		.hour(hour),
		.min(min),
		.sec(sec),
		.carry_out(carry)
		);

	alarm alarm_m(
		.up(up),
		.down(down),
		.left(left),
		.right(right),
		.enter(enter),
		.esc(esc),
		.clk(clk),
		.mode(mode[2]),
		
		.out(out_w[2]),
		.blk(blk[2]),
		.alm(alm_w[0]),
		.norm(norm[2]),
		.hour(hour),
		.min(min),
		.sec(sec)
		);
	
	stopwatch stopwatch_m(
		.up(up),
		.down(down),
		.left(left),
		.right(right),
		.enter(enter),
		.esc(esc),
		.clk(clk),
		.mode(mode[3]),
		
		.out(out_w[3]),
		.blk(blk[3]),
		.norm(norm[3])
		);

	timer timer_m(
		.up(up),
		.down(down),
		.left(left),
		.right(right),
		.enter(enter),
		.esc(esc),
		.clk(clk),
		.mode(mode[4]),
		
		.out(out_w[4]),
		.norm(norm[4]),
		.alm(alm_w[1])
		);

	d_day d_day_m(
		.up(up),
		.down(down),
		.left(left),
		.right(right),
		.enter(enter),
		.esc(esc),
		.year(year),
		.month(month),
		.day(day),
		.clk(clk),
		.mode(mode[5]),
		
		.out(out_w[5]),
		.norm(norm[5])
		);

endmodule
