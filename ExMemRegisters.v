`timescale 1ns / 1ps

module ExMemRegisters (

    input clk,
    input rst,

    input ex_ifWriteRegsFile,
    input ex_ifWriteMem,
    input ex_memOutOrAluOutWriteBackToRegFile,
    input [4:0] ex_registerWriteAddress,
    input [31:0] ex_aluOutput,
    input [31:0] ex_registerRtOrZero,

    output reg mem_ifWriteRegsFile = 0,
    output reg mem_memOutOrAluOutWriteBackToRegFile = 0,
    output reg mem_ifWriteMem = 0,
    output reg [4:0] mem_registerWriteAddress = 0,
    output reg [31:0] mem_aluOutput = 0, // also need pass to RAM
    output reg [31:0] mem_registerRtOrZero = 0
);

	always @(posedge clk) begin

		if (rst) begin

			mem_ifWriteMem <= 0;
			mem_ifWriteRegsFile <= 0;
			mem_memOutOrAluOutWriteBackToRegFile <= 0;

			mem_aluOutput <= 0;
			mem_registerRtOrZero <= 0;
			mem_registerWriteAddress <= 0;

		end else begin

			mem_ifWriteMem <= ex_ifWriteMem;
			mem_ifWriteRegsFile <= ex_ifWriteRegsFile;
			mem_memOutOrAluOutWriteBackToRegFile <= ex_memOutOrAluOutWriteBackToRegFile;

			mem_aluOutput <= ex_aluOutput;
			mem_registerRtOrZero <= ex_registerRtOrZero;
			mem_registerWriteAddress <= ex_registerWriteAddress;
		end
	end

endmodule
