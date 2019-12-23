`timescale 1ns / 1ps
`define DEBUG
//ALU
`define ALU_ADD  0  //0
`define ALU_ADDU 1
`define ALU_SUB  2
`define ALU_SUBU  3 //3
`define ALU_AND  4
`define ALU_OR   5
`define ALU_XOR  6
`define ALU_NOR  7
`define ALU_SLL  8
`define ALU_SRL  9
`define ALU_SRA  10
`define ALU_LUI  11
`define ALU_SLTIU 12      //12
`define ALU_SLT  13      //12
`define ALU_MUL 14
`define ALU_NONE 15

//  ==== OPcode ====
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
`define CODE_LB 32
`define CODE_LBU 36
`define CODE_SLTIU 11
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
`define FUNC_SLTU 43
`define FUNC_SLL 0
`define FUNC_SLLV 4
`define FUNC_SRLV 6
`define FUNC_SRL 2 
`define FUNC_SRA 3
`define FUNC_JR 8



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
    output swSignalAndLastRtEqualCurrentRt
    );

    
    wire shouldJumpOrBranch_but_wait;
    wire [5:0]OPcode = instruction[31:26];
    wire [5:0]func = instruction[5:0];
    wire isRType = (OPcode[5:0] == `CODE_R_TYPE );
 
    wire [4:0]rs = instruction[25:21]; 
    wire [4:0]rt = instruction[20:16];
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
        : func == `FUNC_NOR ? `ALU_NOR
        : func == `FUNC_SLT ? `ALU_SLT
        : func == `FUNC_SLTU ? `ALU_SLTIU
        : func == `FUNC_SLL ? `ALU_SLL
        : func == `FUNC_SRL ? `ALU_SRL
        : func == `FUNC_SLLV ?`ALU_SLL
        : func == `FUNC_SRA ? `ALU_SRA
        : func == `FUNC_SRLV ? `ALU_SRL
		  : `ALU_NONE
        )
		  : OPcode == `CODE_ADDI ? `ALU_ADD
        : OPcode == `CODE_ANDI ? `ALU_AND
        : OPcode == `CODE_ADDIU ? `ALU_ADDU
        : OPcode == `CODE_ORI ? `ALU_OR
        : OPcode == `CODE_BEQ ? `ALU_SUB
        : OPcode == `CODE_BNE ? `ALU_SUB
        : OPcode == `CODE_LW ? `ALU_ADD
        : OPcode == `CODE_LB ? `ALU_ADD
        : OPcode == `CODE_LBU ? `ALU_ADD
        : OPcode == `CODE_SW ? `ALU_ADD
        : OPcode == `CODE_LUI ? `ALU_LUI  
        : OPcode == `CODE_SLTI ? `ALU_SLT
        : OPcode == `CODE_SLTIU ? `ALU_SLTIU    
        : OPcode == `CODE_XORI ? `ALU_XOR
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
        || OPcode == `CODE_ADDIU
        || OPcode == `CODE_ORI
        || OPcode == `CODE_XORI
        || OPcode == `CODE_LUI
        || OPcode == `CODE_LW
        || OPcode == `CODE_LBU
        || OPcode == `CODE_LB
        || OPcode == `CODE_SW
        || OPcode == `CODE_SLTI
        || OPcode == `CODE_SLTIU
        ) && !jal;

    //determine in WB stage write to rt or rd
    assign writeToRtOrRd =  // while this signal = 1, write to rt
        OPcode == `CODE_ADDI 
        || OPcode == `CODE_XORI
        || OPcode == `CODE_ADDIU
        || OPcode == `CODE_ANDI
        || OPcode == `CODE_ORI
        || OPcode == `CODE_LW
        || OPcode == `CODE_LB
        || OPcode == `CODE_LBU
        || OPcode == `CODE_LUI
        || OPcode == `CODE_SLTI
        || OPcode == `CODE_SLTIU;

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
                || func == `FUNC_SLTU
				|| func == `FUNC_SLL
				|| func == `FUNC_SRL
				|| func == `FUNC_SRA
                || func == `FUNC_SLLV
				|| func == `FUNC_SRLV
			)) || jal ||  writeToRtOrRd) && (instruction != 0); //BUG ABOUT SLL $ZERO $ZERO 0x0

    //deteremine if write mem
    assign ifWriteMem = OPcode == `CODE_SW;

    //determine use LW data or Alu result to write back to REG File
    assign memOutOrAluOutWriteBackToRegFile = (OPcode == `CODE_LW)|| (OPcode == `CODE_LB) || (OPcode == `CODE_LBU);
    assign swSignalAndLastRtEqualCurrentRt = OPcode==`CODE_SW &&  rt[4:0] == ex_instruction[20:16];
    //use shamt[10:6] -> [31:0], input ALU input A
    assign whileShiftAluInput_A_UseShamt = isRType && 
        (func == `FUNC_SLL
        || func == `FUNC_SRL
        || func == `FUNC_SRA);
    

   
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

    

    `ifdef DEBUG
    assign debug_shouldJumpOrBranch = shouldJumpOrBranch;
    assign debug_shouldBranch = shouldBranch;
    assign debug_jump = jump;
    assign debug_id_instruction[31:0] = instruction[31:0];
    assign debug_willExStageWriteRs = willExStageWriteRs;
    `endif

endmodule

// output wire rsDataBeExeStageAluOutput, // rs here indicate the final output data from 4-1 selector(register rs output) 
// output wire rsDataBeMemStageAluOutput,
// output wire rsDataBeMemStageMemOutput,
// output wire rtDataBeExeStageAluOutput, // rt here indicate the final output data from 4-1 selector(register rt output) 
// output wire rtDataBeMemStageAluOutput,
// output wire rtDataBeMemStageMemOutput,