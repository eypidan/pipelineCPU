`timescale 1ns / 1ps

module IdStage (
		input clk,
		input rst,
		input [31:0] pc_4,
		input [31:0] instruction,
        input wb_RegWrite,  //wb_ means from wb
        input [4:0]wb_writeRegAddr,
        input [31:0]wb_writeRegData,
        output mem_write,
        output [2:0]ALU_Control,
        output RegWrite,
        
	);

    wire MIO_ready; // useless for now
    wire [31:0]rdata_A,rdata_B,dataOut1,dataOut2;

    pipeLineCPU_ctrl CPU_Control_inst (
        .OPcode(instruction[31:26]), 
        .Fun(instruction[5:0]), 
        .MIO_ready(MIO_ready), 
        .zero(ifRegisterRsRtEqual), 
        //output below
        .RegDst(RegDst), 
        .ALUSrc_B(ALUSrc_B), 
        .DatatoReg(DatatoReg), 
        .RegWrite(RegWrite),
        .ALU_Control(ALU_Control[2:0]), 
        .mem_w(mem_write),
        .Branch(Branch), 
        .Jal(Jal), 
        .DatatoRegExtra(DatatoRegExtra),
        .CPU_MIO(CPU_MIO), 
        .zeroExt(zeroExt),
        .ALUSrc_A(ALUSrc_A)
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

    MUX2T1_32 DataOut1_instance (
        .I0(rdata_A), 
        .I1(shiftResult), 
        .s(ALUSrc_A), 
        .o(dataOut1)
    );
        
    MUX2T1_32 DataOut2_instance (
        .I0(rdata_B), 
        .I1(imm_32), 
        .s(ALUSrc_B), 
        .o(dataOut2)
    );

    assign ifRegisterRsRtEqual = dataOut1==dataOut2; // equal -> ifRegisterRsRtEqual = 1

	wire isJumpIndex;	// JUMP
	wire [25:0] jumpIndex;	// address
	wire isJumpRegister;	// JR
	wire isRegisterRsRtEqual;	// RSRTEQU
	wire isJumpAndLink;	// JAL
	wire shouldSignElseZeroExtendImmediate;	// SEXT
	wire shouldWriteToRegisterRtElseRd;	// REGRT
	wire shouldForwardRegisterRsWithExStageAluOutput;
	wire shouldForwardRegisterRsWithMemStageAluOutput;
	wire shouldForwardRegisterRsWithMemStageMemoryData;
	wire shouldForwardRegisterRtWithExStageAluOutput;
	wire shouldForwardRegisterRtWithMemStageAluOutput;
	wire shouldForwardRegisterRtWithMemStageMemoryData;
	ControlUnit controlUnit (

		.instruction(instruction[31:0]),

		.isJumpIndex(isJumpIndex),
		.jumpIndex(jumpIndex[25:0]),
		.isJumpRegister(isJumpRegister),
		.isRegisterRsRtEqual(isRegisterRsRtEqual),
		.shouldJumpOrBranch(shouldJumpOrBranch),
		.isJumpAndLink(isJumpAndLink),

		.shouldSignElseZeroExtendImmediate(shouldSignElseZeroExtendImmediate),

		.aluOperation(aluOperation[3:0]),
		.shouldAluUseShiftAmountElseRegisterRsOrPc_4(shouldAluUseShiftAmountElseRegisterRsOrPc_4),
		.shouldAluUseImmeidateElseRegisterRtOrZero(shouldAluUseImmeidateElseRegisterRtOrZero),

		.shouldWriteRegister(shouldWriteRegister),
		.shouldWriteToRegisterRtElseRd(shouldWriteToRegisterRtElseRd),
		.shouldWriteMemoryElseAluOutputToRegister(shouldWriteMemoryElseAluOutputToRegister),

		.shouldWriteMemory(shouldWriteMemory),

		.ex_shouldWriteRegister(ex_shouldWriteRegister),
		.ex_registerWriteAddress(ex_registerWriteAddress[4:0]),
		.ex_shouldWriteMemoryElseAluOutputToRegister(ex_shouldWriteMemoryElseAluOutputToRegister),
		.mem_shouldWriteRegister(mem_shouldWriteRegister),
		.mem_registerWriteAddress(mem_registerWriteAddress[4:0]),
		.mem_shouldWriteMemoryElseAluOutputToRegister(mem_shouldWriteMemoryElseAluOutputToRegister),
		.shouldStall(shouldStall),
		.shouldForwardRegisterRsWithExStageAluOutput(shouldForwardRegisterRsWithExStageAluOutput),
		.shouldForwardRegisterRsWithMemStageAluOutput(shouldForwardRegisterRsWithMemStageAluOutput),
		.shouldForwardRegisterRsWithMemStageMemoryData(shouldForwardRegisterRsWithMemStageMemoryData),
		.shouldForwardRegisterRtWithExStageAluOutput(shouldForwardRegisterRtWithExStageAluOutput),
		.shouldForwardRegisterRtWithMemStageAluOutput(shouldForwardRegisterRtWithMemStageAluOutput),
		.shouldForwardRegisterRtWithMemStageMemoryData(shouldForwardRegisterRtWithMemStageMemoryData)
	);

	assign shiftAmount = {27'b0, instruction[10:6]};
	wire [15:0] instructionImmediate = instruction[15:0];
	assign immediate = {
			shouldSignElseZeroExtendImmediate ? {16{instructionImmediate[15]}} : 16'b0,
			instructionImmediate
	};

	wire [4:0] rs = instruction[25:21];
	wire [4:0] rt = instruction[20:16];
	wire [4:0] rd = instruction[15:11];

	assign registerWriteAddress =
			isJumpAndLink ? 5'd31
			: shouldWriteToRegisterRtElseRd ? rt : rd;

	wire [31:0] localRegisterRs;
	wire [31:0] localRegisterRt;
	RegisterFile registerFile (

		.clk(clk),
		.rst(rst),

		.readAddressA(rs[4:0]),
		.readDataA(localRegisterRs[31:0]),
		.readAddressB(rt[4:0]),
		.readDataB(localRegisterRt[31:0]),

		.shouldWrite(wb_shouldWriteRegister),
		.writeAddress(wb_registerWriteAddress[4:0]),
		.writeData(wb_registerWriteData[31:0]),

		.debug_registers(debug_registers[32 * 32 - 1 : 0])
	);

	wire [31:0] registerRs =
			shouldForwardRegisterRsWithExStageAluOutput ? ex_aluOutput
			: shouldForwardRegisterRsWithMemStageAluOutput ? mem_aluOutput
			: shouldForwardRegisterRsWithMemStageMemoryData ? mem_memoryData
			: localRegisterRs;
	wire [31:0] registerRt =
			shouldForwardRegisterRtWithExStageAluOutput ? ex_aluOutput
			: shouldForwardRegisterRtWithMemStageAluOutput ? mem_aluOutput
			: shouldForwardRegisterRtWithMemStageMemoryData ? mem_memoryData
			: localRegisterRt;
	assign debug_shouldForwardRegisterRs = shouldForwardRegisterRsWithExStageAluOutput || shouldForwardRegisterRsWithMemStageAluOutput || shouldForwardRegisterRsWithMemStageMemoryData;
	assign debug_shouldForwardRegisterRt = shouldForwardRegisterRtWithExStageAluOutput || shouldForwardRegisterRtWithMemStageAluOutput || shouldForwardRegisterRtWithMemStageMemoryData;

	assign registerRsOrPc_4 = isJumpAndLink ? pc_4 : registerRs;
	assign registerRtOrZero = isJumpAndLink ? 32'b0 : registerRt;

	assign isRegisterRsRtEqual = registerRs == registerRt;
	wire [31:0] jumpIndexPc = {pc_4[31:28], jumpIndex, 2'b0};
	wire [31:0] branchPc = pc_4 + {immediate[29:0], 2'b0};
	assign jumpOrBranchPc =
			isJumpRegister ? registerRs
			: isJumpIndex ? jumpIndexPc
			: branchPc;
endmodule
