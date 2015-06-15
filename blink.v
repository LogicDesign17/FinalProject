`timescale 1ns / 1ps
module blink(
	input [5:0] on,
	input [47:0] val,
	input clk,
	input reset,
	output reg [47:0] out
	);

	reg [17:0] count;
	reg [7:0] blk;
	
	initial begin
		out = 0;
		count = 0;
		blk = 0;
	end
	
	always @(posedge clk) begin
		if (reset) begin
			count = 0;
			blk = 0;
			out = 0;
		end
		if (on & val) begin
			count = count + 1;
			if (count == 250000) begin
				count = 0;
				blk = ~blk;
			end
		end
		else begin
			out = val;
		end
		if (on[5]) out[47:40] = blk & val[47:40];
		else out[47:40] = val[47:40];
		if (on[4]) out[39:32] = blk & val[39:32];
		else out[39:32] = val[39:32];
		if (on[3]) out[31:24] = blk & val[31:24];
		else out[31:24] = val[31:24];
		if (on[2]) out[23:16] = blk & val[23:16];
		else out[23:16] = val[23:16];
		if (on[1]) out[15:8] = blk & val[15:8];
		else out[15:8] = val[15:8];
		if (on[0]) out[7:0] = blk & val[7:0];
		else out[7:0] = val[7:0];
	end
endmodule
