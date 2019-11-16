`timescale 1ns / 1ps
`define DEBUG

module IdStage (
    `ifdef DEBUG
	input  [4:0]debug_addr,
	output [31:0]debug_data_reg,
    output debug_shouldJumpOrBranch,
    output debug_shouldBranch,
    output debug_jump,
    output [31:0]debug_id_instruction,
    output [31:0]debug_id_jumpAddress,
    output [31:0] debug_id_branchAddress,
    output debug_willExStageWriteRs,
    output debug_id_ifWriteRegsFile,
	`endif

    input clk,
    input rst,
    input [31:0] pc_4,
    input [31:0] instruction,
    input wb_RegWrite,  //wb_ means from wb
    input [4:0] wb_writeRegAddr,
    input [31:0]wb_writeRegData,
    input ex_shouldWriteRegister,
    input mem_shouldWriteRegister,
    input [4:0] ex_registerWriteAddress,
    input [4:0] mem_registerWriteAddress,

    output [31:0] jumpOrBranchPc, // connect to ifstage
    output [31:0] registerRtOrZero,
    output [31:0] registerRsOrPc_4,
    output [31:0] immediate,
    output [4:0] registerWriteAddress,
    output [3:0] ALU_Opeartion,
    output shouldJumpOrBranch,
    output ifWriteRegsFile,
    output ifWriteMem,
    output whileShiftAluInput_A_UseShamt,
    output memOutOrAluOutWriteBackToRegFile,
    output aluInput_B_UseRtOrImmeidate,
    output shouldStall
	);

    wire MIO_ready; // useless for now
    wire ifRsEqualRt;
    wire [31:0]rdata_A,rdata_B;

    pipeLineCPU_ctrl pipeLineCPU_ctrl_instance (
        `ifdef DEBUG
        .debug_shouldJumpOrBranch(debug_shouldJumpOrBranch),
        .debug_shouldBranch(debug_shouldBranch),
        .debug_jump(debug_jump),
        .debug_id_instruction(debug_id_instruction[31:0]),
        .debug_willExStageWriteRs(debug_willExStageWriteRs),
        `endif
        .instruction(instruction[31:0]), 
        .MIO_ready(MIO_ready), 
        .ifRsEqualRt(ifRsEqualRt), 
        .ex_shouldWriteRegister(ex_shouldWriteRegister), 
        .mem_shouldWriteRegister(mem_shouldWriteRegister), 
        .ex_registerWriteAddress(ex_registerWriteAddress[4:0]), 
        .mem_registerWriteAddress(mem_registerWriteAddress[4:0]), 
        .jal(jal), 
        .jump(jump), 
        .jumpRs(jumpRs), 
        .shouldJumpOrBranch(shouldJumpOrBranch), 
        .ifWriteRegsFile(ifWriteRegsFile), 
        .ifWriteMem(ifWriteMem), 
        .writeToRtOrRd(writeToRtOrRd), 
        .ALU_Opeartion(ALU_Opeartion[3:0]), 
        .whileShiftAluInput_A_UseShamt(whileShiftAluInput_A_UseShamt), 
        .memOutOrAluOutWriteBackToRegFile(memOutOrAluOutWriteBackToRegFile), 
        .zeroOrSignExtention(zeroOrSignExtention), 
        .aluInput_B_UseRtOrImmeidate(aluInput_B_UseRtOrImmeidate), 
        .shouldStall(shouldStall)
    );

    Regs RegisterInstance (
        `ifdef DEBUG
        .debug_addr(debug_addr[4:0]),
        .debug_data_reg(debug_data_reg[31:0]),
        `endif
        .clk(clk), 
        .rst(rst), 
        .L_S(wb_RegWrite), 
        .R_addr_A(instruction[25:21]), 
        .R_addr_B(instruction[20:16]),
        .Wt_addr(wb_writeRegAddr[4:0]), 
        .Wt_data(wb_writeRegData[31:0]), 
        .rdata_A(rdata_A[31:0]), 
        .rdata_B(rdata_B[31:0])
    );
    //register final output
    wire [31:0] finalRs,finalRt;
    assign finalRs[31:0] = rdata_A[31:0];
    assign finalRt[31:0] = rdata_B[31:0];
    
    //calculate rd,rt,or $ra will be finally write back 
    wire [4:0] RdOrRs;
    assign RdOrRs = writeToRtOrRd ?  instruction[20:16]: instruction[15:11];
    assign registerWriteAddress = jal ? 31 : RdOrRs;
    
    //deal witch jump or branch
    wire [31:0] branchAddress = pc_4 + {{14{instruction[15]}},instruction[15:0],2'b0};
    wire [31:0] jumpAddress = jump ? {pc_4[31:28],instruction[25:0],2'b0} : branchAddress[31:0];
    assign jumpOrBranchPc[31:0] = jumpRs ? finalRs[31:0] : jumpAddress[31:0];


    //calculate if branch, in id stage
    assign ifRsEqualRt = finalRs==finalRt; // equal -> ifRegisterRsRtEqual = 1
    
    //---
    assign registerRtOrZero = jal ? 0 : finalRt;
    assign registerRsOrPc_4 = jal ? pc_4 : finalRs;

    //calculate immediate
    assign immediate = {zeroOrSignExtention ? 16'b0 : {16{instruction[15]}},instruction[15:0]};

    `ifdef DEBUG
    assign debug_id_ifWriteRegsFile = ifWriteRegsFile;
    assign debug_id_jumpAddress[31:0] = jumpAddress[31:0];
    assign debug_id_branchAddress[31:0] = branchAddress[31:0];
    `endif
endmodule
