`timescale 1ns / 1ps

module IdStage (
		input clk,
		input rst,
		input [31:0] pc_4,
		input [31:0] instruction,
        input wb_RegWrite,  //wb_ means from wb
        input [4:0]wb_writeRegAddr,
        input [31:0]wb_writeRegData,
        output mem_write,
        output [2:0]ALU_Control,
        output RegWrite,
        
	);

    wire MIO_ready; // useless for now
    wire [31:0]rdata_A,rdata_B,dataOut1,dataOut2;


    Regs RegisterInstance (
        .clk(clk), 
        .rst(rst), 
        .L_S(wb_RegWrite), 
        .R_addr_A(instruction[25:21]), 
        .R_addr_B(instruction[20:16]), 
        .Wt_addr(wb_writeRegAddr), 
        .Wt_data(wb_writeRegData), 
        .rdata_A(rdata_A), 
        .rdata_B(rdata_B)
    );

    MUX2T1_32 DataOut1_instance (
        .I0(rdata_A), 
        .I1(shiftResult), 
        .s(ALUSrc_A), 
        .o(dataOut1)
    );
        
    MUX2T1_32 DataOut2_instance (
        .I0(rdata_B), 
        .I1(imm_32), 
        .s(ALUSrc_B), 
        .o(dataOut2)
    );

    assign ifRegisterRsRtEqual = dataOut1==dataOut2; // equal -> ifRegisterRsRtEqual = 1


endmodule
