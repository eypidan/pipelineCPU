`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:37:50 04/17/2018 
// Design Name: 
// Module Name:    Regs 
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
module Regs(
    input clk,rst,L_S, 
    input [4:0] R_addr_A, R_addr_B, Wt_addr, 
    input [31:0] Wt_data,
    output [31:0] rdata_A,rdata_B
);

	reg [31:0] register [1:31]; 		// r1 - r31
    integer i;

	assign rdata_A = (R_addr_A == 0) ? 0 : register[R_addr_A];	   	// read
	assign rdata_B = (R_addr_B == 0) ? 0 : register[R_addr_B];   	// read

	always @(negedge clk or posedge rst)  // double bump
	begin   
		if (rst==1)  
			for (i=1; i<32; i=i+1)  
				register[i] <= 32'b0; 		// reset
		else if ((Wt_addr != 0) && (L_S == 1)) 
				register[Wt_addr] <= Wt_data;      			// write
	end

endmodule
