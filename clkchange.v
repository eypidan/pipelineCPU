`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:41:21 10/07/2019 
// Design Name: 
// Module Name:    clkchange 
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
module clkchange(
   input clk200P,clk200N,
	input rst,
	output clk100MHz
);
					
	IBUFDS sclk(.I(clk200P),
	//clk:differential clock to signel ended clock
		.IB(clk200N),
		.O(clk200m)  // this is what we use
	);
	// Clock divider
	reg[31:0]clkdivqqq;
	assign clk100MHz = clkdivqqq[0];
	always @ (posedge clk200m or posedge rst) begin 
	 if (rst) clkdivqqq <= 0; 
	 else clkdivqqq <= clkdivqqq + 1'b1; 
	end
	
endmodule
