`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:15:07 06/14/2015 
// Design Name: 
// Module Name:    bcd2seven 
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
module bcd2seven(
	input [3:0] in,
	output [7:0] out
	);

	assign out[7] = in[4];
	assign out[6] = in[3] | ~(in[0]^in[2]) | (in[1] & ~in[2]);
	assign out[5] = ~in[2] | ~(in[1]^in[0]);
	assign out[4] = in[2] | (~in[1]) | in[0];
	assign out[3] = ~in[2] & ~in[0] | (in[2]^in[0])^~in[1] | (in[2]^in[0]) & in[1];
	assign out[2] = (~in[2] | in[1]) & ~in[0];
	assign out[1] = in[3] | (in[2] & ~in[0]) | ~(in[0] | in[1]) | (~in[1] & in[2]);
	assign out[0] = in[3] | (in[2]^in[1]) | in[1] & ~in[0];

endmodule
