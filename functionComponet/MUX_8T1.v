`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:02:51 03/17/2018 
// Design Name: 
// Module Name:    MUX_8T1 
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
module MUX_8T1 #(parameter N=8) (
	input [2:0] s,
	input [N-1:0] I0,
	input [N-1:0] I1,
	input [N-1:0] I2,
	input [N-1:0] I3,
	input [N-1:0] I4,
	input [N-1:0] I5,
	input [N-1:0] I6,
	input [N-1:0] I7,
	output reg [N-1:0] O
   );
	
	always@(*)
		case(s)
		3'b000: O = I0;
		3'b001: O = I1;
		3'b010: O = I2;
		3'b011: O = I3;
		3'b100: O = I4;
		3'b101: O = I5;
		3'b110: O = I6;
		3'b111: O = I7;
		endcase
		
endmodule