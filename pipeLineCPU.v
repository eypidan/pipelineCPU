`timescale 1ns / 1ps
module pipeLineCPU(
    input [31:0]inst_in,
    input [31:0]Data_in,
    input rst,
    input clk,
    input MIO_ready,
    input INT,
    output mem_w,
    output CPU_MIO,
    output [31:0]Addr_out,
    output [31:0]PC_out,
    output [31:0]Data_out
    );
	
	
    wire [31:0] nextPc, pc, pc_4, id_pc_4, id_instruction;

    Pc pcInstance(
        .clk(clk),
        .rst(rst),
        .id_shouldStall(id_shouldStall),
        .nextPc(nextPc[31:0]),
        .pc(pc[31:0])  // pc -> output
    );

    assign PC_out = pc;

    IfStage IfstageInstance(
        .clk(clk),
        .pc(pc),
        .id_shouldJumpOrBranch(),
        .id_jumpOrBranchPc(),
        .pc_4(pc_4[31:0]),  //output
        .nextPc(nextPc[31:0]) //output
    );

    IfIdRegisters IfIdRegistersInstance(
        .clk(clk),
        .rst(rst),
        .id_shouldStall(),
        .if_pc_4(pc_4[31:0]),
        .if_instruction(inst_in[31:0]),
        .id_pc_4(id_pc_4[31:0]),//output
        .id_instruction(id_instruction[31:0]) // output
    );




	
		 
	
	REG32 U1 (
		 .clk(clk), 
		 .rst(rst), 
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
