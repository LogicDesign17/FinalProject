`timescale 1ns / 1ps
module blink(
	input [5:0] on,
	input [47:0] val,
	input clk,
	output [47:0] out
	);

	reg blk;
	
	initial begin
		blk = 0;
	end
	
	always @(clk) begin
		blk = ~blk;
	end
	
	assign out[47] = (blk | ~on[5]) & val[47];
	assign out[46] = (blk | ~on[5]) & val[46];
	assign out[45] = (blk | ~on[5]) & val[45];
	assign out[44] = (blk | ~on[5]) & val[44];
	assign out[43] = (blk | ~on[5]) & val[43];
	assign out[42] = (blk | ~on[5]) & val[42];
	assign out[41] = (blk | ~on[5]) & val[41];
	assign out[40] = (blk | ~on[5]) & val[40];
	assign out[39] = (blk | ~on[4]) & val[39];
	assign out[38] = (blk | ~on[4]) & val[38];
	assign out[37] = (blk | ~on[4]) & val[37];
	assign out[36] = (blk | ~on[4]) & val[36];
	assign out[35] = (blk | ~on[4]) & val[35];
	assign out[34] = (blk | ~on[4]) & val[34];
	assign out[33] = (blk | ~on[4]) & val[33];
	assign out[32] = (blk | ~on[4]) & val[32];
	assign out[31] = (blk | ~on[3]) & val[31];
	assign out[30] = (blk | ~on[3]) & val[30];
	assign out[29] = (blk | ~on[3]) & val[29];
	assign out[28] = (blk | ~on[3]) & val[28];
	assign out[27] = (blk | ~on[3]) & val[27];
	assign out[26] = (blk | ~on[3]) & val[26];
	assign out[25] = (blk | ~on[3]) & val[25];
	assign out[24] = (blk | ~on[3]) & val[24];
	assign out[23] = (blk | ~on[2]) & val[23];
	assign out[22] = (blk | ~on[2]) & val[22];
	assign out[21] = (blk | ~on[2]) & val[21];
	assign out[20] = (blk | ~on[2]) & val[20];
	assign out[19] = (blk | ~on[2]) & val[19];
	assign out[18] = (blk | ~on[2]) & val[18];
	assign out[17] = (blk | ~on[2]) & val[17];
	assign out[16] = (blk | ~on[2]) & val[16];
	assign out[15] = (blk | ~on[1]) & val[15];
	assign out[14] = (blk | ~on[1]) & val[14];
	assign out[13] = (blk | ~on[1]) & val[13];
	assign out[12] = (blk | ~on[1]) & val[12];
	assign out[11] = (blk | ~on[1]) & val[11];
	assign out[10] = (blk | ~on[1]) & val[10];
	assign out[9] = (blk | ~on[1]) & val[9];
	assign out[8] = (blk | ~on[1]) & val[8];
	assign out[7] = (blk | ~on[1]) & val[7];
	assign out[6] = (blk | ~on[0]) & val[6];
	assign out[5] = (blk | ~on[0]) & val[5];
	assign out[4] = (blk | ~on[0]) & val[4];
	assign out[3] = (blk | ~on[0]) & val[3];
	assign out[2] = (blk | ~on[0]) & val[2];
	assign out[1] = (blk | ~on[0]) & val[1];
	assign out[0] = (blk | ~on[0]) & val[0];

endmodule
