`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:57:36 10/14/2019 
// Design Name: 
// Module Name:    MUX5T1_32 
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
module MUX5T1_32(
input[31:0]I0,
input[31:0]I1,
input[31:0]I2,
input[31:0]I3,
input [31:0]I4,
input [2:0]s,
output reg[31:0]o
);

	always@*
		case(s)
			3'b000: o = I0;
			3'b001: o = I1;
			3'b010: o = I2;
			3'b011: o = I3;
			3'b100: o = I4;
		endcase
		
endmodule

