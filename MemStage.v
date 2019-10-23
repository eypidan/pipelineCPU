`timescale 1ns / 1ps

module MemStage (

		input clk,
		input rst,

		input [31:0] aluOutput,
		input shouldWriteMemory,
		input [31:0] registerRtOrZero,
		output [31:0] memoryData
	);

	DataMemory dataMemory(
		.clka(~clk),
		.addra(aluOutput[9:2]),
		.douta(memoryData[31:0]),
		.wea(shouldWriteMemory),
		.dina(registerRtOrZero[31:0])
	);
endmodule
