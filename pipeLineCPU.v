`timescale 1ns / 1ps

`define addr_rs instruction_in[25:21]
`define addr_rt instruction_in[20:16]


module pipeLineCPU(
    `ifdef DEBUG
	input  [5:0]debug_addr,
	output [31:0]debug_data,
	`endif
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
  // debug
	`ifdef DEBUG
	wire [31:0] debug_data_reg;
	reg [31:0] debug_data_signal;
	


	always @(posedge clk) begin
		case (debug_addr[4:0])
			0: debug_data_signal <= PC_out[31:0];
			1: debug_data_signal <= instruction_in[31:0];
			2: debug_data_signal <= 0;
			3: debug_data_signal <= 0;
			4: debug_data_signal <= 0;
			5: debug_data_signal <= 0;
			6: debug_data_signal <= 0;
			7: debug_data_signal <= 0;
			8: debug_data_signal <= {27'b0, addr_rs};
			9: debug_data_signal <= data_rs;
			10: debug_data_signal <= {27'b0, addr_rt};
			// 11: debug_data_signal <= data_rt;
			// 12: debug_data_signal <= data_imm;
			// 13: debug_data_signal <= opa;
			// 14: debug_data_signal <= opb;
			// 15: debug_data_signal <= alu_out;
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
	
	assign
		debug_data = debug_addr[5] ? debug_data_signal : debug_data_reg;
	`endif
	
    wire [31:0] nextPc;
    wire ex_shouldJumpOrBranch; //control hazard signal
	Pc U0 (
        .clk(clk), 
        .rst(rst), 
        .id_shouldStall(shouldStall),
        .ex_shouldJumpOrBranch(ex_shouldJumpOrBranch),
        .nextPc(nextPc[31:0]), 
        .pc(PC_out[31:0])
    );

    wire [31:0] if_pc_4;
    wire [31:0] id_jumpOrBranchPc; 
    wire [31:0] ex_jumpOrBranchPc;
    wire id_shouldJumpOrBranch;

    IfStage U1 (
        .clk(clk), 
        .pc(PC_out[31:0]), 
        .ex_shouldJumpOrBranch(ex_shouldJumpOrBranch), 
        .ex_jumpOrBranchPc(ex_jumpOrBranchPc[31:0]), 
        .pc_4(if_pc_4[31:0]), 
        .nextPc(nextPc[31:0])
    );


    wire [31:0] id_pc_4;
    wire [31:0] id_instruction;
     
    IfIdRegisters U2 (
        .clk(clk), 
        .rst(rst), 
        .id_shouldStall(shouldStall),
        .ex_shouldJumpOrBranch(ex_shouldJumpOrBranch), 
        .if_pc_4(if_pc_4[31:0]), 
        .if_instruction(instruction_in[31:0]), 
        .id_pc_4(id_pc_4[31:0]), 
        .id_instruction(id_instruction[31:0])
    );

    wire [31:0] id_shiftAmount;
    wire [31:0] id_immediate;
    wire [31:0] id_registerRsOrPc_4;
    wire [31:0] id_registerRtOrZero;
    wire [3:0] id_aluOperation; 
    wire [4:0] id_registerWriteAddress;
    wire [31:0] ex_shiftAmount;
    wire [31:0] ex_immediate;
    wire [31:0] ex_registerRsOrPc_4;
    wire [31:0] ex_registerRtOrZero;
    wire [3:0] ex_aluOperation;
    wire [4:0] ex_registerWriteAddress; //deal with data hazard, pass signal too 

    wire [31:0] wb_writeRegData;
    wire [4:0] mem_registerWriteAddress;
    
   
    IdStage U3 (
        `ifdef DEBUG
        debug_addr(debug_addr[4:0]),
        debug_data_reg(debug_data_reg[31:0]),
        `endif
        .clk(clk), 
        .rst(rst), 
        .pc_4(id_pc_4[31:0]), 
        .instruction(id_instruction[31:0]), 
        .wb_RegWrite(wb_ifWriteRegsFile), 
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
        .ALU_Opeartion(id_aluOperation[31:0]), 
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
        .id_shouldJumpOrBranch(id_shouldJumpOrBranch),
        .id_jumpOrBranchPc(id_jumpOrBranchPc[31:0]),
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
        .ex_shouldJumpOrBranch(ex_shouldJumpOrBranch),
        .ex_jumpOrBranchPc(ex_jumpOrBranchPc[31:0])
    );

    wire [31:0] ex_aluOutput;
    wire [31:0] mem_aluOutput;
    // wire [31:0] mem_registerRtOrZero;

    ExStage U5 (
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
        .ex_ifWriteRegsFile(ex_ifWriteRegsFile), 
        .ex_ifWriteMem(ex_ifWriteMem), 
        .ex_memOutOrAluOutWriteBackToRegFile(ex_memOutOrAluOutWriteBackToRegFile), 
        .ex_registerWriteAddress(ex_registerWriteAddress[4:0]), 
        .ex_aluOutput(ex_aluOutput[31:0]), 
        .ex_registerRtOrZero(ex_registerRtOrZero[31:0]), 
        .mem_ifWriteRegsFile(mem_ifWriteRegsFile), 
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile), 
        .mem_ifWriteMem(mem_ifWriteMem), 
        .mem_registerWriteAddress(mem_registerWriteAddress[4:0]), 
        .mem_aluOutput(Address_out[31:0]), // PASS sw/lw address to Data Ram
        .mem_registerRtOrZero(Data_out[31:0])
    );

    wire [31:0] wb_memoryData;
    wire [31:0] wb_aluOutput;    
    wire [4:0]  wb_registerWriteAddress;

    MemWbRegisters U7 (
        .clk(clk), 
        .rst(rst), 
        .mem_ifWriteRegsFile(mem_ifWriteRegsFile), 
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile), 
        .mem_registerWriteAddress(mem_registerWriteAddress[4:0]), 
        .mem_memoryData(Data_in[31:0]),  // mem_data out
        .mem_aluOutput(Address_out[31:0]), 
        .wb_ifWriteRegsFile(wb_ifWriteRegsFile), 
        .wb_memOutOrAluOutWriteBackToRegFile(wb_memOutOrAluOutWriteBackToRegFile), 
        .wb_registerWriteAddress(wb_registerWriteAddress[4:0]), 
        .wb_memoryData(wb_memoryData[31:0]), 
        .wb_aluOutput(wb_aluOutput[31:0])
    );

    WbStage U8 (
		.memOutOrAluOutWriteBackToRegFile(wb_memOutOrAluOutWriteBackToRegFile),
		.memoryData(wb_memoryData[31:0]),
		.aluOutput(wb_aluOutput[31:0]),
		.registerWriteData(wb_writeRegData[31:0])
	);
endmodule
