`timescale 1ns / 1ps

module IfIdRegisters (
		input clk,
		input rst,
        input cpu_en,
        input eret_clearSignal,
		input id_shouldStall,
        input id_shouldJumpOrBranch,
		input [31:0] if_pc_4,
		input [31:0] if_instruction,
        input [31:0] if_pc,
		output reg [31:0] id_pc_4 = 0,
		output reg [31:0] id_instruction = 0,
        output reg [31:0] id_pc = 0,
        //cp0 relative
        input exceptClear
	);

	always @(posedge clk) begin
		if (rst) begin
			id_pc_4 <= 0;
			id_instruction <= 0;
            id_pc <= 0;
		end else if(cpu_en) begin
            if (id_shouldStall) begin
                id_pc_4 <= id_pc_4;
                id_instruction <= id_instruction;  // when stall,id stage keep 
                id_pc <= id_pc;
            end else begin
                id_pc_4 <= if_pc_4;
                id_instruction <= if_instruction;
                id_pc <= if_pc;
                if(id_shouldJumpOrBranch) begin
                    id_instruction <= 0; //flushing pipeline
                    id_pc <= 0;
                end
            end 

            if(exceptClear || eret_clearSignal) begin
                id_pc_4 <= 0;
			    id_instruction <= 0;
                id_pc <= 0;
            end

        end else begin
            id_pc_4 <= id_pc_4;
            id_instruction <= id_instruction;
            id_pc<= id_pc;
        end
	end
endmodule
