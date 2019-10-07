`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:14:33 03/23/2018
// Design Name:   clk_div
// Module Name:   C:/Users/Zzh/Desktop/EXP/Exp/clk_div_sim.v
// Project Name:  Exp
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clk_div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clk_div_sim;

	// Inputs
	reg clk;
	reg rst;
	reg siwtch;

	// Outputs
	wire [31:0] clkdiv;
	wire clk_cpu;

	// Instantiate the Unit Under Test (UUT)
	clk_div uut (
		.clk(clk), 
		.rst(rst), 
		.siwtch(siwtch), 
		.clkdiv(clkdiv), 
		.clk_cpu(clk_cpu)
	);

	initial clk = 0;
	always begin
		clk = ~clk;
		#2;
	end
	
	initial begin
		rst = 0;
		siwtch = 0;
		#50;
		
		rst = 1;
		#10;
		
		rst = 0;
		siwtch = 1;
	end
      
endmodule

