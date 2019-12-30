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
    output [31:0] debug_ex_pc,
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
    output debug_wb_ifWriteRegsFile,
    //forwarding 
    output debug_shouldForwardRegisterRs,
    output debug_shouldForwardRegisterRt,
    output debug_useForwardingDataFromMemData,
    //cp0 relative
    output [2:0] debug_cp0_cause,
    output [2:0] debug_cp0_cp_oper,
    output [2:0] debug_cp0_interruptSignal,
    output [31:0] debug_cp0_jumpAddressExcept,
    output [31:0] debug_cp0_ehb_reg,
    output [31:0] debug_cp0_epc_reg,
    output [31:0] debug_cp0_cause_reg,
    output [31:0] debug_cp0_status_reg,
    output debug_exception,
    output debug_interrupt,
    output [31:0] debug_id_finalRt,
    output debug_cp0_epc_ctrl,
    output debug_eret_clearSignal,
    output [2:0]debug_cp0_ring,
    output [31:0]debug_cp0_except_ret_addr,
	`endif
	//interrupt Signal
	input [2:0]interruptSignal,
    input cpu_en,
    input [31:0]instruction_in,
    input [31:0]Data_in,
    input rst,
    input clk,
    input instRomStall,
    input dataRamStall,
    output mem_ifWriteMem,
    output CPU_MIO,
    output [31:0]Address_out,
    output [31:0]PC_out,
    output [31:0]Data_out
);
    
    wire [31:0] id_pc;
    wire [31:0] ex_pc;
    wire [31:0] mem_pc;
    wire [31:0] wb_pc;
    

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
    
    // wire [31:0] mem_writeDataToDataRAM;

    wire [31:0] wb_instruction;
    wire [31:0] wb_memoryData;
    wire [31:0] wb_aluOutput;    
    wire [4:0]  wb_registerWriteAddress;
    //forwarding
    wire id_swSignalAndLastRtEqualCurrentRt,ex_swSignalAndLastRtEqualCurrentRt;
    wire [31:0] ex_writeDataToDataRAM;
  // debug
	`ifdef DEBUG
	wire [31:0] debug_data_reg;
    //instruction
    wire [31:0] debug_ex_instruction;
    wire [31:0] debug_mem_instruction;
	reg  [31:0] debug_data_signal;
    assign debug_if_instruction[31:0] = instruction_in[31:0];
    assign debug_wb_instruction[31:0]  = wb_instruction[31:0]; 
    assign debug_mem_instruction[31:0] = mem_instruction[31:0];
    assign debug_ex_instruction[31:0]  = ex_instruction[31:0];
    assign debug_ex_pc[31:0] = ex_pc[31:0];
    assign debug_nextPc[31:0] = nextPc[31:0];
    //id stage  
    wire [4:0] debug_id_registerWriteAddress;
    assign debug_shouldStall = shouldStall;
    assign debug_id_shouldJumpOrBranch = id_shouldJumpOrBranch;
    assign debug_id_instruction=id_instruction[31:0];
    assign debug_id_pc_4[31:0] = id_pc_4[31:0];
    assign debug_id_registerWriteAddress[4:0] = id_registerWriteAddress[4:0];
    //exstage
    wire [31:0] debug_aluInputA;
    wire [31:0] debug_aluInputB;
    wire [3:0] debug_ex_aluOperation;
    assign debug_ex_ifWriteRegsFile = ex_ifWriteRegsFile;
    //mem
    wire [31:0] mem_aluOutput;
    //wb stage
    assign debug_wb_registerWriteAddress[4:0] = wb_registerWriteAddress[4:0];
    assign debug_wb_ifWriteRegsFile = wb_ifWriteRegsFile;    
    //cp0 need 
    wire [31:0] jumpAddressExcept;  

    wire [4:0] addr_rs ;
    wire [4:0] addr_rt ;
    assign  addr_rs[4:0] =  instruction_in[25:21];
    assign  addr_rt[4:0] = instruction_in[20:16];
    assign debug_eret_clearSignal = eret_clearSignal;
    
	always @(posedge clk) begin
		case (debug_addr[4:0])
			0: debug_data_signal <= PC_out[31:0];
			1: debug_data_signal <= instruction_in[31:0];
			2: debug_data_signal <= id_pc[31:0];
			3: debug_data_signal <= id_instruction[31:0];
			4: debug_data_signal <= ex_pc[31:0];
			5: debug_data_signal <= ex_instruction[31:0];
			6: debug_data_signal <= mem_pc[31:0];
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
    //cp0 relative
    assign debug_cp0_epc_ctrl = epc_ctrl;
    assign debug_cp0_except_ret_addr[31:0] = id_pc_4[31:0] - 8;
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
        .epc_ctrl(epc_ctrl),
        .jumpAddressExcept(jumpAddressExcept[31:0]),
        .pc_4(if_pc_4[31:0]), 
        .nextPc(nextPc[31:0])
    );
     
    IfIdRegisters U2 (
        .clk(clk), 
        .rst(rst), 
        .cpu_en(cpu_en),
        .eret_clearSignal(eret_clearSignal),
        .id_shouldStall(shouldStall),
        .id_shouldJumpOrBranch(id_shouldJumpOrBranch),
        .if_pc_4(if_pc_4[31:0]), 
        .if_instruction(instruction_in[31:0]), 
        .if_pc(PC_out[31:0]),
        .id_pc_4(id_pc_4[31:0]), 
        .id_instruction(id_instruction[31:0]),
        .id_pc(id_pc[31:0]),
        //cp0 releative
        .exceptClear(exceptClear)
    );
   

    IdStage U3 (
        `ifdef DEBUG
        .debug_addr(debug_addr[4:0]),
        .debug_data_reg(debug_data_reg[31:0]),
        .debug_shouldBranch(debug_shouldBranch),
        .debug_jump(debug_jump),
        .debug_willExStageWriteRs(debug_willExStageWriteRs),
        .debug_id_ifWriteRegsFile(debug_id_ifWriteRegsFile),
        .debug_id_jumpAddress(debug_id_jumpAddress[31:0]),
        .debug_id_branchAddress(debug_id_branchAddress[31:0]),
        .debug_shouldForwardRegisterRs(debug_shouldForwardRegisterRs),
        .debug_shouldForwardRegisterRt(debug_shouldForwardRegisterRt),
        //cp0 relative
        .debug_cp0_cause(debug_cp0_cause[2:0]),
        .debug_cp0_cp_oper(debug_cp0_cp_oper[2:0]),
        .debug_cp0_interruptSignal(debug_cp0_interruptSignal[2:0]),
        .debug_cp0_jumpAddressExcept(debug_cp0_jumpAddressExcept[31:0]),
        .debug_cp0_ehb_reg(debug_cp0_ehb_reg[31:0]),
        .debug_cp0_epc_reg(debug_cp0_epc_reg[31:0]),
        .debug_cp0_cause_reg(debug_cp0_cause_reg[31:0]),
        .debug_cp0_status_reg(debug_cp0_status_reg[31:0]),
        .debug_exception(debug_exception),
        .debug_interrupt(debug_interrupt),
        `endif
        .cpu_en(cpu_en),
        .clk(clk), 
        .rst(rst), 
        .pc_4(id_pc_4[31:0]), 
        .instruction(id_instruction[31:0]), 
        .id_pc(id_pc[31:0]),
        .ex_pc(ex_pc[31:0]),
        .wb_RegWrite(wb_ifWriteRegsFile), 
        .wb_registerWriteAddress(wb_registerWriteAddress[4:0]), 
        .wb_writeRegData(wb_writeRegData[31:0]), 
        .ex_shouldWriteRegister(ex_ifWriteRegsFile), 
        .mem_shouldWriteRegister(mem_ifWriteRegsFile), 
        .ex_registerWriteAddress(ex_registerWriteAddress[4:0]), 
        .mem_registerWriteAddress(mem_registerWriteAddress[4:0]), 
        //forwarding input signal
        .ex_memOutOrAluOutWriteBackToRegFile(ex_memOutOrAluOutWriteBackToRegFile),
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile),
        .ex_aluOutput(ex_aluOutput[31:0]),
        .mem_aluOutput(mem_aluOutput[31:0]),
        .mem_memoryData(Data_in[31:0]),
        .ex_instruction(ex_instruction[31:0]),

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
        .shouldStall(shouldStall),
        .swSignalAndLastRtEqualCurrentRt(id_swSignalAndLastRtEqualCurrentRt),
        //cp0 relative signal
        .ex_undefined(ex_undefined),
        .ex_overflow(ex_overflow),
        .interruptSignal(interruptSignal[2:0]),
        .epc_ctrl(epc_ctrl),
        .id_undefined(id_undefined),
        .jumpAddressExcept(jumpAddressExcept[31:0]),
        .exceptClear(exceptClear),
        .eret_clearSignal(eret_clearSignal),
        .debug_id_finalRt(debug_id_finalRt[31:0]),
        .debug_cp0_ring(debug_cp0_ring[2:0])
    );

    IdExRegisters U4 (
        //cp0 releative
        .exceptClear(exceptClear),
        .eret_clearSignal(eret_clearSignal),
        .clk(clk), 
        .rst(rst), 
        .cpu_en(cpu_en),
        .id_instruction(id_instruction[31:0]),
        .id_pc(id_pc[31:0]),
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
        .id_swSignalAndLastRtEqualCurrentRt(id_swSignalAndLastRtEqualCurrentRt),
        .id_undefined(id_undefined),
        .ex_instruction(ex_instruction[31:0]),
        .ex_pc(ex_pc[31:0]),
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
        .ex_jumpOrBranchPc(ex_jumpOrBranchPc[31:0]),
        .ex_swSignalAndLastRtEqualCurrentRt(ex_swSignalAndLastRtEqualCurrentRt),
        .ex_undefined(ex_undefined)
    );

    ExStage U5 (
        `ifdef DEBUG
        .debug_ex_aluOutput(debug_ex_aluOutput[31:0]),
        .debug_aluInputA(debug_aluInputA[31:0]),
        .debug_aluInputB(debug_aluInputB[31:0]),
        .debug_ex_aluOperation(debug_ex_aluOperation[3:0]),
        .debug_useForwardingDataFromMemData(debug_useForwardingDataFromMemData),
        `endif
        .shiftAmount(ex_shiftAmount[31:0]), 
        .immediate(ex_immediate[31:0]), 
        .aluOperation(ex_aluOperation[3:0]), 
        .whileShiftAluInput_A_UseShamt(ex_whileShiftAluInput_A_UseShamt), 
        .aluInput_B_UseRtOrImmeidate(ex_aluInput_B_UseRtOrImmeidate), 
        .registerRsOrPc_4(ex_registerRsOrPc_4[31:0]), 
        .registerRtOrZero(ex_registerRtOrZero[31:0]), 
        //lw-sw forwarding
        .ex_swSignalAndLastRtEqualCurrentRt(ex_swSignalAndLastRtEqualCurrentRt),
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile),
        .mem_memoryData(Data_in[31:0]),
        .aluOutput(ex_aluOutput[31:0]),
        .ex_writeDataToDataRAM(ex_writeDataToDataRAM[31:0]),
        //cp0 relative
        .ex_overflow(ex_overflow)
    );

    ExMemRegisters U6 ( //registerWriteAddress
    //cp0 releative
        .exceptClear(exceptClear), 
        .clk(clk), 
        .rst(rst), 
        .cpu_en(cpu_en),
        .ex_instruction(ex_instruction[31:0]),
        .ex_pc(ex_pc[31:0]),
        .ex_ifWriteRegsFile(ex_ifWriteRegsFile), 
        .ex_ifWriteMem(ex_ifWriteMem), 
        .ex_memOutOrAluOutWriteBackToRegFile(ex_memOutOrAluOutWriteBackToRegFile), 
        .ex_registerWriteAddress(ex_registerWriteAddress[4:0]), 
        .ex_aluOutput(ex_aluOutput[31:0]), 
        .ex_writeDataToDataRAM(ex_writeDataToDataRAM[31:0]), 
        .mem_instruction(mem_instruction[31:0]),
        .mem_pc(mem_pc[31:0]),
        .mem_ifWriteRegsFile(mem_ifWriteRegsFile), 
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile), 
        .mem_ifWriteMem(mem_ifWriteMem), 
        .mem_registerWriteAddress(mem_registerWriteAddress[4:0]), 
        .mem_aluOutput(mem_aluOutput[31:0]), // PASS sw/lw address to Data Ram
        .mem_writeDataToDataRAM(Data_out[31:0])
    );

    MemWbRegisters U7 (
        .clk(clk), 
        .rst(rst), 
        .cpu_en(cpu_en),
        .mem_instruction(mem_instruction[31:0]),
        .mem_pc(mem_pc[31:0]),
        .mem_ifWriteRegsFile(mem_ifWriteRegsFile), 
        .mem_memOutOrAluOutWriteBackToRegFile(mem_memOutOrAluOutWriteBackToRegFile), 
        .mem_registerWriteAddress(mem_registerWriteAddress[4:0]), 
        .mem_memoryData(Data_in[31:0]),  // mem_data out
        .mem_aluOutput(mem_aluOutput[31:0]), 
        .wb_instruction(wb_instruction[31:0]),
        .wb_pc(wb_pc[31:0]),
        .wb_ifWriteRegsFile(wb_ifWriteRegsFile), 
        .wb_memOutOrAluOutWriteBackToRegFile(wb_memOutOrAluOutWriteBackToRegFile), 
        .wb_registerWriteAddress(wb_registerWriteAddress[4:0]), 
        .wb_memoryData(wb_memoryData[31:0]), 
        .wb_aluOutput(wb_aluOutput[31:0])
    );

    assign Address_out[31:0] = mem_aluOutput[31:0];

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
