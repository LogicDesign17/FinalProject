`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:42:38 06/01/2015 
// Design Name: 
// Module Name:    watch 
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
module watch(
	input up_i,
	input down_i,
	input left_i,
	input right_i,
	input enter_i,
	input esc_i,
	input clk,
	output reg [7:0] o_m,
	output reg [47:0] out,
	output reg alarm
	);
	
	reg [6:0] mode;
	reg up, down, left, right, enter, esc, tmp;
	reg up_mark, down_mark;
	
	wire [6:0] norm;
	wire [47:0] out_w [0:6], o_m_w;
	wire [6:0] year, month, day, hour, min, sec;
	wire carry;
	wire [6:0] alarm_w;
	
	always @(negedge clk) begin
		up = ~up_i;
		down = ~down_i;
		left = ~left_i;
		right = ~right_i;
		enter = ~enter_i;
		esc = ~esc_i;
	end
	
	initial begin
		mode <= 6'b100000;
	end
	
<<<<<<< HEAD
=======
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
	end
>>>>>>> origin/master
	
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
		.alarm(alarm_w[2]),
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
		.alarm(alarm_w[4])
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
