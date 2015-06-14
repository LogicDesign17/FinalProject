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
	output reg [47:0] out,
	output reg alm
	);


	reg [6:0] mode;
	reg [4:0] mode_bcd;
	reg up, down, left, right, enter, esc, tmp;
	reg up_mark, down_mark;
	
	wire [6:0] norm;
	wire [47:0] out_w [0:6], o_m_w;
	wire [6:0] year, month, day, hour, min, sec;
	wire carry;
	wire [0:0] alarm_w;
	
	initial begin
		$monitor("%t  norm: %b, mode_bcd: %b", $time, norm, mode_bcd);
		//$monitor("Clock: %d : %d : %d norm: %b",
		//	clock_m.hour, clock_m.min, clock_m.sec, clock_m.norm);
	end
	
	always @(negedge clk) begin
		up = ~up_i;
		down = ~down_i;
		left = ~left_i;
		right = ~right_i;
		enter = ~enter_i;
		esc = ~esc_i;
	end
	
	initial begin
		mode <= 7'b0000010;
		
	end

	always @(posedge clk) begin
		if (mode & norm) begin
			if (!down) down_mark = 0;
			if (!up) up_mark = 0;
			if (up && !up_mark) begin
				mode <= {mode[5:0], mode[6]};
				up_mark = 1;
			end
			else if (down && !down_mark) begin
				mode <= {mode[0], mode[6:1]};
				down_mark = 1;
			end
		end
		
		case (mode)
			7'b0000001: begin
				mode_bcd = 0;
				out = out_w[0];
			end
			7'b0000010: begin
				mode_bcd = 1;
				out = out_w[1];
			end
			7'b0000100: begin
				mode_bcd = 2;
				out = out_w[2];
			end
			7'b0001000: begin
				mode_bcd = 3;
				out = out_w[3];
			end
			7'b0010000: begin
				mode_bcd = 4;
				out = out_w[4];
			end
			7'b0100000: begin
				mode_bcd = 5;
				out = out_w[5];
			end
			7'b1000000: begin
				mode_bcd = 6;
				out = out_w[6];
			end
		endcase

		alm = !(!alarm_w);
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
		.alm(alarm_w[0]),
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
		.alm(alarm_w[1])
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
	
	ladder ladder_m(
		.up(up),
		.down(down),
		.left(left),
		.right(right),
		.enter(enter),
		.esc(esc),
		.clk(clk),
		.mode(mode[6]),
		
		.out(out_w[6]),
		.norm(norm[6])
		);

endmodule
