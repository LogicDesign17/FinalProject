`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:20:05 06/13/2015 
// Design Name: 
// Module Name:    stopwatch 
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
module stopwatch(
	input up,
	input down,
	input left,
	input right,
	input enter,
	input esc,
	input clk,
	input mode,
	output [47:0] out,
	output norm
	);

	// Base registers
	reg enter_mark, esc_mark, norm_r;
	reg [7:0] out_a [0:5];
	wire [7:0] out_a_w [0:5];
	assign out_a_w[0] = out_a[0];
	assign out_a_w[1] = out_a[1];
	assign out_a_w[2] = out_a[2];
	assign out_a_w[3] = out_a[3];
	assign out_a_w[4] = out_a[4];
	assign out_a_w[5] = out_a[5];
	
	// Stopwatch registers
	reg [13:0] sw_count;
	reg [6:0] sw_min, sw_sec1, sw_sec0;
	reg sw_pause;
	reg [4:0] sw_out [0:5];
	wire [3:0] sw_out_w [0:5];
	assign sw_out_w[0][0] = sw_out[0][0];
	/*
	assign sw_out_w[0] = sw_out[0];
	assign sw_out_w[1] = sw_out[1];
	assign sw_out_w[2] = sw_out[2];
	assign sw_out_w[3] = sw_out[3];
	assign sw_out_w[4] = sw_out[4];
	assign sw_out_w[5] = sw_out[5];*/
	assign norm = norm_r;
	
	// initialize
	initial begin
		sw_pause = 1;
		sw_min = 0;
		sw_sec0 = 0;
		sw_sec1 = 0;
		norm_r = 1;
		enter_mark = 0;
		esc_mark = 0;
		norm_r = 1;
		sw_out[0][4] = 0;
		sw_out[1][4] = 0;
		sw_out[2][4] = 0;
		sw_out[3][4] = 0;
		sw_out[4][4] = 0;
		sw_out[5][4] = 0;
	end
	
	// mark
	always @(negedge clk) begin
		if(enter & !enter_mark) begin
			enter_mark = 1;
		end
		else if(!enter) enter_mark = 0;
		if(esc & !esc_mark) begin
			esc_mark = 1;
		end
		else if(!esc) esc_mark = 0;
	end
	
	// Stopwatch
	always @(posedge clk) begin
		if(mode) begin
			//start | stop
			if(enter & !enter_mark) begin
				sw_pause = ~sw_pause;
			end
			// reset
			else if(esc & !esc_mark) begin
				sw_pause = 1;
				sw_min = 0;
				sw_sec1 = 0;
				sw_sec0 = 0;
				sw_count = 0;
			end
			if(sw_pause == 0) begin
				sw_count = sw_count + 1;
				if(sw_count == 10000) begin
					sw_sec0 = sw_sec0 + 1;
					sw_count = 0;
					if(sw_sec0 == 100) begin
						sw_sec1 = sw_sec1 + 1;
						sw_sec0 = 0;
						if(sw_sec1 == 100) begin
							sw_min = sw_min + 1;
							sw_sec1 = 0;
							if(sw_min ==100) sw_min = 0;
						end
					end
				end
			end
		end
		else begin
			sw_pause = 1;
			sw_min = 0;
			sw_sec0 = 0;
			sw_sec1 = 0;
			sw_count = 0;
		end
	end
	
	digit_split sw_min_split(.in(sw_min), .out1(sw_out_w[5]), .out0(sw_out_w[4]));
	digit_split sw_sec1_split(.in(sw_sec1), .out1(sw_out_w[3]), .out0(sw_out_w[2]));
	digit_split sw_sec0_split(.in(sw_sec0), .out1(sw_out_w[1]), .out0(sw_out_w[0]));
/*
	bcd2seven sw_out_m0 (.in(sw_out[0]),.out(out_a_w[0]));
	bcd2seven sw_out_m1 (.in(sw_out[1]),.out(out_a_w[1]));
	bcd2seven sw_out_m2 (.in(sw_out[2]),.out(out_a_w[2]));
	bcd2seven sw_out_m3 (.in(sw_out[3]),.out(out_a_w[3]));
	bcd2seven sw_out_m4 (.in(sw_out[4]),.out(out_a_w[4]));
	bcd2seven sw_out_m5 (.in(sw_out[5]),.out(out_a_w[5]));*/
	
	assign out[0] = sw_out[0][0];
	assign out[7:1] = 0;
	assign out[15:8] = out_a[1];
	assign out[16] = out_a[2][0];
	assign out[17] = out_a[2][1];
	assign out[18] = out_a[2][2];
	assign out[19] = out_a[2][3];
	assign out[20] = out_a[2][4];
	assign out[21] = out_a[2][5];
	assign out[22] = out_a[2][6];
	assign out[23] = 1;
	assign out[31:24] = out_a[3];
	assign out[32] = out_a[4][0];
	assign out[33] = out_a[4][1];
	assign out[34] = out_a[4][2];
	assign out[35] = out_a[4][3];
	assign out[36] = out_a[4][4];
	assign out[37] = out_a[4][5];
	assign out[38] = out_a[4][6];
	assign out[39] = 1;
	assign out[47:40] = out_a[5];

endmodule
