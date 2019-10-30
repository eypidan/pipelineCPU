`timescale 1ns / 1ps

module Pc (
		input clk,
		input rst,
		input id_shouldStall,
        input ex_shouldJumpOrBranch,
		input [31:0] nextPc,
		output reg [31:0] pc = 0
	);
	always @(posedge clk) begin
		if (rst) begin
			pc <= 0;
		end else if (id_shouldStall) begin
			pc <= pc;
            if(ex_shouldJumpOrBranch) begin
                pc <= nextPc;
            end
		end else begin
			pc <= nextPc;
		end
	end

endmodule
