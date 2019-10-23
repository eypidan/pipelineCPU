`timescale 1ns / 1ps

module IfIdRegisters (
		input clk,
		input rst,
		input id_shouldStall,
		input [31:0] if_pc_4,
		input [31:0] if_instruction,
		output reg [31:0] id_pc_4 = 0,
		output reg [31:0] id_instruction = 0
	);

	always @(posedge clk) begin
		if (rst) begin
			id_pc_4 <= 0;
			id_instruction <= 0;
		end else if (id_shouldStall) begin
			id_pc_4 <= id_pc_4;
			id_instruction <= 0;  // when stall,push bable into next stage
		end else begin
			id_pc_4 <= if_pc_4;
			id_instruction <= if_instruction;
		end
	end
endmodule
