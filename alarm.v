`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:43:54 06/14/2015 
// Design Name: 
// Module Name:    alarm 
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
module alarm(
    input up,
    input down,
    input left,
    input right,
    input enter,
    input esc,
    input clk,
	input mode,
    input [6:0] hour,
    input [6:0] min,
    input [6:0] sec,
    output [47:0] out,
	output alarm,
    output reg norm
    );


endmodule
