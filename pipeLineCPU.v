`timescale 1ns / 1ps
module pipeLineCPU(
    input [31:0]inst_in,
    input [31:0]Data_in,
    input rst,
    input clk,
    input MIO_ready,
    input INT,
    output mem_w,
    output CPU_MIO,
    output [31:0]Addr_out,
    output [31:0]PC_out,
    output [31:0]Data_out
    );
	
	Pc instance_name (
        .clk(clk), 
        .rst(rst), 
        .id_shouldStall(id_shouldStall), 
        .nextPc(nextPc), 
        .pc(pc)
    );

    IfStage instance_name (
        .clk(clk), 
        .pc(pc), 
        .id_shouldJumpOrBranch(id_shouldJumpOrBranch), 
        .id_jumpOrBranchPc(id_jumpOrBranchPc), 
        .pc_4(pc_4), 
        .nextPc(nextPc)
    );

    IfIdRegisters instance_name (
        .clk(clk), 
        .rst(rst), 
        .id_shouldStall(id_shouldStall), 
        .if_pc_4(if_pc_4), 
        .if_instruction(if_instruction), 
        .id_pc_4(id_pc_4), 
        .id_instruction(id_instruction)
    );

    IdStage instance_name (
        .clk(clk), 
        .rst(rst), 
        .pc_4(pc_4), 
        .instruction(instruction), 
        .wb_RegWrite(wb_RegWrite), 
        .wb_writeRegAddr(wb_writeRegAddr), 
        .wb_writeRegData(wb_writeRegData), 
        .ex_shouldWriteRegister(ex_shouldWriteRegister), 
        .mem_shouldWriteRegister(mem_shouldWriteRegister), 
        .ex_registerWriteAddress(ex_registerWriteAddress), 
        .mem_registerWriteAddress(mem_registerWriteAddress), 
        .jumpOrBranchPc(jumpOrBranchPc), 
        .registerRtOrZero(registerRtOrZero), 
        .registerRsOrPc_4(registerRsOrPc_4), 
        .immediate(immediate), 
        .registerWriteBackDestination(registerWriteBackDestination), 
        .ALU_Opeartion(ALU_Opeartion), 
        .shouldJumpOrBranch(shouldJumpOrBranch), 
        .ifWriteRegsFile(ifWriteRegsFile), 
        .ifWriteMem(ifWriteMem), 
        .whileShiftAluInput_A_UseShamt(whileShiftAluInput_A_UseShamt), 
        .memOutOrAluOutWriteBackToRegFile(memOutOrAluOutWriteBackToRegFile), 
        .aluInput_B_UseRtOrImmeidate(aluInput_B_UseRtOrImmeidate), 
        .shouldStall(shouldStall)
    );

    IdExRegisters instance_name (
        .clk(clk), 
        .rst(rst), 
        .id_shiftAmount(id_shiftAmount), 
        .id_immediate(id_immediate), 
        .id_registerRsOrPc_4(id_registerRsOrPc_4), 
        .id_registerRtOrZero(id_registerRtOrZero), 
        .id_aluOperation(id_aluOperation), 
        .id_registerWriteBackDestination(id_registerWriteBackDestination), 
        .id_ifWriteRegsFile(id_ifWriteRegsFile), 
        .id_ifWriteMem(id_ifWriteMem), 
        .id_whileShiftAluInput_A_UseShamt(id_whileShiftAluInput_A_UseShamt), 
        .id_memOutOrAluOutWriteBackToRegFile(id_memOutOrAluOutWriteBackToRegFile), 
        .id_aluInput_B_UseRtOrImmeidate(id_aluInput_B_UseRtOrImmeidate), 
        .ex_shiftAmount(ex_shiftAmount), 
        .ex_immediate(ex_immediate), 
        .ex_registerRsOrPc_4(ex_registerRsOrPc_4), 
        .ex_registerRtOrZero(ex_registerRtOrZero), 
        .ex_aluOperation(ex_aluOperation), 
        .ex_registerWriteBackDestination(ex_registerWriteBackDestination), 
        .ex_ifWriteRegsFile(ex_ifWriteRegsFile), 
        .ex_ifWriteMem(ex_ifWriteMem), 
        .ex_whileShiftAluInput_A_UseShamt(ex_whileShiftAluInput_A_UseShamt), 
        .ex_memOutOrAluOutWriteBackToRegFile(ex_memOutOrAluOutWriteBackToRegFile), 
        .ex_aluInput_B_UseRtOrImmeidate(ex_aluInput_B_UseRtOrImmeidate)
    );

    ExStage instance_name (
        .shiftAmount(shiftAmount), 
        .immediate(immediate), 
        .aluOperation(aluOperation), 
        .whileShiftAluInput_A_UseShamt(whileShiftAluInput_A_UseShamt), 
        .aluInput_B_UseRtOrImmeidate(aluInput_B_UseRtOrImmeidate), 
        .registerRsOrPc_4(registerRsOrPc_4), 
        .registerRtOrZero(registerRtOrZero), 
        .aluOutput(aluOutput)
    );


    ExMemRegisters instance_name (
        .clk(clk), 
        .rst(rst), 
        .ex_ifWriteRegsFile(ex_ifWriteRegsFile), 
        .ex_ifWriteMem(ex_ifWriteMem), 
        .ex_memOutOrAluOutWriteBackToRegFile(ex_memOutOrAluOutWriteBackToRegFile), 
        .ex_registerWriteAddress(ex_registerWriteAddress), 
        .ex_aluOutput(ex_aluOutput), 
        .ex_registerRtOrZero(ex_registerRtOrZero), 
        .mem_ifWriteRegsFile(mem_ifWriteRegsFile), 
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile), 
        .mem_ifWriteMem(mem_ifWriteMem), 
        .mem_registerWriteAddress(mem_registerWriteAddress), 
        .mem_aluOutput(mem_aluOutput), 
        .mem_registerRtOrZero(mem_registerRtOrZero)
    );

    MemWbRegisters instance_name (
        .clk(clk), 
        .rst(rst), 
        .mem_ifWriteRegsFile(mem_ifWriteRegsFile), 
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile), 
        .mem_registerWriteAddress(mem_registerWriteAddress), 
        .mem_memoryData(mem_memoryData), 
        .mem_aluOutput(mem_aluOutput), 
        .wb_ifWriteRegsFile(wb_ifWriteRegsFile), 
        .wb_memOutOrAluOutWriteBackToRegFile(wb_memOutOrAluOutWriteBackToRegFile), 
        .wb_registerWriteAddress(wb_registerWriteAddress), 
        .wb_memoryData(wb_memoryData), 
        .wb_aluOutput(wb_aluOutput)
    );
endmodule
