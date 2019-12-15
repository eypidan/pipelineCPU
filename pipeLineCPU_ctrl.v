`timescale 1ns / 1ps
`define DEBUG
//ALU
`define ALU_ADD  4'b0000  //0
`define ALU_ADDU 4'b0001
`define ALU_SUB  4'b0010
`define ALU_SUBU 4'b0011  //3
`define ALU_AND  4'b0100
`define ALU_OR   4'b0101
`define ALU_XOR  4'b0110
`define ALU_NOR  4'b0111
`define ALU_SLL  4'b1000
`define ALU_SRL  4'b1001
`define ALU_SRA  4'b1010
`define ALU_LUI  11
`define ALU_SLTI 12      //12
`define ALU_SLT  13      //12
`define ALU_COP0 14
`define ALU_NONE 15

//  ==== OPcode ====
//cpu 0
`define CODE_COP0 16

`define CODE_J 2
`define CODE_JAL 3
`define CODE_R_TYPE 0   
//I op
`define CODE_ADDI 8
`define CODE_ADDIU 9
`define CODE_ANDI 12
`define CODE_BEQ 4
`define CODE_BNE 5
`define CODE_LUI 15
`define CODE_LW 35
`define CODE_ORI 13
`define CODE_SLTI 10
`define CODE_SW 43
`define CODE_XORI 14
//  ==== OPcode ====

//R function
`define FUNC_ADD 32
`define FUNC_ADDU 33
`define FUNC_SUB 34
`define FUNC_SUBU 35
`define FUNC_AND 36
`define FUNC_OR 37
`define FUNC_XOR 38
`define FUNC_NOR 39
`define FUNC_SLT 42
`define FUNC_SLL 0
`define FUNC_SRL 2 
`define FUNC_SRA 3
`define FUNC_JR 8

//cp0 function
`define FUNC_MFC 0
`define FUNC_MTC 4
`define OP_none 0
`define OP_mtc 1
`define OP_mfc 2
`define OP_eret 3

module pipeLineCPU_ctrl(
    `ifdef DEBUG
    output debug_shouldJumpOrBranch,
    output debug_shouldBranch,
    output debug_jump,
    output [31:0]debug_id_instruction,
    output debug_willExStageWriteRs,
    `endif
    input wire [31:0] instruction,
    input wire MIO_ready,
    input wire ifRsEqualRt,
    input wire ex_shouldWriteRegister,
    input wire mem_shouldWriteRegister,
    input wire [4:0] ex_registerWriteAddress,
    input wire [4:0] mem_registerWriteAddress,
    input [4:0]registerWriteAddress,
    //forwarding signal
    input ex_memOutOrAluOutWriteBackToRegFile,
    input mem_memOutOrAluOutWriteBackToRegFile,
    input [31:0] ex_instruction,

    output wire jal,
    output wire jump,
    output wire jumpRs,
    output wire shouldJumpOrBranch,
    output wire ifWriteRegsFile,
    output wire ifWriteMem,
    output wire writeToRtOrRd,
    output wire [3:0]ALU_Opeartion,
    output wire whileShiftAluInput_A_UseShamt,
    output wire memOutOrAluOutWriteBackToRegFile,
    output wire zeroOrSignExtention,
    output wire aluInput_B_UseRtOrImmeidate,
    output wire shouldStall, // this stall signal only contain data hazard
    //forwarding
    output shouldForwardRegisterRsWithExStageAluOutput,
    output shouldForwardRegisterRsWithMemStageAluOutput,
    output shouldForwardRegisterRsWithMemStageMemoryData,
    output shouldForwardRegisterRtWithExStageAluOutput,
    output shouldForwardRegisterRtWithMemStageAluOutput,
    output shouldForwardRegisterRtWithMemStageMemoryData,
    output swSignalAndLastRtEqualCurrentRt,
    //cp0 relative
    input  [31:0]ex_aluOutput,
    output [2:0]cp_oper,
    output cp0Instruction,
    output undefined,
    output outOfMemory
    );

    wire shouldJumpOrBranch_but_wait;
    wire [5:0]OPcode = instruction[31:26];
    wire [5:0]func = instruction[5:0];
    wire isRType = (OPcode[5:0] == `CODE_R_TYPE );
    
    wire isCOP0Type = (OPcode[5:0] == `CODE_COP0);
    wire [4:0]rs = instruction[25:21]; 
    wire [4:0]rt = instruction[20:16];
    wire [4:0]rd = instruction[15:11];
    //mfc0 and so others


    //j and jal
    assign jump = (OPcode==`CODE_J || OPcode==`CODE_JAL );
    assign jal = OPcode==`CODE_JAL;
    //jr
    assign jumpRs = isRType && (func == `FUNC_JR);
    //jump or branch
    wire shouldBranch = ( (OPcode == `CODE_BNE) && !ifRsEqualRt ) || ( (OPcode == `CODE_BEQ) && ifRsEqualRt);
    assign shouldJumpOrBranch_but_wait = jump || jumpRs || shouldBranch;
    
    //ALU_OP_code
    assign ALU_Opeartion = jal ? `ALU_ADD : isRType ? (
        func == `FUNC_ADD ? `ALU_ADD
        : func == `FUNC_ADDU ? `ALU_ADDU
        : func == `FUNC_SUB ? `ALU_SUB
        : func == `FUNC_SUBU? `ALU_SUBU
        : func == `FUNC_AND ? `ALU_AND
        : func == `FUNC_OR ? `ALU_OR
        : func == `FUNC_XOR ? `ALU_XOR
        : func == `FUNC_SLT ? `ALU_SLT
        : func == `FUNC_SLL ? `ALU_SLL
        : func == `FUNC_SRL ? `ALU_SRL
		  : `ALU_NONE
        ) : isCOP0Type ? `ALU_COP0
		: OPcode == `CODE_ADDI ? `ALU_ADD
        : OPcode == `CODE_ANDI ? `ALU_AND
        : OPcode == `CODE_ORI ? `ALU_OR
        : OPcode == `CODE_BEQ ? `ALU_SUB
        : OPcode == `CODE_BNE ? `ALU_SUB
        : OPcode == `CODE_LW ? `ALU_ADD
        : OPcode == `CODE_SW ? `ALU_ADD
        : OPcode == `CODE_LUI ? `ALU_LUI  // ????
        : OPcode == `CODE_SLTI ? `ALU_SLTI
        : `ALU_NONE;

    //determine imm'sextention
    assign zeroOrSignExtention = 
        (OPcode == `CODE_ANDI 
        || OPcode == `CODE_ORI 
        || OPcode == `CODE_XORI 
        || OPcode == `CODE_ANDI 
        || OPcode == `CODE_LUI); // this sigal == 1, zero extention !!!! diff with zhangHaiCPU

    //determine ALU B input use rt output or imm extention
    assign aluInput_B_UseRtOrImmeidate = (
        OPcode == `CODE_ADDI
        || OPcode == `CODE_ANDI
        || OPcode == `CODE_ORI
        || OPcode == `CODE_XORI
        || OPcode == `CODE_LUI
        || OPcode == `CODE_LW
        || OPcode == `CODE_SW
        || OPcode == `CODE_SLTI
        ) && !jal;

    //determine in WB stage write to rt or rd
    assign writeToRtOrRd =  // while this signal = 1, write to rt
        OPcode == `CODE_ADDI 
        || OPcode == `CODE_XORI
        || OPcode == `CODE_ANDI
        || OPcode == `CODE_ORI
        || OPcode == `CODE_LW
        || OPcode == `CODE_LUI
        || OPcode == `CODE_SLTI;

    //determine if need to write Register File
    assign ifWriteRegsFile = ((isRType && (
				func == `FUNC_ADD
				|| func == `FUNC_ADDU
				|| func == `FUNC_SUB
				|| func == `FUNC_SUBU
				|| func == `FUNC_AND
				|| func == `FUNC_OR
				|| func == `FUNC_XOR
				|| func == `FUNC_NOR
				|| func == `FUNC_SLT
				|| func == `FUNC_SLL
				|| func == `FUNC_SRL
				|| func == `FUNC_SRA
			)) || jal ||  writeToRtOrRd) && (instruction != 0); //BUG ABOUT SLL $ZERO $ZERO 0x0

    //deteremine if write mem
    assign ifWriteMem = OPcode == `CODE_SW;

    //determine use LW data or Alu result to write back to REG File
    assign memOutOrAluOutWriteBackToRegFile = OPcode == `CODE_LW;
    assign swSignalAndLastRtEqualCurrentRt = OPcode==`CODE_SW &&  rt[4:0] == ex_instruction[20:16];
    //use shamt[10:6] -> [31:0], input ALU input A
    assign whileShiftAluInput_A_UseShamt = isRType && 
        (func == `FUNC_SLL
        || func == `FUNC_SRL);
    

   
    //deal with control hazard
        // shouldJumpOrBranch have already be calculated
    //deal with data hazard
    wire willExStageWriteRs = ex_shouldWriteRegister && ex_registerWriteAddress == rs;
    wire willExStageWriteRt = ex_shouldWriteRegister && ex_registerWriteAddress == rt && registerWriteAddress != rt;
    
    //
    wire willMemStageWriteRs = mem_shouldWriteRegister && mem_registerWriteAddress == rs;
    wire willMemStageWriteRt = mem_shouldWriteRegister && mem_registerWriteAddress == rt;

    //assign shouldStall =  willExStageWriteRs || willExStageWriteRt || willMemStageWriteRs ||willMemStageWriteRt;
    assign shouldStall = ( willExStageWriteRs || willExStageWriteRt) && ex_memOutOrAluOutWriteBackToRegFile && !(ex_memOutOrAluOutWriteBackToRegFile && swSignalAndLastRtEqualCurrentRt);
    //(ex_memOutOrAluOutWriteBackToRegFilef && swSignalAndLastRtEqualCurrentRt) is current instruction is sw and last instruction is lw

    assign shouldJumpOrBranch = shouldJumpOrBranch_but_wait & (!shouldStall); //when datahazard is finished(should stall), and then  we can jump
    assign shouldForwardRegisterRsWithExStageAluOutput   = willExStageWriteRs  && !ex_memOutOrAluOutWriteBackToRegFile;
	assign shouldForwardRegisterRsWithMemStageAluOutput  = willMemStageWriteRs && !mem_memOutOrAluOutWriteBackToRegFile;
	assign shouldForwardRegisterRsWithMemStageMemoryData = willMemStageWriteRs && mem_memOutOrAluOutWriteBackToRegFile;//mem_memOutOrAluOutWriteBackToRegFile = 1,lw
	assign shouldForwardRegisterRtWithExStageAluOutput   = willExStageWriteRt  && !ex_memOutOrAluOutWriteBackToRegFile;
	assign shouldForwardRegisterRtWithMemStageAluOutput  = willMemStageWriteRt && !mem_memOutOrAluOutWriteBackToRegFile;
	assign shouldForwardRegisterRtWithMemStageMemoryData = willMemStageWriteRt && mem_memOutOrAluOutWriteBackToRegFile;

    //assign wire about cp0
    // wire isJType = (OPcode[5:0] == `CODE_J || OPcode[5:0] == `CODE_JAL );
    // wire isIType = OPcode[5:0] == `CODE_ADDI || `CODE_ADDIU || `CODE_ANDI || `CODE_BEQ || `CODE_BNE || 
    //assign undefined = (!isRType) && (!isCOP0Type) && (!isItype) && (!isJtype);

    assign undefined = (ALU_Opeartion == `ALU_NONE) && (!jump);
    assign outOfMemory = (ex_instruction[31:26] == `CODE_LW 
    || ex_instruction[31:26] == `CODE_SW) 
    && (ex_aluOutput > 312);  // 312 is the size of data_ram
    
    assign cp_oper = (rs == `FUNC_MFC ? `OP_mfc
    : rs == `FUNC_MTC ? `OP_mtc
    : instruction[25] == 1 ? `OP_eret
    : `OP_none
    ) & {3{isCOP0Type}};
    assign cp0Instruction = isCOP0Type && (cp_oper == `OP_mfc);
    //010000 00000 10000 01100 00000000 000 mfc
    // COP0  MF    rt    rd, gpr[rt] = cpr[rd]

    //010000 00100 10000 00011 00000000 000 mtc
    //COP0   MF    rt    rd, cpr[rd] = gpr[rt]

    `ifdef DEBUG
    assign debug_shouldJumpOrBranch = shouldJumpOrBranch;
    assign debug_shouldBranch = shouldBranch;
    assign debug_jump = jump;
    assign debug_id_instruction[31:0] = instruction[31:0];
    assign debug_willExStageWriteRs = willExStageWriteRs;
    `endif

endmodule
