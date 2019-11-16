`timescale 1ns / 1ps

`define DEBUG
module pipeLineCPU(
    `ifdef DEBUG
	input  [5:0]debug_addr,
	output [31:0]debug_data,
    output [31:0]debug_nextPc,
    output [31:0]debug_ex_aluOutput,
    output debug_shouldStall,
    output debug_id_shouldJumpOrBranch,
    output debug_shouldBranch,
    output debug_jump,
    //instruction
    output [31:0]debug_if_instruction,
    output [31:0]debug_id_instruction,
    output [31:0]debug_ex_instruction,
    output [31:0]debug_mem_instruction,
    output [31:0]debug_wb_instruction,
    output debug_ex_ifWriteRegsFile,
    output debug_id_ifWriteRegsFile,
    //id stage
    output [4:0] debug_id_registerWriteAddress,
    output [31:0] debug_id_pc_4,
    output [31:0] id_jumpOrBranchPc,
    output [31:0] debug_id_jumpAddress,
    output [31:0] debug_id_branchAddress,
    //ex stage
    output [31:0]debug_aluInputA,
    output [31:0]debug_aluInputB,
    output [3:0]debug_ex_aluOperation,
    //wb stage
    output [31:0]debug_wb_memoryData,
    output [31:0]debug_wb_aluOutput,
    output [4:0]debug_wb_registerWriteAddress,
    output debug_memOutOrAluOutWriteBackToRegFile,
	`endif
    input cpu_en,
    input [31:0]instruction_in,
    input [31:0]Data_in,
    input rst,
    input clk,
    input MIO_ready,
    input INT,
    output mem_ifWriteMem,
    output CPU_MIO,
    output [31:0]Address_out,
    output [31:0]PC_out,
    output [31:0]Data_out
);

    wire [31:0] nextPc;
    wire [31:0] if_pc_4;
    wire [31:0] ex_jumpOrBranchPc;
    wire id_shouldJumpOrBranch;
    wire [31:0] id_pc_4;
    wire [31:0] id_instruction;

    wire [31:0] id_shiftAmount;
    wire [31:0] id_immediate;
    wire [31:0] id_registerRsOrPc_4;
    wire [31:0] id_registerRtOrZero;
    wire [3:0] id_aluOperation; 
    wire [4:0] id_registerWriteAddress;
    wire [31:0] ex_instruction;
    wire [31:0] ex_shiftAmount;
    wire [31:0] ex_immediate;
    wire [31:0] ex_registerRsOrPc_4;
    wire [31:0] ex_registerRtOrZero;
    wire [3:0] ex_aluOperation;
    wire [4:0] ex_registerWriteAddress; //deal with data hazard, pass signal too 

    wire [31:0] mem_instruction;
    wire [31:0] wb_writeRegData;
    wire [4:0] mem_registerWriteAddress;
    wire [31:0] ex_aluOutput;
    wire [31:0] mem_aluOutput;
    // wire [31:0] mem_registerRtOrZero;

    wire [31:0] wb_instruction;
    wire [31:0] wb_memoryData;
    wire [31:0] wb_aluOutput;    
    wire [4:0]  wb_registerWriteAddress;


  // debug
	`ifdef DEBUG
	wire [31:0] debug_data_reg;
    //instruction
    wire [31:0] debug_ex_instruction;
    wire [31:0] debug_mem_instruction;
	reg  [31:0] debug_data_signal;
    //id stage  
    wire [4:0] debug_id_registerWriteAddress;
    assign debug_id_pc_4[31:0] = id_pc_4[31:0];
    assign debug_id_registerWriteAddress[4:0] = id_registerWriteAddress[4:0];
    //exstage
    wire [31:0] debug_aluInputA;
    wire [31:0] debug_aluInputB;
    wire [3:0] debug_ex_aluOperation;
    //wb stage
    assign debug_wb_registerWriteAddress[4:0] = wb_registerWriteAddress[4:0];

    assign debug_if_instruction[31:0] = instruction_in[31:0];
    assign debug_wb_instruction[31:0]  = wb_instruction[31:0]; 
    assign debug_mem_instruction[31:0] = mem_instruction[31:0];
    assign debug_ex_instruction[31:0]  = ex_instruction[31:0];
    assign debug_nextPc[31:0] = nextPc[31:0];

    assign debug_shouldStall = shouldStall;
    assign debug_ex_ifWriteRegsFile = ex_ifWriteRegsFile;

    wire [4:0] addr_rs ;
    wire [4:0] addr_rt ;
    assign  addr_rs[4:0] =  instruction_in[25:21];
    assign  addr_rt[4:0] = instruction_in[20:16];

	always @(posedge clk) begin
		case (debug_addr[4:0])
			0: debug_data_signal <= PC_out[31:0];
			1: debug_data_signal <= instruction_in[31:0];
			2: debug_data_signal <= 0;
			3: debug_data_signal <= id_instruction[31:0];
			4: debug_data_signal <= 0;
			5: debug_data_signal <= ex_instruction[31:0];
			6: debug_data_signal <= 0;
			7: debug_data_signal <= mem_instruction[31:0];
			8: debug_data_signal <= {27'b0, addr_rs};
			//9: debug_data_signal <= data_rs;
			10: debug_data_signal <= {27'b0, addr_rt};
			// 11: debug_data_signal <= data_rt;
			// 12: debug_data_signal <= data_imm;
			// 13: debug_data_signal <= opa;
			// 14: debug_data_signal <= opb;
			15: debug_data_signal <= ex_aluOutput[31:0];
			16: debug_data_signal <= 0;
			17: debug_data_signal <= 0;
			// 18: debug_data_signal <= {19'b0, inst_ren, 7'b0, mem_ren, 3'b0, mem_wen};
			19: debug_data_signal <= Address_out[31:0];
			20: debug_data_signal <= Data_out[31:0];
			21: debug_data_signal <= Data_in[31:0];
			22: debug_data_signal <= {27'b0, wb_registerWriteAddress[4:0]};
			23: debug_data_signal <= wb_writeRegData[31:0];
			default: debug_data_signal <= 32'hFFFF_FFFF;
		endcase
	end
	
	assign	debug_data = debug_addr[5] ? debug_data_signal : debug_data_reg;
	`endif
	
    
	Pc U0 (
        .clk(clk), 
        .rst(rst), 
        .cpu_en(cpu_en),
        .id_shouldStall(shouldStall),
        .id_shouldJumpOrBranch(id_shouldJumpOrBranch),
        .nextPc(nextPc[31:0]), 
        .pc(PC_out[31:0])
    );

    IfStage U1 (
        .clk(clk), 
        .pc(PC_out[31:0]), 
        .id_shouldJumpOrBranch(id_shouldJumpOrBranch), 
        .id_jumpOrBranchPc(id_jumpOrBranchPc[31:0]), 
        .pc_4(if_pc_4[31:0]), 
        .nextPc(nextPc[31:0])
    );
     
    IfIdRegisters U2 (
        .clk(clk), 
        .rst(rst), 
        .cpu_en(cpu_en),
        .id_shouldStall(shouldStall),
        .id_shouldJumpOrBranch(id_shouldJumpOrBranch),
        .if_pc_4(if_pc_4[31:0]), 
        .if_instruction(instruction_in[31:0]), 
        .id_pc_4(id_pc_4[31:0]), 
        .id_instruction(id_instruction[31:0])
    );
   
    IdStage U3 (
        `ifdef DEBUG
        .debug_addr(debug_addr[4:0]),
        .debug_data_reg(debug_data_reg[31:0]),
        .debug_shouldJumpOrBranch(debug_id_shouldJumpOrBranch),
        .debug_shouldBranch(debug_shouldBranch),
        .debug_id_instruction(debug_id_instruction[31:0]),
        .debug_jump(debug_jump),
        .debug_willExStageWriteRs(debug_willExStageWriteRs),
        .debug_id_ifWriteRegsFile(debug_id_ifWriteRegsFile),
        .debug_id_jumpAddress(debug_id_jumpAddress[31:0]),
        .debug_id_branchAddress(debug_id_branchAddress[31:0]),
        `endif
        .clk(clk), 
        .rst(rst), 
        .pc_4(id_pc_4[31:0]), 
        .instruction(id_instruction[31:0]), 
        .wb_RegWrite(wb_ifWriteRegsFile & cpu_en), 
        .wb_writeRegAddr(wb_registerWriteAddress[4:0]), 
        .wb_writeRegData(wb_writeRegData[31:0]), 
        .ex_shouldWriteRegister(ex_ifWriteRegsFile), 
        .mem_shouldWriteRegister(mem_ifWriteRegsFile), 
        .ex_registerWriteAddress(ex_registerWriteAddress[4:0]), 
        .mem_registerWriteAddress(mem_registerWriteAddress[4:0]), 
        .jumpOrBranchPc(id_jumpOrBranchPc[31:0]), 
        .registerRtOrZero(id_registerRtOrZero[31:0]), 
        .registerRsOrPc_4(id_registerRsOrPc_4[31:0]), 
        .immediate(id_immediate[31:0]), 
        .registerWriteAddress(id_registerWriteAddress[4:0]), 
        .ALU_Opeartion(id_aluOperation[3:0]), 
        .shouldJumpOrBranch(id_shouldJumpOrBranch), 
        .ifWriteRegsFile(id_ifWriteRegsFile), 
        .ifWriteMem(id_ifWriteMem), 
        .whileShiftAluInput_A_UseShamt(id_whileShiftAluInput_A_UseShamt), 
        .memOutOrAluOutWriteBackToRegFile(id_memOutOrAluOutWriteBackToRegFile), 
        .aluInput_B_UseRtOrImmeidate(id_aluInput_B_UseRtOrImmeidate), 
        .shouldStall(shouldStall)
    );

    IdExRegisters U4 (
        .clk(clk), 
        .rst(rst), 
        .cpu_en(cpu_en),
        .id_instruction(id_instruction[31:0]),
        .id_shouldStall(shouldStall),
        .id_shiftAmount(id_shiftAmount[31:0]), 
        .id_immediate(id_immediate[31:0]), 
        .id_registerRsOrPc_4(id_registerRsOrPc_4[31:0]), 
        .id_registerRtOrZero(id_registerRtOrZero[31:0]), 
        .id_aluOperation(id_aluOperation[3:0]), 
        .id_registerWriteAddress(id_registerWriteAddress[4:0]), 
        .id_ifWriteRegsFile(id_ifWriteRegsFile), 
        .id_ifWriteMem(id_ifWriteMem), 
        .id_whileShiftAluInput_A_UseShamt(id_whileShiftAluInput_A_UseShamt), 
        .id_memOutOrAluOutWriteBackToRegFile(id_memOutOrAluOutWriteBackToRegFile), 
        .id_aluInput_B_UseRtOrImmeidate(id_aluInput_B_UseRtOrImmeidate), 
        .id_jumpOrBranchPc(id_jumpOrBranchPc[31:0]),
        .ex_instruction(ex_instruction[31:0]),
        .ex_shiftAmount(ex_shiftAmount[31:0]), 
        .ex_immediate(ex_immediate[31:0]), 
        .ex_registerRsOrPc_4(ex_registerRsOrPc_4[31:0]), 
        .ex_registerRtOrZero(ex_registerRtOrZero[31:0]), 
        .ex_aluOperation(ex_aluOperation[3:0]), 
        .ex_registerWriteAddress(ex_registerWriteAddress[4:0]), 
        .ex_ifWriteRegsFile(ex_ifWriteRegsFile), 
        .ex_ifWriteMem(ex_ifWriteMem), 
        .ex_whileShiftAluInput_A_UseShamt(ex_whileShiftAluInput_A_UseShamt), 
        .ex_memOutOrAluOutWriteBackToRegFile(ex_memOutOrAluOutWriteBackToRegFile), 
        .ex_aluInput_B_UseRtOrImmeidate(ex_aluInput_B_UseRtOrImmeidate),
        .ex_jumpOrBranchPc(ex_jumpOrBranchPc[31:0])
    );

    ExStage U5 (
        `ifdef DEBUG
        .debug_ex_aluOutput(debug_ex_aluOutput[31:0]),
        .debug_aluInputA(debug_aluInputA[31:0]),
        .debug_aluInputB(debug_aluInputB[31:0]),
        .debug_ex_aluOperation(debug_ex_aluOperation[3:0]),
        `endif
        .shiftAmount(ex_shiftAmount[31:0]), 
        .immediate(ex_immediate[31:0]), 
        .aluOperation(ex_aluOperation[3:0]), 
        .whileShiftAluInput_A_UseShamt(ex_whileShiftAluInput_A_UseShamt), 
        .aluInput_B_UseRtOrImmeidate(ex_aluInput_B_UseRtOrImmeidate), 
        .registerRsOrPc_4(ex_registerRsOrPc_4[31:0]), 
        .registerRtOrZero(ex_registerRtOrZero[31:0]), 
        .aluOutput(ex_aluOutput[31:0])
    );

    ExMemRegisters U6 ( //registerWriteAddress
        .clk(clk), 
        .rst(rst), 
        .cpu_en(cpu_en),
        .ex_instruction(ex_instruction[31:0]),
        .ex_ifWriteRegsFile(ex_ifWriteRegsFile), 
        .ex_ifWriteMem(ex_ifWriteMem), 
        .ex_memOutOrAluOutWriteBackToRegFile(ex_memOutOrAluOutWriteBackToRegFile), 
        .ex_registerWriteAddress(ex_registerWriteAddress[4:0]), 
        .ex_aluOutput(ex_aluOutput[31:0]), 
        .ex_registerRtOrZero(ex_registerRtOrZero[31:0]), 
        .mem_instruction(mem_instruction[31:0]),
        .mem_ifWriteRegsFile(mem_ifWriteRegsFile), 
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile), 
        .mem_ifWriteMem(mem_ifWriteMem), 
        .mem_registerWriteAddress(mem_registerWriteAddress[4:0]), 
        .mem_aluOutput(Address_out[31:0]), // PASS sw/lw address to Data Ram
        .mem_registerRtOrZero(Data_out[31:0])
    );

    MemWbRegisters U7 (
        .clk(clk), 
        .rst(rst), 
        .cpu_en(cpu_en),
        .mem_instruction(mem_instruction[31:0]),
        .mem_ifWriteRegsFile(mem_ifWriteRegsFile), 
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile), 
        .mem_registerWriteAddress(mem_registerWriteAddress[4:0]), 
        .mem_memoryData(Data_in[31:0]),  // mem_data out
        .mem_aluOutput(Address_out[31:0]), 
        .wb_instruction(wb_instruction[31:0]),
        .wb_ifWriteRegsFile(wb_ifWriteRegsFile), 
        .wb_memOutOrAluOutWriteBackToRegFile(wb_memOutOrAluOutWriteBackToRegFile), 
        .wb_registerWriteAddress(wb_registerWriteAddress[4:0]), 
        .wb_memoryData(wb_memoryData[31:0]), 
        .wb_aluOutput(wb_aluOutput[31:0])
    );

    WbStage U8 (
        `ifdef DEBUG
        .debug_wb_memoryData(debug_wb_memoryData[31:0]),
        .debug_wb_aluOutput(debug_wb_aluOutput[31:0]),
        .debug_memOutOrAluOutWriteBackToRegFile(debug_memOutOrAluOutWriteBackToRegFile),
        `endif
		.memOutOrAluOutWriteBackToRegFile(wb_memOutOrAluOutWriteBackToRegFile),
		.memoryData(wb_memoryData[31:0]),
		.aluOutput(wb_aluOutput[31:0]),
		.registerWriteData(wb_writeRegData[31:0])
	);

endmodule
