`timescale 1ns / 1ps

module IfStage (
		input clk,
		input [31:0] pc,
		input id_shouldJumpOrBranch,	// BRANCH
		input [31:0] id_jumpOrBranchPc,
        input epc_ctrl,
        input [31:0] jumpAddressExcept,
		output [31:0] pc_4,
		output [31:0] nextPc
	);
    wire [31:0] normalNextPc;
	assign pc_4 = pc + 4;
	assign normalNextPc = id_shouldJumpOrBranch ? id_jumpOrBranchPc[31:0] : pc_4[31:0];
    assign nextPc = epc_ctrl ? jumpAddressExcept[31:0] : normalNextPc[31:0];

endmodule
