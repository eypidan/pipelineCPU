`timescale 1ns / 1ps

`include "constants.vh"

module pipeLineCPU_ctrl(
    input wire [31:0] instruction,
    input wire MIO_ready,
    input wire zero,
    output jal,
    output jump,
    output jumpRs,
    output writeRegister,
    output whichWriteRegister,
    output [3:0]ALU_Opeartion,
    output regRtOrImm,
    output shift,
    output zeroOrSignExtention,
    output writeToRtOrRd,
    output rsDataBeExeStageAluOutput, // rs here indicate the final output data from 4-1 selector(register rs output) 
    output rsDataBeMemStageAluOutput,
    output rsDataBeMemStageMemOutput,
    output rtDataBeExeStageAluOutput, // rt here indicate the final output data from 4-1 selector(register rt output) 
    output rtDataBeMemStageAluOutput,
    output rtDataBeMemStageMemOutput,
    output [25:0]jumpAddress,
    output shouldStall
    );

    wire [5:0]OPcode = instruction[31:26];
    wire [5:0]func = instruction[5:0];
    wire isRType = (OPcode[5:0] == `CODE_R_TYPE );

    //j and jal
    assign jump = (OPcode==`CODE_J || OPcode==`CODE_JAL );
    assign jumpAddress = instruction[25:0];
    assign jal = OPcode==`CODE_JAL;
    //jr
    assign jumpRs = isRType && (func == `FUNC_JR);

    //ALU_OP_code
    assign ALU_Opeartion = jal ? `ALU_ADD : isRType ? (
        func == `FUNC_ADD ? `ALU_ADD
        : func == `FUNC_ADDU ? `ALU_ADDU
        : func == `FUNC_SUB ? `ALU_SUB
        : func == `FUNC_SUBU? `ALU_SUBU
        : func == `FUNC_AND ? `ALU_AND
        : func == `FUNC_OR ? `ALU_OR
        : func == `FUNC_XOR ? `ALU_XOR
        : func == `FUNC_SLT ? `ALU_SUB
        : func == `FUNC_SLL ? `ALU_SLL
        : func == `FUNC_SRL ? `ALU_SRL
        ) 
        : OPcode == `CODE_ADDI ? `ALU_ADD
        : OPcode == `CODE_ANDI ? `ALU_AND
        : OPcode == `CODE_ORI ? `ALU_OR
        : OPcode == `CODE_BEQ ? `ALU_SUB
        : OPcode == `CODE_BNE ? `ALU_SUB
        : OPcode == `CODE_LW ? `ALU_ADD
        : OPcode == `CODE_SW ? `ALU_ADD
        : OPcode == `CODE_LUI ? `ALU_SLL  // ????

    //zeroOrSignExtention
    assign zeroOrSignExtention = 
        (OPcode == `CODE_ANDI 
        || OPcode == `CODE_ORI 
        || OPcode == `CODE_XORI 
        || OPcode == `CODE_ANDI ); // this sigal == 1, zero extention

    
endmodule
