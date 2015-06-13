`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:16:52 06/14/2015 
// Design Name: 
// Module Name:    digit_split 
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
module digit_split(
	input [6:0] in,
	output [3:0] out1, out0
	);
	
	reg [3:0] d1, d0;
	assign out1 = d1, out0 = d0;
	
	always @(in) begin
		if (in >= 90) begin d1 = 9; d0 = in - 90; end
		else if (in >= 80) begin d1 = 8; d0 = in - 80; end
		else if (in >= 70) begin d1 = 7; d0 = in - 70; end
		else if (in >= 60) begin d1 = 6; d0 = in - 60; end
		else if (in >= 50) begin d1 = 5; d0 = in - 50; end
		else if (in >= 40) begin d1 = 4; d0 = in - 40; end
		else if (in >= 30) begin d1 = 3; d0 = in - 30; end
		else if (in >= 20) begin d1 = 2; d0 = in - 20; end
		else if (in >= 10) begin d1 = 1; d0 = in - 10; end
		else begin d1 = 0; d0 = in; end
	end
endmodule
