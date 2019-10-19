// Verilog test fixture created from schematic C:\Users\px\Desktop\OExp07_CPUMore\Data_path.sch - Sat Oct 12 13:16:33 2019

`timescale 1ns / 1ps

module Data_path_Data_path_sch_tb();

// Inputs
   reg [25:0] inst_field;
   reg RegDst;
   reg [1:0] DatatoReg;
   reg [31:0] Data_in;
   reg rst;
   reg clk;
   reg [1:0] Branch;
   reg [2:0] ALU_Control;
   reg ALUSrc_B;
   reg RegWrite;
   reg Jal;
   reg ALUSrc_A;

// Output
   wire [31:0] PC_out;
   wire [31:0] ALU_out;
   wire [31:0] Data_out;
   wire zero;
   wire overflow;

// Bidirs

// Instantiate the UUT
   Data_path UUT (
		.inst_field(inst_field), 
		.RegDst(RegDst), 
		.DatatoReg(DatatoReg), 
		.Data_in(Data_in), 
		.rst(rst), 
		.clk(clk), 
		.PC_out(PC_out), 
		.Branch(Branch), 
		.ALU_Control(ALU_Control), 
		.ALUSrc_B(ALUSrc_B), 
		.RegWrite(RegWrite), 
		.ALU_out(ALU_out), 
		.Data_out(Data_out), 
		.Jal(Jal), 
		.zero(zero), 
		.overflow(overflow), 
		.ALUSrc_A(ALUSrc_A)
   );
// Initialize Inputs
   `ifdef auto_init
       initial begin
		 #100
		 rst = 1;
		 #100
		inst_field = 26'b10_0000_0011_1111_0000_0000_0000;
		RegDst = 0;
		DatatoReg = 2'b10;
		Data_in = 0;
		rst = 0;
		clk = 0;
		Branch = 2'b00;
		ALU_Control = 3'b010;
		ALUSrc_B = 0;
		RegWrite = 1;
		Jal = 0;
		ALUSrc_A = 0;
		
		end
   `endif
	always begin
		#10;
		clk = 0;
		#10;
		clk = 1;
	end
endmodule
