`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:10:13 06/13/2015 
// Design Name: 
// Module Name:    clock 
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
module clock(
    input up,
    input down,
    input left,
    input right,
    input enter,
    input esc,
    input clk,
	input mode,
    output [47:0] out,
    output reg norm,
    output reg [6:0] hour,
    output reg [6:0] min,
    output reg [6:0] sec,
	output reg carry_out
    );

	reg up_f, down_f, left_f, right_f, enter_f, esc_f;
	reg [5:0] blink;
	reg [19:0] count;
	
	initial begin
		up_f = 0; down_f = 0;
		left_f = 0; right_f = 0;
		enter_f = 0; esc_f = 0;
		blink = 6'b000000;
		count = 0;
		hour = 0; min = 0; sec = 0;
	end

	always @(posedge clk) begin
		// Foreground
		if (mode) begin
			// At norm state
			if (norm) begin
				// ENTER
				if (enter && !enter_f) begin
					enter_f = 1'b1;
					norm = 0;
					blink = 6'b110000;
				end
				else if (!enter) enter_f = 1'b0;
			end
			// At setting
			else begin
				// ESC
				if (esc && !esc_f) begin
					esc_f = 1'b1;
					norm = 1;
					blink = 6'b000000;
				end
				else if (!esc) esc_f = 1'b0;
				
				// LEFT
				if (left && !left_f) begin
					left_f = 1'b1;
					blink[5:2] <= blink[3:0];
					blink[1:0] <= blink[5:4];
				end
				else if (!left) left_f = 1'b0;
				
				// Right
				if (right && !right_f) begin
					right_f = 1'b1;
					blink[3:0] <= blink[5:2];
					blink[5:4] <= blink[1:0];
				end
				else if (!right) right_f = 1'b0;
				
				// UP
				if (up && !up_f) begin
					up_f = 1'b1;
					case (blink)
						6'b110000: begin
							if (hour == 23) hour = 0;
							else hour = hour + 1;
						end
						6'b001100: begin
							if (min == 59) min = 0;
							else min = min + 1;
						end
						6'b000011: begin
							if (sec == 59) sec = 0;
							else sec = sec + 1;
						end
					endcase
				end
				else if (!up) up_f = 1'b0;
				
				// DOWN
				if (down && !down_f) begin
					down_f = 1'b1;
					case (blink)
						6'b110000: begin
							if (hour == 0) hour = 23;
							else hour = hour - 1;
						end
						6'b001100: begin
							if (min == 0) min = 59;
							else min = min - 1;
						end
						6'b000011: begin
							if (sec == 0) sec = 59;
							else sec = sec - 1;
						end
					endcase
				end
				else if (!down) down_f = 1'b0;
				
			end
		end
		
		// Background
		if (norm) begin
			if (count == 999999) begin
				count = 0;
				if (sec == 59) begin
					sec = 0;
					if (min == 59) begin
						min = 0;
						if (hour == 23) begin
							hour = 0;
							carry_out = 1'b1;
						end
						else begin
							hour = hour + 1;
							carry_out = 1'b0;
						end
					end
					else min = min + 1;
				end
				else sec = sec + 1;
			end
			else count = count + 1;
		end
	end

endmodule
