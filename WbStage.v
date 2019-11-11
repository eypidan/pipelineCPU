`timescale 1ns / 1ps
`define DEBUG

module WbStage (
        `ifdef DEBUG
        output [31:0]debug_wb_memoryData,
        output [31:0]debug_wb_aluOutput,
        output debug_memOutOrAluOutWriteBackToRegFile,
        `endif
		input memOutOrAluOutWriteBackToRegFile, 	// WM2REG
		input [31:0] memoryData,
		input [31:0] aluOutput,
		output [31:0] registerWriteData
	);
    `ifdef DEBUG
    assign debug_wb_memoryData[31:0] = memoryData[31:0];
    assign debug_wb_aluOutput[31:0] = aluOutput[31:0];
    assign debug_memOutOrAluOutWriteBackToRegFile = memOutOrAluOutWriteBackToRegFile;
    `endif
	assign registerWriteData = memOutOrAluOutWriteBackToRegFile ? memoryData : aluOutput;
endmodule
