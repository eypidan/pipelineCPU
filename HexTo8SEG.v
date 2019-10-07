`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:31:11 03/17/2018 
// Design Name: 
// Module Name:    HexTo8SEG 
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
module HexTo8SEG(
	input flash,
	input [31:0] Hexs,
	input [7:0] point,
	input [7:0] LES,
	output [63:0] SEG_TXT
	);
	
	wire [7:0] LEs;
	assign LEs[0] = LES[0] & flash;
	assign LEs[1] = LES[1] & flash;
	assign LEs[2] = LES[2] & flash;
	assign LEs[3] = LES[3] & flash;
	assign LEs[4] = LES[4] & flash;
	assign LEs[5] = LES[5] & flash;
	assign LEs[6] = LES[6] & flash;
	assign LEs[7] = LES[7] & flash;
	
	MC14495_ZJU M7 (
		.D0(Hexs[0]),
		.D1(Hexs[1]),
		.D2(Hexs[2]),
		.D3(Hexs[3]), 
		.LE(LEs[0]), 
		.point(point[0]), 
		.SEG_TXT(SEG_TXT[63:56])
		);
		
	MC14495_ZJU M6(
		.D0(Hexs[4]),
		.D1(Hexs[5]),
		.D2(Hexs[6]),
		.D3(Hexs[7]),
		.LE(LEs[1]),
		.point(point[1]), 
		.SEG_TXT(SEG_TXT[55:48])
		);
	
	MC14495_ZJU M5(
		.D0(Hexs[8]), 
		.D1(Hexs[9]), 
		.D2(Hexs[10]), 
		.D3(Hexs[11]),
		.LE(LEs[2]), 
		.point(point[2]), 
		.SEG_TXT(SEG_TXT[47:40])
		);
	
	MC14495_ZJU M4(
		.D0(Hexs[12]), 
		.D1(Hexs[13]), 
		.D2(Hexs[14]), 
		.D3(Hexs[15]),
		.LE(LEs[3]), 
		.point(point[3]), 
		.SEG_TXT(SEG_TXT[39:32])
		);
	
	MC14495_ZJU M3(
		.D0(Hexs[16]), 
		.D1(Hexs[17]), 
		.D2(Hexs[18]), 
		.D3(Hexs[19]),
		.LE(LEs[4]), 
		.point(point[4]), 
		.SEG_TXT(SEG_TXT[31:24])
		);
	
	MC14495_ZJU M2(
		.D0(Hexs[20]), 
		.D1(Hexs[21]), 
		.D2(Hexs[22]), 
		.D3(Hexs[23]),
		.LE(LEs[5]), 
		.point(point[5]), 
		.SEG_TXT(SEG_TXT[23:16])
		);
	
	MC14495_ZJU M1(
		.D0(Hexs[24]), 
		.D1(Hexs[25]), 
		.D2(Hexs[26]), 
		.D3(Hexs[27]),
		.LE(LEs[6]), 
		.point(point[6]), 
		.SEG_TXT(SEG_TXT[15:8])
		);
	
	MC14495_ZJU M0(
		.D0(Hexs[28]), 
		.D1(Hexs[29]), 
		.D2(Hexs[30]), 
		.D3(Hexs[31]),
		.LE(LEs[7]), 
		.point(point[7]), 
		.SEG_TXT(SEG_TXT[7:0])
		);

endmodule

