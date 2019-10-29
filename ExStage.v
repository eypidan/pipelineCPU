`timescale 1ns / 1ps

module ExStage (
    input [31:0] shiftAmount,
    input [31:0] immediate,

    input [3:0] aluOperation,	// EALUC
    input whileShiftAluInput_A_UseShamt,	// ESHIFT
    input aluInput_B_UseRtOrImmeidate,	// EALUIMM

    input [31:0] registerRsOrPc_4,
    input [31:0] registerRtOrZero,

    output [31:0] aluOutput
);

	wire [31:0] aluInputA = whileShiftAluInput_A_UseShamt ? shiftAmount : registerRsOrPc_4;
	wire [31:0] aluInputB = aluInput_B_UseRtOrImmeidate ? immediate : registerRtOrZero;
	
	Alu aluw (
		.inputA(aluInputA[31:0]),
		.inputB(aluInputB[31:0]),
		.operation(aluOperation[3:0]),
		.output_(aluOutput[31:0])
	);

endmodule
