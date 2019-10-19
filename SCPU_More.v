`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:50:02 10/14/2019 
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
    input [31:0]inst_in,
    input [31:0]Data_in,
    input reset,
    input clk,
    input MIO_ready,
    input INT,
    output mem_w,
    output CPU_MIO,
    output [31:0]Addr_out,
    output [31:0]PC_out,
    output [31:0]Data_out
    );
	 
	wire zero,RegDst,ALUSrc_B,ALUSrc_A,Jal,RegWrite,zeroExt;
	wire [1:0]DatatoReg,Branch;
	wire [2:0]ALU_Control;
	
	SCPU_ctrl CPU_Control_inst (
		 .OPcode(inst_in[31:26]), 
		 .Fun(inst_in[5:0]), 
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
		 .DatatoRegExtra(DatatoRegExtra),
		 .CPU_MIO(CPU_MIO), 
		 .zeroExt(zeroExt),
		 .ALUSrc_A(ALUSrc_A)
		 );
		 
	Data_path Data_path_inst (
		 .clk(clk), 
		 .rst(reset), 
		 .Branch(Branch), 
		 .ALU_Control(ALU_Control), 
		 .ALUSrc_B(ALUSrc_B), 
		 .ALUSrc_A(ALUSrc_A), 
		 .RegWrite(RegWrite), 
		 .DatatoRegExtra(DatatoRegExtra),
		 .Jal(Jal), 
		 .RegDst(RegDst), 
		 .inst_field(inst_in[25:0]), 
		 .Data_in(Data_in), 
		 .DatatoReg(DatatoReg), 
		 .zero(zero), 
		 .overflow(overflow), 
		 .ALU_out(Addr_out), 
		 .PC_out(PC_out), 
		 .zeroExt(zeroExt),
		 .Data_out(Data_out)
		 );
	 
endmodule
