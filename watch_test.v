`timescale 1ns / 1ps
module watch_test;

	// Inputs
	reg up_i;
	reg down_i;
	reg left_i;
	reg right_i;
	reg enter_i;
	reg esc_i;
	reg clk;
	reg reset;

	// Outputs
	wire [7:0] out_m;
	wire [47:0] out;
	wire alm;

	// Instantiate the Unit Under Test (UUT)
	watch uut (
		.up_i(up_i), 
		.down_i(down_i), 
		.left_i(left_i), 
		.right_i(right_i), 
		.enter_i(enter_i), 
		.esc_i(esc_i), 
		.clk(clk), 
		.out_m(out_m), 
		.out(out), 
		.alm(alm),
		.reset(reset)
	);
	
	initial begin
		// Initialize Inputs
		up_i = 1;
		down_i = 1;
		left_i = 1;
		right_i = 1;
		enter_i = 1;
		esc_i = 1;
		clk = 1;
		reset = 0;

		// #1000 == 1 sec
		// Clock test
		#1000 reset = 1; #200 reset = 0;
		#1000 enter_i = 0; #200 enter_i = 1;
		#200 up_i = 0; #200 up_i = 1;
		#2000
		#200 right_i = 0; #200 right_i = 1;
		#200 up_i = 0; #200 up_i = 1;
		#200 up_i = 0; #200 up_i = 1;
		#2000;
		#200 right_i = 0; #200 right_i = 1;
		#200 up_i = 0; #200 up_i = 1;
		#200 up_i = 0; #200 up_i = 1;
		#200 up_i = 0; #200 up_i = 1;
		#2000
		#200 esc_i = 0; #200 esc_i = 1;
		
		// Alarm test
		#200 up_i = 0; #200 up_i = 1;
		#200 enter_i = 0; #200 enter_i = 1;
		#200 up_i = 0; #200 up_i = 1;
		#200 right_i = 0; #200 right_i = 1;
		#200 up_i = 0; #200 up_i = 1;
		#200 up_i = 0; #200 up_i = 1;
		#200 up_i = 0; #200 up_i = 1;
		#2000 esc_i = 0; #200 esc_i = 1;
		#2000 right_i = 0; #200 right_i = 1;
		//#90000 esc_i = 0; #200 esc_i = 1; // stop alarm
		#10000 down_i = 0; #200 down_i = 1;
		#50000 reset = 1; #200 reset = 0;
	end
	
	always #0.5 clk = ~clk;
      
endmodule

