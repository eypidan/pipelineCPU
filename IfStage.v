`timescale 1ns / 1ps

module IfStage (
		input clk,
		input [31:0] pc,
		input id_shouldJumpOrBranch,	// BRANCH
		input [31:0] id_jumpOrBranchPc,
		output [31:0] pc_4,
		output [31:0] nextPc
	);

	assign pc_4 = pc + 4;
	assign nextPc = id_shouldJumpOrBranch ? id_jumpOrBranchPc : pc_4;
endmodule
