`timescale 1ns / 1ps

module Pc (
		input clk,
		input rst,
        input cpu_en,
		input id_shouldStall,
        input id_shouldJumpOrBranch,
		input [31:0] nextPc,
		output reg [31:0] pc = 0
	);
	always @(posedge clk) begin

        if (rst) begin
			pc <= 0;
        end else if(cpu_en)begin
           //if cpu_en 
           if(id_shouldStall) begin
                pc <= pc;
                if(id_shouldJumpOrBranch) begin
                    pc[31:0] <= nextPc[31:0];
                end
           end else begin
                pc[31:0] <= nextPc[31:0];
           end
        end else begin
            //cpu_en = 0
            pc <= pc;
        end
    end
endmodule
