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
	output [7:0] out [0:5],
	output norm
    );

	// Input registers
	reg up_mark, down_mark, left_mark, right_mark, enter_mark, esc_mark, norm_r;
	
	// Stopwatch registers
	reg [3:0] sw_out [0:5];
	reg [13:0] sw_count;
	reg [6:0] sw_min, sw_sec1, sw_sec0;
	reg sw_pause;
	wire [3:0] sw_out_w [0:5];
	assign sw_out_w = sw_out, norm = norm_r;
	
	// initialize
	initial begin
		sw_pause = 1;
		sw_min = 0;
		sw_sec0 = 0;
		sw_sec1 = 0;
		norm = 1;
		up_mark = 0;
		down_mark = 0;
		left_mark = 0;
		right_mark = 0;
		enter_mark = 0;
		esc_mark = 0;
		norm_r = 1;
	end
	
	// Mark control
	always @(negedge clk) begin
		if(up & !up_mark) begin
			up_mark = 1;
		end
		else if(!up) up_mark = 0;
		if(down & !down_mark) begin
			down_mark = 1;
		end
		else if(!down) down_mark = 0;
		if(left & !left_mark) begin
			left_mark = 1;
		end
		else if(!left) left_mark = 0;
		if(right & !right_mark) begin
			right_mark = 1;
		end
		else if(!right) right_mark = 0;
		if(enter & !enter_mark) begin
			enter_mark = 1;
		end
		else if(!enter) enter_mark = 0;
		if(esc & !esc_mark) begin
			esc_mark = 1;
		end
		else if(!esc) esc_mark = 0;
	end
	
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
			norm = 1;
			up_mark = 0;
			down_mark = 0;
			left_mark = 0;
			right_mark = 0;
			enter_mark = 0;
			esc_mark = 0;
		end
	end
	
	digit_split sw_min_split(.in(sw_min), .out1(sw_out_w[5]), .out0(sw_out_w[4]));
	digit_split sw_sec1_split(.in(sw_sec1), .out1(sw_out_w[3]), .out0(sw_out_w[2]));
	digit_split sw_sec0_split(.in(sw_sec0), .out1(sw_out_w[1]), .out0(sw_out_w[0]));

	bcd2seven sw_out_m [5:0] (.in(sw_out),.out(out));

endmodule
