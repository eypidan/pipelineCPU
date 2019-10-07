`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:15:03 03/23/2018
// Design Name:   Multi_8CH32
// Module Name:   C:/Users/Zzh/Desktop/EXP/Exp/Multi_8CH32_sim.v
// Project Name:  Exp
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Multi_8CH32
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Multi_8CH32_sim;

	// Inputs
	reg clk;
	reg rst;
	reg EN;
	reg [2:0] Test;
	reg [63:0] point_in;
	reg [63:0] blink_in;
	reg [31:0] Data0;
	reg [31:0] Test_data1;
	reg [31:0] Test_data2;
	reg [31:0] Test_data3;
	reg [31:0] Test_data4;
	reg [31:0] Test_data5;
	reg [31:0] Test_data6;
	reg [31:0] Test_data7;

	// Outputs
	wire [7:0] point_out;
	wire [7:0] blink_out;
	wire [31:0] Disp_num;

	// Instantiate the Unit Under Test (UUT)
	Multi_8CH32 uut (
		.clk(clk), 
		.rst(rst), 
		.EN(EN), 
		.Test(Test), 
		.point_in(point_in), 
		.blink_in(blink_in), 
		.Data0(Data0), 
		.Test_data1(Test_data1), 
		.Test_data2(Test_data2), 
		.Test_data3(Test_data3), 
		.Test_data4(Test_data4), 
		.Test_data5(Test_data5), 
		.Test_data6(Test_data6), 
		.Test_data7(Test_data7), 
		.point_out(point_out), 
		.blink_out(blink_out), 
		.Disp_num(Disp_num)
	);

	initial clk = 0;
	always begin
		clk = ~clk;
		#10;
	end
	
	initial begin
		rst = 0;
		point_in = 64'b00000000_00000001_00000010_00000011_00000100_00000101_00000110_11111111;
		blink_in = 64'b00000000_00000001_00000010_00000011_00000100_00000101_00000110_11111111;
		Data0 = 0;
		Test_data1 = 8'h1;
		Test_data2 = 8'h2;
		Test_data3 = 8'h3;
		Test_data4 = 8'h4;
		Test_data5 = 8'h5;
		Test_data6 = 8'h6;
		Test_data7 = 8'h7;

		EN = 0;
		Test = 0;
		#50;  
		
		EN = 1;
		#50;
		
		while(Test < 3'b111) begin
			Test = Test + 1;
			#50;
		end
    
	end
      
endmodule

