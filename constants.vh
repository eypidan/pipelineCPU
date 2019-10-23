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

`define NaN {1'b1, 8'b1111_1111, 1'b1, 22'd0}
`define INF {1'b0, 8'b1111_1111, 1'b0, 22'd0}
`define SIGN 31
`define EXPO 30:23
`define MANT 22:0