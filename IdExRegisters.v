`timescale 1ns / 1ps

module IdExRegisters (
    input clk,
    input rst,
    input cpu_en,
    input id_shouldStall,
    input [31:0] id_shiftAmount,
    input [31:0] id_immediate,
    input [31:0] id_registerRsOrPc_4,
    input [31:0] id_registerRtOrZero,
    input [3:0] id_aluOperation,
    input [4:0] id_registerWriteAddress,
    input id_ifWriteRegsFile,
    input id_ifWriteMem,
    input id_whileShiftAluInput_A_UseShamt,
    input id_memOutOrAluOutWriteBackToRegFile,
    input id_aluInput_B_UseRtOrImmeidate,
    input id_shouldJumpOrBranch,
    input [31:0] id_jumpOrBranchPc,
    output reg [31:0] ex_shiftAmount = 0,
    output reg [31:0] ex_immediate = 0,
    output reg [31:0] ex_registerRsOrPc_4 = 0,
    output reg [31:0] ex_registerRtOrZero = 0,
    output reg [3:0] ex_aluOperation = 0,
    output reg [4:0] ex_registerWriteAddress = 0,
    output reg ex_ifWriteRegsFile = 0,
    output reg ex_ifWriteMem = 0,
    output reg ex_whileShiftAluInput_A_UseShamt = 0,
    output reg ex_memOutOrAluOutWriteBackToRegFile = 0,
    output reg ex_aluInput_B_UseRtOrImmeidate = 0,
    output reg ex_shouldJumpOrBranch = 0  ,
    output reg [31:0] ex_jumpOrBranchPc = 0
);

	always @(posedge clk) begin
        if(rst || id_shouldStall) begin
            ex_shiftAmount <=0 ;
            ex_immediate <= 0;
            ex_registerRsOrPc_4 <= 0;
            ex_registerRtOrZero <= 0;
            ex_aluOperation <= 0;
            ex_registerWriteAddress <= 0;

            ex_ifWriteRegsFile <=0 ;
            ex_ifWriteMem <= 0;
            ex_whileShiftAluInput_A_UseShamt <= 0;
            ex_memOutOrAluOutWriteBackToRegFile <=0 ;
            ex_aluInput_B_UseRtOrImmeidate <= 0;
            ex_shouldJumpOrBranch <= 0;
            ex_jumpOrBranchPc <= 0;
        end else if(cpu_en) begin
            ex_shiftAmount <= id_shiftAmount;
            ex_immediate <= id_immediate; 
            ex_registerRsOrPc_4 <= id_registerRsOrPc_4;
            ex_registerRtOrZero <= id_registerRtOrZero;
            ex_aluOperation <= id_aluOperation;
            ex_registerWriteAddress <= id_registerWriteAddress;

            ex_ifWriteRegsFile <= id_ifWriteRegsFile;
            ex_ifWriteMem <= id_ifWriteMem;
            ex_whileShiftAluInput_A_UseShamt <= id_whileShiftAluInput_A_UseShamt;
            ex_memOutOrAluOutWriteBackToRegFile <= id_memOutOrAluOutWriteBackToRegFile;
            ex_aluInput_B_UseRtOrImmeidate <= id_aluInput_B_UseRtOrImmeidate;
            ex_shouldJumpOrBranch <= id_shouldJumpOrBranch;
            ex_jumpOrBranchPc <= id_jumpOrBranchPc;
        end
        else begin
            ex_shiftAmount <= ex_shiftAmount;
            ex_immediate <= ex_immediate; 
            ex_registerRsOrPc_4 <= ex_registerRsOrPc_4;
            ex_registerRtOrZero <= ex_registerRtOrZero;
            ex_aluOperation <= ex_aluOperation;
            ex_registerWriteAddress <= ex_registerWriteAddress;

            ex_ifWriteRegsFile <= ex_ifWriteRegsFile;
            ex_ifWriteMem <= ex_ifWriteMem;
            ex_whileShiftAluInput_A_UseShamt <= ex_whileShiftAluInput_A_UseShamt;
            ex_memOutOrAluOutWriteBackToRegFile <= ex_memOutOrAluOutWriteBackToRegFile;
            ex_aluInput_B_UseRtOrImmeidate <= ex_aluInput_B_UseRtOrImmeidate;
            ex_shouldJumpOrBranch <= ex_shouldJumpOrBranch;
            ex_jumpOrBranchPc <= ex_jumpOrBranchPc;
        end
    end

endmodule
