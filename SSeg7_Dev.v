`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    12:16:23 03/17/2018
// Design Name:
// Module Name:    SSeg7_Dev
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
module SSeg7_Dev(
	input clk,
	input rst,
	input Start,
	input Mode,
	input flash,
	input [31:0] Hexs,
	input [7:0] point,
	input [7:0] LES,
	output seg_clk,
	output seg_sout,
	output SEG_PEN,
	output seg_clrn
	);

	wire [63:0] SEGMENT;
	wire [63:0] a;
	wire [63:0] b;

	P2S M1(
		.clk(clk),
		.rst(rst),
		.Serial(Start),
		.P_Data(SEGMENT),
		.s_clk(seg_clk),
		.sout(seg_sout),
		.EN(SEG_PEN),
		.s_clrn(seg_clrn)
		);

	HexTo8SEG M2(.flash(flash), .Hexs(Hexs), .point(point), .LES(LES), .SEG_TXT(a));

	SSeg_Map M3(.Disp_num({Hexs[31:0], Hexs[31:0]}), .Seg_map(b));

	assign SEGMENT = Mode ? a : b;

endmodule
