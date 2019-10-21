`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:50:02 10/14/2019 
// Design Name: 
// Module Name:    SCPU_More 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module SCPU_More(
    input [31:0]inst_in,
    input [31:0]Data_in,
    input reset,
    input clk,
    input MIO_ready,
    input INT,
    output mem_w,
    output CPU_MIO,
    output [31:0]Addr_out,
    output [31:0]PC_out,
    output [31:0]Data_out
    );
	 
	wire zero,RegDst,ALUSrc_B,ALUSrc_A,Jal,RegWrite,zeroExt,DatatoRegExtra;
	wire [1:0]DatatoReg,Branch;
	wire [2:0]ALU_Control;
	
	wire CE,overflow;
   wire [4:0]writeRegAddr,jalMuxOutput,regRa;
   wire [31:0]writeRegData,rdata_A,rdata_B,AluA,AluB,pc_4,imm_32,newPC,constWire_4,branchPC,shiftResult,ALU_out;
	wire [25:0]inst_field;
	//data initial
	assign regRa = 31;
	assign inst_field = inst_in[25:0];
	assign constWire_4 = 4;
	assign CE = 1;
	
	assign Addr_out = ALU_out;
	assign Data_out = rdata_B;
	
	SCPU_ctrl CPU_Control_inst (
		 .OPcode(inst_in[31:26]), 
		 .Fun(inst_in[5:0]), 
		 .MIO_ready(MIO_ready), 
		 .zero(zero), 
		 .RegDst(RegDst), 
		 .ALUSrc_B(ALUSrc_B), 
		 .DatatoReg(DatatoReg), 
		 .RegWrite(RegWrite), 
		 .ALU_Control(ALU_Control), 
		 .mem_w(mem_w), 
		 .Branch(Branch), 
		 .Jal(Jal), 
		 .DatatoRegExtra(DatatoRegExtra),
		 .CPU_MIO(CPU_MIO), 
		 .zeroExt(zeroExt),
		 .ALUSrc_A(ALUSrc_A)
		 );
		 
	
	REG32 U1 (
		 .clk(clk), 
		 .rst(reset), 
		 .CE(CE), 
		 .D(newPC), 
		 .Q(PC_out)
		 );
	 
   add_32 adder1 (
		.a(PC_out), 
		.b(constWire_4), 
		.c(pc_4)
	);
	//beq,bne
	add_32 adder2 (
		.a(pc_4), 
		.b({imm_32[29:0],2'b00}), 
		.c(branchPC)
	);
	
	MUX4T1_32 PCMux4 (
		 .I0(pc_4), 
		 .I1(branchPC), 
		 .I2({pc_4[31:28],inst_field[25:0],2'b00}), 
		 .I3(rdata_A), 
		 .s(Branch), 
		 .o(newPC)
		 );
	 
	MUX2T1_5 writeRegMux2 (
    .I0(jalMuxOutput), 
    .I1(inst_field[15:11]), 
    .s(RegDst), 
    .o(writeRegAddr)
    );
	 
	 MUX2T1_5 jalMux (
		 .I0(inst_field[20:16]), 
		 .I1(regRa), 
		 .s(Jal), 
		 .o(jalMuxOutput)
    );
	 
	MUX5T1_32 writeRegMux5 (
		 .I0(ALU_out), 
		 .I1(Data_in), 
		 .I2({inst_field[15:0],16'b0}), 
		 .I3(pc_4), 
		 .I4({31'b0,overflow}),
		 .s({DatatoRegExtra,DatatoReg[1],DatatoReg[0]}), 
		 .o(writeRegData)
		 );
		 
	Regs RegisterInstance (
		 .clk(clk), 
		 .rst(reset), 
		 .L_S(RegWrite), 
		 .R_addr_A(inst_field[25:21]), 
		 .R_addr_B(inst_field[20:16]), 
		 .Wt_addr(writeRegAddr), 
		 .Wt_data(writeRegData), 
		 .rdata_A(rdata_A), 
		 .rdata_B(rdata_B)
		 );
		 
	 MUX2T1_32 Alu_input1 (
		 .I0(rdata_A), 
		 .I1(shiftResult), 
		 .s(ALUSrc_A), 
		 .o(AluA)
		 );
		 
	 MUX2T1_32 Alu_input2 (
		 .I0(rdata_B), 
		 .I1(imm_32), 
		 .s(ALUSrc_B), 
		 .o(AluB)
	 );
	
	ALU ALU_instance (
		.A(AluA), 
		.B(AluB), 
		.ALU_operation(ALU_Control), 
		.res(ALU_out), 
		.overflow(overflow), 
		.zero(zero)
	);

	Ext_32 Ext_32_instance (
		 .imm_16(inst_field[15:0]), 
		 .zeroExt(zeroExt),
		 .Imm_32(imm_32)
		 );
		 
	Ext_5_to_32 shiftExtension (
		 .A(inst_field[10:6]), 
		 .B(shiftResult)
		 );
	 
endmodule
