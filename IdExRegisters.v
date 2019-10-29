`timescale 1ns / 1ps

module IdExRegisters (
    input clk,
    input rst,
    // input id_shouldStall,
    input [31:0] id_shiftAmount,
    input [31:0] id_immediate,
    input [31:0] id_registerRsOrPc_4,
    input [31:0] id_registerRtOrZero,
    input [3:0] id_aluOperation,
    input [4:0] id_registerWriteBackDestination,
    input id_ifWriteRegsFile,
    input id_ifWriteMem,
    input id_whileShiftAluInput_A_UseShamt,
    input id_memOutOrAluOutWriteBackToRegFile,
    input id_aluInput_B_UseRtOrImmeidate,
    output reg [31:0] ex_shiftAmount = 0,
    output reg [31:0] ex_immediate = 0,
    output reg [31:0] ex_registerRsOrPc_4 = 0,
    output reg [31:0] ex_registerRtOrZero = 0,
    output reg [3:0] ex_aluOperation = 0,
    output reg [4:0] ex_registerWriteBackDestination = 0,
    output reg ex_ifWriteRegsFile = 0,
    output reg ex_ifWriteMem = 0,
    output reg ex_whileShiftAluInput_A_UseShamt = 0,
    
    output reg ex_memOutOrAluOutWriteBackToRegFile = 0,
    output reg ex_aluInput_B_UseRtOrImmeidate = 0
);

	always @(posedge clk) begin
        if(rst) begin
            ex_shiftAmount <=0 ;
            ex_immediate <= 0;
            ex_registerRsOrPc_4 <= 0;
            ex_registerRtOrZero <= 0;
            ex_aluOperation <= 0;
            ex_registerWriteBackDestination <= 0;

            ex_ifWriteRegsFile <=0 ;
            ex_ifWriteMem <= 0;
            ex_whileShiftAluInput_A_UseShamt <= 0;
            ex_memOutOrAluOutWriteBackToRegFile <=0 ;
            ex_aluInput_B_UseRtOrImmeidate <= 0;

        end else begin
            ex_shiftAmount <= id_shiftAmount;
            ex_immediate <= id_immediate; 
            ex_registerRsOrPc_4 <= id_registerRsOrPc_4;
            ex_registerRtOrZero <= id_registerRtOrZero;
            ex_aluOperation <= id_aluOperation;
            ex_registerWriteBackDestination <= id_registerWriteBackDestination;

            ex_ifWriteRegsFile <= id_ifWriteRegsFile;
            ex_ifWriteMem <= id_ifWriteMem;
            ex_whileShiftAluInput_A_UseShamt <= id_whileShiftAluInput_A_UseShamt;
            ex_memOutOrAluOutWriteBackToRegFile <= id_memOutOrAluOutWriteBackToRegFile;
            ex_aluInput_B_UseRtOrImmeidate <= id_aluInput_B_UseRtOrImmeidate;
        end
    end

endmodule
