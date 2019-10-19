`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:59:45 03/17/2018
// Design Name:
// Module Name:    Top
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
module Top(
	input wire CLK_200M_P,
	input wire CLK_200M_N,
	input wire RSTN,
	input wire [15:0] SW,
	output wire [4:0] BTN_x,
	input wire [3:0] BTN_y,
	output wire seg_clk,
	output wire seg_clrn,
	output wire seg_sout,
	output wire SEG_PEN,
	output wire led_clk,
	output wire led_clrn,
	output wire LED_PEN,
	output wire led_sout,
	output wire RDY,
	output wire readn,
	output wire CR,
	output wire Buzzer,
	output wire [7:0] SEGMENT,
	output wire [3:0] AN,
	output wire [7:0] LED
   );
	
	wire Cpu_mem_w;
	wire [31:0] Cpu_PC;
	wire [31:0] Cpu_Addr_Out;
	wire [31:0] Cpu_Data_Out;
	
	wire [31:0] Rom_CpuInst;
	
	wire [31:0] Ram_DataOut;
	
	wire [31:0] Bus_CpuData;
	wire [31:0] Bus_RamDataIn;
	wire Bus_RamWe;
	wire [9:0] Bus_RamAddr;
	wire [31:0] Bus_Peripheral_in;
	wire Bus_Mux_EN;
	wire Bus_SPIO_EN;
	wire Bus_counter_we;
	
	wire [7:0] Mux_point_out;
	wire [7:0] Mux_LE_out;
	wire [31:0] Mux_Disp_num;
	
	wire [1:0] SPIO_counter_set;
	wire [15:0] SPIO_LED_out;
	
	wire [31:0] ClkDiv_Div;
	wire ClkDiv_CpuClk;
	
	wire [4:0] AntiJitter_Key_out;
	wire AntiJitter_Key_ready;
	wire [3:0] AntiJitter_Pulse_Out;
	wire [3:0] AntiJitter_BTN_OK;
	wire [15:0] AntiJitter_SW_OK;
	wire AntiJitter_rst;
	
	wire [31:0] Counter_counter_out;
	wire Counter_counter2_out;
	wire Counter_counter1_out;
	wire Counter_counter0_out;
	
	wire Enter_readn;
	wire [31:0] Enter_Ai;
	wire [31:0] Enter_Bi; 
	wire [7:0] Enter_blink;
	
	
	assign RDY = AntiJitter_Key_ready;
	assign readn = Enter_readn;
	assign Buzzer = 1;
	//U0
	clkchange U0(
		.clk200P(CLK_200M_P),
		.clk200N(CLK_200M_N),
		.rst(AntiJitter_SW_OK[14]),
		.clk100MHz(clk_100mhz)
	);
	//U1
	SCPU_More U1 (	
		.clk(ClkDiv_CpuClk),			
		.reset(AntiJitter_SW_OK[14]),
		.MIO_ready(),
		.inst_in(Rom_CpuInst),
		.Data_in(Bus_CpuData),
		.INT(Counter_counter0_out),
		.mem_w(Cpu_mem_w),
		.PC_out(Cpu_PC),
		.Addr_out(Cpu_Addr_Out),
		.Data_out(Cpu_Data_Out), 
		.CPU_MIO()
		);
	
	//U2
	ROM_D U2 (
		.a(Cpu_PC[11:2]),
		.spo(Rom_CpuInst)
		);

	//U3
	RAM_B U3 (
		.clka(~clk_100mhz),
		.wea(Bus_RamWe),
		.addra(Bus_RamAddr),
		.dina(Bus_RamDataIn),
		.douta(Ram_DataOut)
		);
	
	//U4
	MIO_BUS U4(
		.clk(clk_100mhz),
		.rst(AntiJitter_SW_OK[14]),
		.BTN(AntiJitter_BTN_OK[3:0]),
		.SW(AntiJitter_SW_OK[15:0]),
		.mem_w(Cpu_mem_w),
		.addr_bus(Cpu_Addr_Out),
		.Cpu_data2bus(Cpu_Data_Out),
		.ram_data_out(Ram_DataOut),
		.led_out(SPIO_LED_out),
		.counter_out(Counter_counter_out),
		.counter0_out(Counter_counter0_out),
		.counter1_out(Counter_counter1_out),
		.counter2_out(Counter_counter2_out),
		.Cpu_data4bus(Bus_CpuData),
		.ram_data_in(Bus_RamDataIn),
		.data_ram_we(Bus_RamWe),
		.ram_addr(Bus_RamAddr),
		.Peripheral_in(Bus_Peripheral_in),
		.GPIOe0000000_we(Bus_Mux_EN),
		.GPIOf0000000_we(Bus_SPIO_EN),
		.counter_we(Bus_counter_we)
	);

	//U5
	Multi_8CH32 U5 (
		.clk(~ClkDiv_CpuClk),
		.rst(AntiJitter_SW_OK[14]),
		.EN(Bus_Mux_EN),
		.Test(AntiJitter_SW_OK[7:5]),
		.point_in({ClkDiv_Div, ClkDiv_Div}),
		.blink_in({64{1'b0}}),
		.Data0(Bus_Peripheral_in),
		.Test_data1({1'b0, 1'b0, Cpu_PC[31:2]}),
		.Test_data2(Rom_CpuInst),
		.Test_data3(Counter_counter_out),
		.Test_data4(Cpu_Addr_Out),
		.Test_data5(Cpu_Data_Out),
		.Test_data6(Bus_CpuData),
		.Test_data7(Cpu_PC),
		.point_out(Mux_point_out),
		.blink_out(Mux_LE_out),
		.Disp_num(Mux_Disp_num)
		);

	//U6
	SSeg7_Dev U6 (
		.clk(clk_100mhz),//时钟
		.rst(AntiJitter_SW_OK[14]),//复位
		.Start(ClkDiv_Div[20]),//串行扫描启动
		.Mode(AntiJitter_SW_OK[0]),//文本(16进制)/图型(点阵)切换
		.flash(ClkDiv_Div[25]),//七段码闪烁频率
		.Hexs(Mux_Disp_num),//32位待显示输入数据
		.point(Mux_point_out),//七段码小数点：8个
		.LES(Mux_LE_out),//七段码使能，为0时亮起，为1时熄灭
		.seg_clk(seg_clk),//串行移位时钟
		.seg_sout(seg_sout),//七段显示数据(串行输出)
		.SEG_PEN(SEG_PEN),//七段码显示刷新使能
		.seg_clrn(seg_clrn)//七段码显示汪零
		);
		
	//U7
	SPIO U7 (
		.clk(~ClkDiv_CpuClk),//时钟
		.rst(AntiJitter_SW_OK[14]),//复位
		.EN(Bus_SPIO_EN),//PIO/LED显示刷新使能
		.Start(ClkDiv_Div[20]),//串行扫描启动
		.P_Data(Bus_Peripheral_in),//并行输入，用于串行输出数据
		.counter_set(SPIO_counter_set),//用于计数/定时模块控制
		.LED_out(SPIO_LED_out),//并行输出数据
		.GPIOf0(),//待用：GPIO
		.led_clk(led_clk),//串行移位时钟
		.led_sout(led_sout),//串行输出
		.LED_PEN(LED_PEN),//LED显示刷新使能
		.led_clrn(led_clrn)//LED显示清零
		);

	//U8
	clk_div U8 (
		.clk(clk_100mhz),//主板时钟
	   .rst(AntiJitter_SW_OK[14]),//复位信号
	   .siwtch(AntiJitter_SW_OK[2]),//CPU时钟切换
		.handClk(AntiJitter_SW_OK[15]),
		.clkdiv(ClkDiv_Div),//32位计数分频输出
		.clk_cpu(ClkDiv_CpuClk)//CPU时钟输出
		);

	//U9
	SAnti_jitter U9 (
		.clk(clk_100mhz),
		.RSTN(RSTN),
		.readn(Enter_readn),
		.Key_y(BTN_y),
		.Key_x(BTN_x),
		.SW(SW),
		.Key_out(AntiJitter_Key_out),
		.Key_ready(AntiJitter_Key_ready),
		.pulse_out(AntiJitter_Pulse_Out),
		.BTN_OK(AntiJitter_BTN_OK),
		.SW_OK(AntiJitter_SW_OK),
		.CR(CR),
		.rst(AntiJitter_rst)
		);
	
	//U10
	Counter_x U10 (
		.clk(~ClkDiv_CpuClk),
		.rst(AntiJitter_SW_OK[14]),
		.clk0(ClkDiv_Div[6]),
		.clk1(ClkDiv_Div[9]),
		.clk2(ClkDiv_Div[11]),
		.counter_we(Bus_counter_we),
		.counter_val(Bus_Peripheral_in),
		.counter_ch(SPIO_counter_set),
		.counter0_OUT(Counter_counter0_out),
		.counter1_OUT(Counter_counter1_out),
		.counter2_OUT(Counter_counter2_out),
		.counter_out(Counter_counter_out)
		);
		
	Seg7_Dev U61(
			.Scan({AntiJitter_SW_OK[1],ClkDiv_Div[19:18]}),
			.SW0(AntiJitter_SW_OK[0]),
			.flash(ClkDiv_Div[25]),
			.Hexs(Mux_Disp_num),
			.point(Mux_point_out),
			.LES(Mux_LE_out),
			.SEGMENT(SEGMENT),
			.AN(AN)
		);
		
	SEnter_2_32 M4 (
		.clk(clk_100mhz),
		.BTN(AntiJitter_BTN_OK[2:0]),//对应SAnti_jitter列按键
		.Ctrl({AntiJitter_SW_OK[7:5], AntiJitter_SW_OK[15], AntiJitter_SW_OK[0]}),
		.D_ready(AntiJitter_Key_ready),//对应SAnti_jitter扫描码有效
		.Din(AntiJitter_Key_out),
		.readn(Enter_readn),//=0读扫描码
		.Ai(Enter_Ai),//输出32位数一：Ai
		.Bi(Enter_Bi),//输出32位数二：Bi
		.blink(Enter_blink)//单键输入指示
		);

endmodule
