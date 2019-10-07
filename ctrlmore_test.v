`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:06:35 05/11/2019
// Design Name:   SCPU_ctrl
// Module Name:   C:/Users/msi1/Desktop/jizu/OExp07_CPUMore/ctrlmore_test.v
// Project Name:  OExp07-SCPUMore
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SCPU_ctrl
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ctrlmore_test;

	// Inputs
	reg [5:0] OPcode;
	reg [5:0] Fun;
	reg MIO_ready;
	reg zero;

	// Outputs
	wire RegDst;
	wire ALUSrc_B;
	wire [1:0] DatatoReg;
	wire RegWrite;
	wire [2:0] ALU_Control;
	wire mem_w;
	wire [1:0] Branch;
	wire Jal;
	wire CPU_MIO;

	// Instantiate the Unit Under Test (UUT)
	SCPU_ctrl uut (
		.OPcode(OPcode), 
		.Fun(Fun), 
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
		.CPU_MIO(CPU_MIO)
	);

	initial begin
		// Initialize Inputs
		OPcode = 0;
		Fun = 0;
		MIO_ready = 0;
		zero = 0;

		// Wait 20 ns for global reset to finish
		#20;
      OPcode = 6'b000000; //eret
		Fun=6'b100000;  //add
		#20;
		Fun=6'b100010;			  //sub
		#20;
      Fun = 6'b100100; //and
		#20;
      Fun = 6'b100101; //or
		#20;
      Fun = 6'b101010; //slt		
		zero=0;
		#20;
      OPcode = 6'b000101; //beq
		zero=1;
		#20;
      OPcode = 6'b000101; //beq
		zero=0;
		#20;
		OPcode = 6'b100011; //lw
		zero=0;
		#20;
		OPcode = 6'b101011; //sw
		#20;

	end
      
endmodule

