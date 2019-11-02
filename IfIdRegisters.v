`timescale 1ns / 1ps

module IfIdRegisters (
		input clk,
		input rst,
        input cpu_en,
		input id_shouldStall,
        input ex_shouldJumpOrBranch,
		input [31:0] if_pc_4,
		input [31:0] if_instruction,
		output reg [31:0] id_pc_4 = 0,
		output reg [31:0] id_instruction = 0
	);

	always @(posedge clk) begin
		if (rst) begin
			id_pc_4 <= 0;
			id_instruction <= 0;
		end else if(cpu_en) begin
            if (id_shouldStall) begin
                id_pc_4 <= id_pc_4;
                id_instruction <= id_instruction;  // when stall,push bable into next stage
                if(ex_shouldJumpOrBranch) begin
                    id_instruction <= 0; //flushing pipeline
                end
            end else begin
                id_pc_4 <= if_pc_4;
                id_instruction <= if_instruction;
            end 
        end else begin
            id_pc_4 <= id_pc_4;
            id_instruction <= id_instruction;
        end
	end
endmodule
