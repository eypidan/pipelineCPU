`timescale 1ns / 1ps

module IdStage (
		input clk,
		input rst,
		input [31:0] pc_4,
		input [31:0] instruction,
        input wb_RegWrite,  //wb_ means from wb
        input [4:0]wb_writeRegAddr,
        input [31:0]wb_writeRegData,
        
        output [31:0]jumpOrBranchPc, // connect to if stage
        output [31:0]registerRtOrZero,
        output [31:0]registerRsOrPc_4,
        output [31:0]immediate,
        output [3:0] writeBackDestination,
        output [3:0]ALU_Opeartion,
        output RegWrite,
        output mem_write,
        output shouldJumpOrBranch
	);

    wire MIO_ready; // useless for now
    wire ifRsEqualRt;
    wire [31:0]rdata_A,rdata_B;

    pipeLineCPU_ctrl controlUnitInstance (
        .instruction(instruction[31:0]), 
        .MIO_ready(MIO_ready), 
        .ifRsEqualRt(ifRsEqualRt), 
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
        .jumpAddress(jumpAddress[25:0]), 
        .shouldStall(shouldStall)
    );

    Regs RegisterInstance (
        .clk(clk), 
        .rst(rst), 
        .L_S(wb_RegWrite), 
        .R_addr_A(instruction[25:21]), 
        .R_addr_B(instruction[20:16]),
        .Wt_addr(wb_writeRegAddr), 
        .Wt_data(wb_writeRegData), 
        .rdata_A(rdata_A), 
        .rdata_B(rdata_B)
    );
    //register final output
    wire [31:0] finalRs,finalRt;
    assign finalRs[31:0] = rdata_A;
    assign finalRt[31:0] = rdata_B;
    
    //calculate rd,rt,or $ra will be finally write back 
    wire [4:0] RdOrRs;
    assign RdOrRs = writeToRtOrRd ? instruction[15:11] : instruction[20:16];
    assign writeBackDestination = jal ? 31 : RdOrRs;
    
    //deal witch jump or branch
    wire [31:0] branchAddress = pc_4 + {14{instruction[15]},instruction[15:0],2'b0};
    wire [31:0] jumpAddress = jump ? {pc_4[31:28],instruction[25:0],2'b0} : branchAddress;
    wire [31:0] jumpOrBranchPc = jumpRs ? finalRs : jumpAddress;
    
    //calculate if branch, in id stage
    assign ifRsEqualRt = finalRs==finalRt; // equal -> ifRegisterRsRtEqual = 1
    
    //---
    assign registerRtOrZero = jal ? 0 : finalRt;
    assign registerRsOrPc_4 = jal ? registerRsOrPc_4 : finalRs;

    //calculate immediate
    assign immediate = {zeroOrSignExtention ? 16'b0 : {16{instruction[15]}},instruction[15:0]};
endmodule
