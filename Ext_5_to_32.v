`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:57:16 10/07/2019 
// Design Name: 
// Module Name:    Ext_5_to_32 
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
module Ext_5_to_32(
input wire [4:0]A,
output wire [31:0]B
    );

assign B = {27'b0,A[4:0]};

endmodule
