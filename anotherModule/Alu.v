
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
`define ALU_SLTIU 12      //12
`define ALU_SLT  13      //12
`define ALU_MUL 14
`define ALU_NONE 15


module Alu (
    input [31:0] inputA,
    input [31:0] inputB,
    input [3:0] operation,
    output [31:0] result
    //output  
	);
    wire [32:0]A_up = {inputA[31],inputA[31:0]};
    wire [32:0]B_up = {inputB[31],inputB[31:0]};
    wire [32:0]A_zeroUp = {1'b0,inputA[31:0]};
    wire [32:0]B_zeroUp = {1'b0,inputB[31:0]};

    wire sltResult,sltResultu;
    wire [63:0] sraResutl;

    assign sltResult = ($signed(A_up) - $signed(B_up)) < 0 ? 1 : 0;
    assign sltResultu = ($signed(A_zeroUp) - $signed(B_zeroUp)) < 0 ? 1 : 0;
    assign sraResutl = {{32{inputB[31]}},inputB[31:0]} >> inputA;

	assign result =
			operation == `ALU_ADD ? $signed(inputA) + $signed(inputB)
			: operation == `ALU_ADDU ? inputA + inputB
			: operation == `ALU_SUB ? $signed(inputA) - $signed(inputB)
			: operation == `ALU_SUBU ? inputA - inputB
			: operation == `ALU_AND ? inputA & inputB
			: operation == `ALU_OR ? inputA | inputB
			: operation == `ALU_XOR ? inputA ^ inputB
			//: operation == `ALU_NOR ? ~(inputA | inputB)
			: operation == `ALU_SLL ? inputB << inputA
			: operation == `ALU_SRL ? inputB >> inputA
			//: operation == `ALU_SRA ? $signed(inputB) >>> inputA
            : operation == `ALU_SRA ? sraResutl[31:0]
            : operation == `ALU_LUI ? {inputB[15:0],16'b0}
            : operation == `ALU_SLTIU ? {31'b0,sltResultu}
            : operation == `ALU_SLT ? {31'b0,sltResult}
            : operation == `ALU_MUL ? inputA * inputB 
			: 32'b0;
endmodule
