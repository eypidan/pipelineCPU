`timescale 1ns / 1ps

module IfStage (
		input clk,
		input [31:0] pc,
		input ex_shouldJumpOrBranch,	// BRANCH
		input [31:0] ex_jumpOrBranchPc,
		output [31:0] pc_4,
		output [31:0] nextPc
	);

	assign pc_4 = pc + 4;
	assign nextPc = ex_shouldJumpOrBranch ? ex_jumpOrBranchPc : pc_4;
endmodule
