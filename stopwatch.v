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
	
	// Stopwatch registers
	reg [4:0] sw_out [0:5];
	reg [13:0] sw_count;
	reg [6:0] sw_min, sw_sec1, sw_sec0;
	reg sw_pause;
	wire [3:0] sw_out_w [0:5];
	
	integer I;
	
	always @(posedge clk) begin
		for(I=0;I<6;I=I+1) begin
			sw_out[I] = sw_out_w[I];
		end
	end
	
	assign norm = norm_r;
	
	// initialize
	initial begin
		sw_out[4][4] = 1;
		sw_out[4][2] = 1;
		sw_pause = 1;
		sw_min = 0;
		sw_sec0 = 0;
		sw_sec1 = 0;
		norm_r = 1;
		enter_mark = 0;
		esc_mark = 0;
		norm_r = 1;
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
			enter_mark = 0;
			esc_mark = 0;
		end
	end
	
	digit_split sw_min_split(.in(sw_min), .out1(sw_out_w[5]), .out0(sw_out_w[4]));
	digit_split sw_sec1_split(.in(sw_sec1), .out1(sw_out_w[3]), .out0(sw_out_w[2]));
	digit_split sw_sec0_split(.in(sw_sec0), .out1(sw_out_w[1]), .out0(sw_out_w[0]));

	bcd2seven sw_out_m [5:0] (.in(sw_out),.out(out_a));
	
	assign out[7:0] = out_a[0];
	assign out[15:8] = out_a[1];
	assign out[23:16] = out_a[2];
	assign out[31:24] = out_a[3];
	assign out[39:32] = out_a[4];
	assign out[47:40] = out_a[5];
	
endmodule
