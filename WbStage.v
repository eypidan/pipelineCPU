`timescale 1ns / 1ps

module WbStage (
		input memOutOrAluOutWriteBackToRegFile, 	// WM2REG
		input [31:0] memoryData,
		input [31:0] aluOutput,
		output [31:0] registerWriteData
	);

	assign registerWriteData = memOutOrAluOutWriteBackToRegFile ? memoryData : aluOutput;
endmodule
