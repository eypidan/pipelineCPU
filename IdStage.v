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
    output debug_shouldForwardRegisterRs,
    output debug_shouldForwardRegisterRt,
	`endif

    input clk,
    input rst,
    input [31:0] pc_4,
    input [31:0] instruction,
    input wb_RegWrite,  //wb_ means from wb
    input [4:0] wb_registerWriteAddress,
    input [31:0]wb_writeRegData,
    input ex_shouldWriteRegister,
    input mem_shouldWriteRegister,
    input [4:0] ex_registerWriteAddress,
    input [4:0] mem_registerWriteAddress,
    //forwarding signal
    input ex_memOutOrAluOutWriteBackToRegFile,
    input mem_memOutOrAluOutWriteBackToRegFile,
    input [31:0]ex_aluOutput,
    input [31:0]mem_aluOutput,
    input [31:0]mem_memoryData,
    input [31:0]ex_instruction,

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
    output shouldStall,
    //forwarding signal
    output swSignalAndLastRtEqualCurrentRt,
    //cp0 relative signal
    input overflow,
    input [31:0] except_ret_addr,
    input [2:0]interruptSignal,
    output epc_ctrl,
    output [31:0]jumpAddressExcept,
    output exceptClear
	);

    wire MIO_ready; // useless for now
    wire ifRsEqualRt;
    wire [31:0]rdata_A,rdata_B;

    
    //register final output
    wire [31:0] finalRs,finalRt;

    //calculate immediate
    assign immediate = {zeroOrSignExtention ? 16'b0 : {16{instruction[15]}},instruction[15:0]};

    `ifdef DEBUG
    assign debug_id_ifWriteRegsFile = ifWriteRegsFile;
    assign debug_id_jumpAddress[31:0] = jumpAddress[31:0];
    assign debug_id_branchAddress[31:0] = branchAddress[31:0];
    `endif

    wire shouldForwardRegisterRsWithExStageAluOutput;
	wire shouldForwardRegisterRsWithMemStageAluOutput;
	wire shouldForwardRegisterRsWithMemStageMemoryData;
	wire shouldForwardRegisterRtWithExStageAluOutput;
	wire shouldForwardRegisterRtWithMemStageAluOutput;
	wire shouldForwardRegisterRtWithMemStageMemoryData;

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
        .registerWriteAddress(registerWriteAddress[4:0]),
        //forwarding signal
        .ex_memOutOrAluOutWriteBackToRegFile(ex_memOutOrAluOutWriteBackToRegFile),
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile),
        .ex_instruction(ex_instruction[31:0]),

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
        .shouldStall(shouldStall),
        .shouldForwardRegisterRsWithExStageAluOutput(shouldForwardRegisterRsWithExStageAluOutput),
		.shouldForwardRegisterRsWithMemStageAluOutput(shouldForwardRegisterRsWithMemStageAluOutput),
		.shouldForwardRegisterRsWithMemStageMemoryData(shouldForwardRegisterRsWithMemStageMemoryData),
		.shouldForwardRegisterRtWithExStageAluOutput(shouldForwardRegisterRtWithExStageAluOutput),
		.shouldForwardRegisterRtWithMemStageAluOutput(shouldForwardRegisterRtWithMemStageAluOutput),
		.shouldForwardRegisterRtWithMemStageMemoryData(shouldForwardRegisterRtWithMemStageMemoryData),
        .swSignalAndLastRtEqualCurrentRt(swSignalAndLastRtEqualCurrentRt),
        //cp0 relative
        .ex_aluOutput(ex_aluOutput[31:0]),
        .cp_oper(cp_oper[2:0]),
        .undefined(undefined),
        .outOfMemory(outOfMemory)
    );

    assign finalRs[31:0] = 
        shouldForwardRegisterRsWithExStageAluOutput ? ex_aluOutput[31:0]
        : shouldForwardRegisterRsWithMemStageAluOutput ? mem_aluOutput[31:0]
        : shouldForwardRegisterRsWithMemStageMemoryData ? mem_memoryData[31:0]
        : rdata_A[31:0];
    
    assign finalRt[31:0] = 
        shouldForwardRegisterRtWithExStageAluOutput ? ex_aluOutput[31:0]
        : shouldForwardRegisterRtWithMemStageAluOutput ? mem_aluOutput[31:0]
        : shouldForwardRegisterRtWithMemStageMemoryData ? mem_memoryData[31:0]
        : cp0Instruction ? data_readFromCP0[31:0]
        : rdata_B[31:0];

    //calculate rd,rt,or $ra will be finally write back 
    wire [4:0] RdOrRs;
    assign RdOrRs = writeToRtOrRd ?  instruction[20:16]: instruction[15:11];
    assign registerWriteAddress[4:0] = jal ? 31 : RdOrRs;
    
    //deal witch jump or branch
    wire [31:0] branchAddress = pc_4 + {{14{instruction[15]}},instruction[15:0],2'b0};
    wire [31:0] jumpAddress = jump ? {pc_4[31:28],instruction[25:0],2'b0} : branchAddress[31:0];
    assign jumpOrBranchPc[31:0] = jumpRs ? finalRs[31:0] : jumpAddress[31:0];


    //calculate if branch, in id stage
    assign ifRsEqualRt = finalRs==finalRt; // equal -> ifRegisterRsRtEqual = 1
    
    //---
    assign registerRtOrZero = jal ? 0 : finalRt;
    assign registerRsOrPc_4 = jal ? pc_4 : finalRs;

    assign debug_shouldForwardRegisterRs = shouldForwardRegisterRsWithExStageAluOutput || shouldForwardRegisterRsWithMemStageAluOutput || shouldForwardRegisterRsWithMemStageMemoryData;
	assign debug_shouldForwardRegisterRt = shouldForwardRegisterRtWithExStageAluOutput || shouldForwardRegisterRtWithMemStageAluOutput || shouldForwardRegisterRtWithMemStageMemoryData;

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
        .Wt_addr(wb_registerWriteAddress[4:0]), 
        .Wt_data(wb_writeRegData[31:0]), 
        .rdata_A(rdata_A[31:0]), 
        .rdata_B(rdata_B[31:0])
    );

    wire [2:0] cp_oper,cause;
    wire [4:0] addr_r,addr_w;
    wire [31:0] data_readFromCP0,data_writeToCP0;

    assign addr_r[4:0] = instruction[15:11];
    assign addr_w[4:0] = instruction[15:11];
    assign data_writeToCP0[31:0] = finalRt[31:0];

    cp0 cp0Instance (
        .clk(clk), 
        // .debug_addr_cp0(debug_addr_cp0), 
        // .debug_data_cp0(debug_data_cp0), 
        .cp_oper(cp_oper[2:0]), 
        .addr_r(addr_r[4:0]), 
        .addr_w(addr_w[4:0]), 
        .data_readFromCP0(data_readFromCP0[31:0]), 
        .data_writeToCP0(data_writeToCP0[31:0]), 
        .rst(rst), 
        .cause({outOfMemory,overflow,undefined}), 
        .interruptSignal(interruptSignal[2:0]), 
        .except_ret_addr(instruction[31:0]),  // id_instruction is the return address
        .epc_ctrl(epc_ctrl), 
        .jumpAddressExcept(jumpAddressExcept[31:0]), 
        .exceptClear(exceptClear)
    );

endmodule
