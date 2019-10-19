`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:37:54 10/07/2019
// Design Name:   ROM_D
// Module Name:   C:/Users/px/Downloads/OExp07_CPUMore/ROM_D_sim.v
// Project Name:  OExp07-SCPUMore
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ROM_D
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ROM_D_sim;

	// Inputs
	reg [9:0] a;

	// Outputs
	wire [31:0] spo;

	// Instantiate the Unit Under Test (UUT)
	ROM_D uut (
		.a(a), 
		.spo(spo)
	);

	initial begin
		// Initialize Inputs
		a = 10;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

