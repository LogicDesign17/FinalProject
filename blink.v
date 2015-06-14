`timescale 1ns / 1ps
module blink(
	input on,
	input val,
	input clk,
	output reg out
	);

	reg [18:0] count;

	initial begin
		out = 0;
		count = 0;
	end
	
	always @(posedge clk) begin
		if (on & val) begin
			count = count + 1;
			if (count == 500) begin
				count = 0;
				out = ~out;
			end
		end
		else begin
			out = val;
		end
	end

endmodule
