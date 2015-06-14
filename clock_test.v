`timescale 1us / 500ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:05:53 06/14/2015
// Design Name:   clock
// Module Name:   D:/team17/Watch/clock_test.v
// Project Name:  Watch
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clock_test;

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
	wire [6:0] hour;
	wire [6:0] min;
	wire [6:0] sec;
	wire carry_out;

	// Instantiate the Unit Under Test (UUT)
	clock uut (
		.up(up), 
		.down(down), 
		.left(left), 
		.right(right), 
		.enter(enter), 
		.esc(esc), 
		.clk(clk), 
		.mode(mode), 
		.out(out), 
		.norm(norm), 
		.hour(hour), 
		.min(min), 
		.sec(sec), 
		.carry_out(carry_out)
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
		#10000 enter = 1;
		#100 enter = 0;
		#1000 up = 1;
		#100 up = 0;
		#1000 up = 1;
		#100 up = 0;
		#1000 up = 1;
		#100 up = 0;
		#1000 left = 1;
		#100 left = 0;
		#1000 up = 1;
		#100 up = 0;
		#1000 up = 1;
		#100 up = 0;
		#1000 down = 1;
		#100 down = 0;
 		#1000 left = 1;
		#100 left = 0;
		#1000 down = 1;
		#100 down = 0;
		#1000 down = 1;
		#100 down = 0;
		#1000 up = 1;
		#100 up = 0;
       
		// Add stimulus here
		

	end
	
	always begin
		#0.5 clk = ~clk;
	end
      
endmodule

