`timescale 1ns / 1ps
`define DEBUG
module ExStage (
    `ifdef DEBUG
    output [31:0]debug_ex_aluOutput,
    output [31:0]debug_aluInputA,
    output [31:0]debug_aluInputB,
    output [3:0]debug_ex_aluOperation,
    output debug_useForwardingDataFromMemData,
    `endif
    input [31:0] shiftAmount,
    input [31:0] immediate,

    input [3:0] aluOperation,	// EALUC
    input whileShiftAluInput_A_UseShamt,	// ESHIFT
    input aluInput_B_UseRtOrImmeidate,	// EALUIMM

    input [31:0] registerRsOrPc_4,
    input [31:0] registerRtOrZero,
    //lw-sw forwarding
    input ex_swSignalAndLastRtEqualCurrentRt, //current if sw
    input mem_memOutOrAluOutWriteBackToRegFile, // last if lw
    input [31:0] mem_memoryData,
    output [31:0] aluOutput,
    output [31:0] ex_writeDataToDataRAM,
    //cp0 relative
    output ex_overflow
);

    wire [31:0] shift;
    assign shift[31:0] = {27'b0,immediate[10:6]};
	wire [31:0] aluInputA = whileShiftAluInput_A_UseShamt ? shift : registerRsOrPc_4;
	wire [31:0] aluInputB = aluInput_B_UseRtOrImmeidate ? immediate : registerRtOrZero;
	
    wire useForwardingDataFromMemData;
    assign useForwardingDataFromMemData = ex_swSignalAndLastRtEqualCurrentRt && mem_memOutOrAluOutWriteBackToRegFile;
    assign ex_writeDataToDataRAM[31:0] =  useForwardingDataFromMemData ? mem_memoryData[31:0] : registerRtOrZero[31:0];


    `ifdef DEBUG
    assign debug_ex_aluOutput[31:0] = aluOutput[31:0];
    assign debug_aluInputA[31:0] = aluInputA[31:0];
    assign debug_aluInputB[31:0] = aluInputB[31:0];
    assign debug_ex_aluOperation[3:0] = aluOperation[3:0];
    assign debug_useForwardingDataFromMemData = useForwardingDataFromMemData;
    `endif
    
	Alu aluw (
		.inputA(aluInputA[31:0]),
		.inputB(aluInputB[31:0]),
		.operation(aluOperation[3:0]),
		.result(aluOutput[31:0]).
        .overflow(ex_overflow)
	);

endmodule
