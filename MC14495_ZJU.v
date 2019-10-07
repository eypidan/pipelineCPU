`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:23:54 03/17/2018 
// Design Name: 
// Module Name:    MC14495_ZJU 
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
module MC14495_ZJU(
	input D3,
	input D2,
	input D1,
	input D0,
	input point,
	input LE,
	output reg[7:0] SEG_TXT
   );
	
	//低电平有效
	//LE为0时亮起，为1时熄灭
	//point还会取反，因此为1时小数点亮起，为0时熄灭
	
	wire[3:0] D;
	assign D = {D3, D2, D1, D0};
	
	wire point_inv;
	assign point_inv = ~point;
	always @(*)
	begin
		case(D)
			4'h0:	SEG_TXT = {7'b000_0001, point_inv};
			4'h1:	SEG_TXT = {7'b100_1111, point_inv};
			4'h2:	SEG_TXT = {7'b001_0010, point_inv};
			4'h3:	SEG_TXT = {7'b000_0110, point_inv};
			4'h4:	SEG_TXT = {7'b100_1100, point_inv};
			4'h5:	SEG_TXT = {7'b010_0100, point_inv};
			4'h6:	SEG_TXT = {7'b010_0000, point_inv};
			4'h7:	SEG_TXT = {7'b000_1111, point_inv};
			4'h8:	SEG_TXT = {7'b000_0000, point_inv};
			4'h9:	SEG_TXT = {7'b000_0100, point_inv};
			4'hA:	SEG_TXT = {7'b000_1000, point_inv};
			4'hB:	SEG_TXT = {7'b110_0000, point_inv};
			4'hC:	SEG_TXT = {7'b011_0001, point_inv};
			4'hD:	SEG_TXT = {7'b100_0010, point_inv};
			4'hE:	SEG_TXT = {7'b011_0000, point_inv};
			4'hF:	SEG_TXT = {7'b011_1000, point_inv};
			default:	SEG_TXT = 8'b1111_1111;
		endcase
		
		SEG_TXT[7] = SEG_TXT[7] || LE;
		SEG_TXT[6] = SEG_TXT[6] || LE;
		SEG_TXT[5] = SEG_TXT[5] || LE;		
		SEG_TXT[4] = SEG_TXT[4] || LE;
		SEG_TXT[3] = SEG_TXT[3] || LE;
		SEG_TXT[2] = SEG_TXT[2] || LE;
		SEG_TXT[1] = SEG_TXT[1] || LE;
		SEG_TXT[0] = SEG_TXT[0] || LE;
		
	end
	
endmodule
