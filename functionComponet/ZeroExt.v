`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:49:00 10/14/2019 
// Design Name: 
// Module Name:    ZeroExt 
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
module ZeroExt(
input [15:0] imm_16,
output [31:0] imm_32
    );

assign imm_32 = { 16'b0 , imm_16[15:0] };			//扩展为32位符号数

endmodule

