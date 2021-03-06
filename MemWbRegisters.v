`timescale 1ns / 1ps

module MemWbRegisters (

		input clk,
		input rst,
        input cpu_en,
        input [31:0] mem_instruction,
        input [31:0] mem_pc,
        input mem_ifWriteRegsFile,
        input mem_memOutOrAluOutWriteBackToRegFile,
		input [4:0] mem_registerWriteAddress,
		input [31:0] mem_memoryData,
		input [31:0] mem_aluOutput,

        output reg [31:0] wb_instruction = 0,
        output reg [31:0] wb_pc=0,
		output reg wb_ifWriteRegsFile = 0,
		output reg wb_memOutOrAluOutWriteBackToRegFile = 0,
        output reg [4:0] wb_registerWriteAddress = 0,
		output reg [31:0] wb_memoryData = 0,
		output reg [31:0] wb_aluOutput = 0
	);

	always @(posedge clk) begin

		if (rst) begin
			wb_ifWriteRegsFile <= 0;
			wb_memOutOrAluOutWriteBackToRegFile <= 0;
			wb_registerWriteAddress <= 0;
			wb_memoryData <= 0;
			wb_aluOutput <= 0;
            wb_instruction <= 0;
            wb_pc <= 0;
		end else begin
            if(cpu_en) begin
                wb_ifWriteRegsFile <= mem_ifWriteRegsFile;
                wb_memOutOrAluOutWriteBackToRegFile <= mem_memOutOrAluOutWriteBackToRegFile;
                wb_registerWriteAddress <= mem_registerWriteAddress;
                wb_memoryData <= mem_memoryData;
                wb_aluOutput <= mem_aluOutput;
                wb_instruction <= mem_instruction;
                wb_pc <= mem_pc;
            end
            else begin
                wb_ifWriteRegsFile <= wb_ifWriteRegsFile;
                wb_memOutOrAluOutWriteBackToRegFile <= wb_memOutOrAluOutWriteBackToRegFile;
                wb_registerWriteAddress <= wb_registerWriteAddress;
                wb_memoryData <= wb_memoryData;
                wb_aluOutput <= wb_aluOutput;
                wb_instruction <= wb_instruction;
                wb_pc <= wb_pc;
            end
		end
	end
endmodule
