`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:38:39 06/14/2015
// Design Name:   alarm
// Module Name:   D:/team17/Watch/alarm_test.v
// Project Name:  Watch
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alarm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alarm_test;

	// Inputs
	reg up;
	reg down;
	reg left;
	reg right;
	reg enter;
	reg esc;
	reg clk;
	reg mode;
	reg [6:0] hour;
	reg [6:0] min;
	reg [6:0] sec;

	// Outputs
	wire [47:0] out;
	wire alm;
	wire norm;

	// Instantiate the Unit Under Test (UUT)
	alarm uut (
		.up(up), 
		.down(down), 
		.left(left), 
		.right(right), 
		.enter(enter), 
		.esc(esc), 
		.clk(clk), 
		.mode(mode), 
		.hour(hour), 
		.min(min), 
		.sec(sec), 
		.out(out), 
		.alm(alm), 
		.norm(norm)
	);

	initial begin
		// Initialize Inputs
		up = 0;
		down = 0;
		left = 0;
		right = 0;
		enter = 0;
		esc = 0;
		clk = 0;
		mode = 1;
		hour = 15;
		min = 39;
		sec = 45;

		#1000 enter = 1;
		#1000 enter = 0;
		#1000 up = 1;
		#1000 up = 0;
		#1000 up = 1;
		#1000 up = 0;
		#1000 esc = 1;
		#1000 esc = 0;
		#1000 up = 1;
		#1000 up = 0;
		
		#10000 hour = 2; min = 0; sec = 0;
		#500000 esc = 1; #100 esc = 0;
	end
	
	always #0.01 clk = ~clk;
      
endmodule

