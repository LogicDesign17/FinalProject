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
	year,
	month,
	num
	);
	
	input year,month;
	output num;
	reg [4:0] num;
	
	always @(year or month) begin
		case(month)
			1, 3, 5, 7, 8, 10, 12: num = 31;
			4, 6, 9, 11: num = 30;
			2: begin
				if(year & 3 == 0) num = 29;
				else num = 28;
			end
		endcase
	end
endmodule
