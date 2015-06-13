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
    output [6:0] year,
    output [6:0] month,
    output [6:0] day
    );

	reg up_f, down_f, left_f, right_f, enter_f, esc_f;
	initial begin
		up_f = 0; down_f = 0;
		left_f = 0; right_f = 0;
		enter_f = 0; esc_f = 0;
	end
	
	always @(posedge clk) if (mode) begin
		//if (up
	end

endmodule
