//ALU
`define ALU_ADD  4'b0000
`define ALU_ADDU 4'b0001
`define ALU_SUB  4'b0010
`define ALU_SUBU 4'b0011
`define ALU_AND  4'b0100
`define ALU_OR   4'b0101
`define ALU_XOR  4'b0110
`define ALU_NOR  4'b0111
`define ALU_SLL  4'b1000
`define ALU_SRL  4'b1001
`define ALU_SRA  4'b1010
`define ALU_NONE 12

//  ==== OPcode ====
`define CODE_J 2
`define CODE_JAL 3
`define CODE_JR 
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

`define NaN {1'b1, 8'b1111_1111, 1'b1, 22'd0}
`define INF {1'b0, 8'b1111_1111, 1'b0, 22'd0}
`define SIGN 31
`define EXPO 30:23
`define MANT 22:0