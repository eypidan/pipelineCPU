`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:20:22 03/17/2018 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div(
	input clk,
	input rst,
	input siwtch,   // CPUÊ±ÖÓÄ£Ê½ÇÐ»»
	output reg [31:0] clkdiv,
	output clk_cpu
   );

	initial clkdiv = 32'b0;
	
	always @(posedge clk or posedge rst) begin
		if(rst) clkdiv <= 0;
		else clkdiv <= clkdiv +1'b1;
	end
	
	assign clk_cpu = siwtch ? clkdiv[24] : clkdiv[2];
	
endmodule
