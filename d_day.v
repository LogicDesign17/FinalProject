`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:44:09 06/14/2015 
// Design Name: 
// Module Name:    d_day 
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
module d_day(
    input up,
    input down,
    input left,
    input right,
    input enter,
    input esc,
    input clk,
	input mode,
    input [6:0] year,
    input [6:0] month,
    input [6:0] day,
    output [47:0] out,
	output alarm,
    output reg norm
    );


endmodule
