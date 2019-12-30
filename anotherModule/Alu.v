
`timescale 1ns / 1ps
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
`define ALU_SLTI 12      //12
`define ALU_SLT  13      //12
`define ALU_MUL 14
`define ALU_NONE 666

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


module Alu (
    input [31:0] inputA,
    input [31:0] inputB,
    input [3:0] operation,
    output [31:0] result
	);
    wire [32:0]A_up = {inputA[31],inputA[31:0]};
    wire [32:0]B_up = {inputB[31],inputB[31:0]};

    wire [32:0] sltResult;
    assign sltResult[32:0] = ($signed(A_up) - $signed(B_up)) < 0 ? 1 : 0;
    //assign sltResult[32:0] = ($signed(A_up) - $signed(B_up)) ;
	assign result =
			operation == `ALU_ADD ? $signed(inputA) + $signed(inputB)
			: operation == `ALU_ADDU ? inputA + inputB
			: operation == `ALU_SUB ? $signed(inputA) - $signed(inputB)
			: operation == `ALU_SUBU ? inputA - inputB
			: operation == `ALU_AND ? inputA & inputB
			: operation == `ALU_OR ? inputA | inputB
			: operation == `ALU_XOR ? inputA ^ inputB
			: operation == `ALU_NOR ? ~(inputA | inputB)
			: operation == `ALU_SLL ? inputB << inputA
			: operation == `ALU_SRL ? inputB >> inputA
			: operation == `ALU_SRA ? inputB >>> inputA
            : operation == `ALU_LUI ? {inputB[15:0],16'b0}
            : operation == `ALU_SLTI ? {31'b0,sltResult[0]}
            : operation == `ALU_SLT ? {31'b0,sltResult[0]}
            : operation == `ALU_MUL ? inputA * inputB 
			: 32'b0;
endmodule

