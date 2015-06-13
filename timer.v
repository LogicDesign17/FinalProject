`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:18:34 06/14/2015 
// Design Name: 
// Module Name:    timer 
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
module timer(
	input up,
	input down,
	input left,
	input right,
	input enter,
	input esc,
	input clk,
	input mode,
	output [47:0] out,
	output norm,
	output alarm
	);
	
	// Base registers
	reg up_mark, down_mark, left_mark, right_mark, enter_mark, esc_mark, norm_r;
	reg [7:0] out_a [0:5];
	
	// Timer registers
	reg [4:0] tm_out [0:5];
	reg [19:0] tm_count;
	reg [6:0] tm_hour, tm_min, tm_sec;
	reg [1:0] tm_setting;
	reg tm_flow;
	wire [3:0] tm_out_w [0:5];
	reg [5:0] blink_on;
	reg [7:0] blink_out [0:5];
	
	integer I;
	
	always @(posedge clk) begin
		for(I=0;I<6;I=I+1) begin
			tm_out[I] = tm_out_w[I];
		end
	end
	
	assign norm = norm_r;
	
	// initialize
	initial begin
		blink_out[2][7] = 1;
		blink_out[4][7] = 1;
		tm_count = 0;
		tm_hour = 0;
		tm_min = 0;
		tm_sec = 0;
		tm_setting = 0;
		tm_flow = 0;
		up_mark = 0;
		down_mark = 0;
		left_mark = 0;
		right_mark = 0;
		enter_mark = 0;
		esc_mark = 0;
		norm_r = 1;
	end
	
	// mark
	always @(posedge clk) begin
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
	
	// Blink
	always @(posedge clk) begin
		if (tm_setting == 1) blink_on <= 6'b000011;
		else if (tm_setting == 2) blink_on <= 6'b001100;
		else if (tm_setting == 3) blink_on <= 6'b110000;
	end
	
	blink tm_blink0 [7:0] (.on(blink_on[0]),.val(out_a[0]),.clk(clk),.out(blink_out[0]));
	blink tm_blink1 [7:0] (.on(blink_on[1]),.val(out_a[1]),.clk(clk),.out(blink_out[1]));
	blink tm_blink2 [6:0] (.on(blink_on[2]),.val(out_a[2]),.clk(clk),.out(blink_out[2]));
	blink tm_blink3 [7:0] (.on(blink_on[3]),.val(out_a[3]),.clk(clk),.out(blink_out[3]));
	blink tm_blink4 [6:0] (.on(blink_on[4]),.val(out_a[4]),.clk(clk),.out(blink_out[4]));
	blink tm_blink5 [7:0] (.on(blink_on[5]),.val(out_a[5]),.clk(clk),.out(blink_out[5]));
	
	// Mode control (norm) Ãß°¡
	always @(posedge clk) begin
		if (tm_setting) norm_r = 0;
		else norm_r = 1;
	end
	
	// Timer
	always @(posedge clk) begin
		if(mode) begin
			// Reset
			if(esc) begin
				tm_count = 0;
				tm_hour = 0;
				tm_min = 0;
				tm_sec = 0;
				tm_setting = 0;
				tm_flow = 0;
			end
			
			// Timer
			else if(tm_flow) begin
				tm_setting = 0;
				if(enter & !enter_mark) tm_flow = 0;
				else begin
					tm_count = tm_count + 1;
					if(tm_count == 1000000) begin
						tm_count = 0;
						tm_sec = tm_sec - 1;
						if(tm_sec == 127) begin
							if(tm_hour || tm_min) begin
								tm_min = tm_min - 1;
								tm_sec = 59;
								if(tm_min == 127) begin
									tm_hour = tm_hour - 1;
									tm_min = 59;
								end
							end
							else begin
								tm_flow = 0;
								tm_sec = 0;
							end
						end
					end
				end
			end
			
			// Setting
			else if (tm_setting) begin
				if (enter && !enter_mark) tm_setting = 0;
				else if (tm_setting == 1) begin
					if(left & !left_mark) tm_setting = 2;
					else if (right & !right_mark) tm_setting = 3;
					else if (up & !up_mark) begin
						tm_sec = tm_sec + 1;
						if (tm_sec == 60) tm_sec = 0;
					end
					else if (down & !down_mark) begin
						tm_sec = tm_sec - 1;
						if (tm_sec == 127) tm_sec = 59;
					end
				end
				else if (tm_setting == 2) begin
					if (left & !left_mark) tm_setting = 3;
					else if (right & !right_mark) tm_setting = 1;
					else if (up & !up_mark) begin
						tm_min = tm_min + 1;
						if (tm_min == 60) tm_min = 0;
					end
					else if (down & !down_mark) begin
						tm_min = tm_min - 1;
						if (tm_min == 127) tm_min = 59;
					end
				end
				else if (tm_setting == 3) begin
					if (left & !left_mark) tm_setting = 1;
					else if (right & !right_mark) tm_setting = 2;
					else if (up & !up_mark) begin
						tm_hour = tm_hour + 1;
						if (tm_hour == 100) tm_hour = 0;
					end
					else if (down & !down_mark) begin
						tm_hour = tm_hour - 1;
						if (tm_hour == 127) tm_hour = 99;
					end
				end
			end
			
			// Button
			else if(right) tm_flow = 1;
			else if(enter & !enter_mark) tm_setting = 1;
		end
		else begin
			tm_count = 0;
			tm_hour = 0;
			tm_min = 0;
			tm_sec = 0;
			tm_setting = 0;
			tm_flow = 0;
		end
	end
	
	digit_split tm_hour_split(.in(tm_hour), .out1(tm_out_w[5]), .out0(tm_out_w[4]));
	digit_split tm_min_split(.in(tm_min), .out1(tm_out_w[3]), .out0(tm_out_w[2]));
	digit_split tm_sec_split(.in(tm_sec), .out1(tm_out_w[1]), .out0(tm_out_w[0]));
	
	bcd2seven tm_out_m [5:0] (.in(tm_out),.out(out_a));
	
	assign out[7:0] = blink_out[0];
	assign out[15:8] = blink_out[1];
	assign out[23:16] = blink_out[2];
	assign out[31:24] = blink_out[3];
	assign out[39:32] = blink_out[4];
	assign out[47:40] = blink_out[5];	

endmodule
