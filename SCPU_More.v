`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:28:33 10/07/2019 
// Design Name: 
// Module Name:    SCPU_More 
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
module SCPU_More(
	input wire clk, 
	input wire reset, 
	input wire [31:0]Data_in, 
	input wire [31:0]inst_in, 
	input wire INT, 
	input wire MIO_ready,
	output wire mem_w, 
	output wire CPU_MIO, 
	output wire [31:0]Addr_out, 
	output wire [31:0]Data_out, 
	output wire [31:0]PC_out
);
/*
wire ALUSrc_A,ALUSrc_B;
SCPU_ctrl A1 (
    .OPcode(OPcode), 
    .Fun(inst_in), 
    .MIO_ready(MIO_ready), 
    .zero(zero), 
    .RegDst(RegDst), 
    .ALUSrc_B(ALUSrc_B), 
    .DatatoReg(DatatoReg), 
    .RegWrite(RegWrite), 
    .ALU_Control(ALU_Control), 
    .mem_w(mem_w), 
    .Branch(Branch), 
    .Jal(Jal), 
    .CPU_MIO(CPU_MIO), 
    .ALUSrc_A(ALUSrc_A)
    );
*/

	

endmodule
