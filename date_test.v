`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:35:54 06/15/2015
// Design Name:   date
// Module Name:   D:/team17/Watch/date_test.v
// Project Name:  Watch
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: date
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module date_test;

	// Inputs
	reg up;
	reg down;
	reg left;
	reg right;
	reg enter;
	reg esc;
	reg clk;
	reg mode;
	reg carry_in;
	reg reset;

	// Outputs
	wire [47:0] out;
	wire [5:0] blk;
	wire norm;
	wire [6:0] year;
	wire [6:0] month;
	wire [6:0] day;

	// Instantiate the Unit Under Test (UUT)
	date uut (
		.up(up), 
		.down(down), 
		.left(left), 
		.right(right), 
		.enter(enter), 
		.esc(esc), 
		.clk(clk), 
		.mode(mode), 
		.carry_in(carry_in), 
		.reset(reset), 
		.out(out), 
		.blk(blk), 
		.norm(norm), 
		.year(year), 
		.month(month), 
		.day(day)
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
		carry_in = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        reset = 1; #100 reset = 0;
		// Add stimulus here

	end
      
	  always #0.5 clk = ~clk;
endmodule

