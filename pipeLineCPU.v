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
    
    
endmodule
