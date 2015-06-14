`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:54:34 06/14/2015
// Design Name:   stopwatch
// Module Name:   C:/Users/cse/Desktop/FinalProject/stopwatch_test.v
// Project Name:  Watch
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: stopwatch
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module stopwatch_test;

	// Inputs
	reg up;
	reg down;
	reg left;
	reg right;
	reg enter;
	reg esc;
	reg clk;
	reg mode;

	// Outputs
	wire [47:0] out;
	wire norm;

	// Instantiate the Unit Under Test (UUT)
	stopwatch uut (
		.up(up), 
		.down(down), 
		.left(left), 
		.right(right), 
		.enter(enter), 
		.esc(esc), 
		.clk(clk), 
		.mode(mode), 
		.out(out), 
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
		mode = 0;
	

		// Wait 100 ns for global reset to finish
		#100 mode = 1;
        
		// Add stimulus here
		#1000 enter = 1;
		#100 enter = 0;
		#10500000 enter = 1;
		#100 enter = 0;
		#100000 esc = 1;
		#100 esc = 0;

	end
      
	always begin
		#0.5 clk = ~clk;
	end
	
endmodule

