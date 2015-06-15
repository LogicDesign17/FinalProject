`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:14:15 06/14/2015 
// Design Name: 
// Module Name:    day_of_month 
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
module day_of_month(
	input [6:0] year,
	input [6:0] month,
	input clk,
	output reg [4:0] out
	);
	
	
	always @(posedge clk) begin
		case(month)
			1, 3, 5, 7, 8, 10, 12: out = 31;
			4, 6, 9, 11: out = 30;
			2: begin
				if(year & 3 == 0) out = 29;
				else out = 28;
			end
		endcase
	end
endmodule
