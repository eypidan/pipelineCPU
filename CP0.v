`timescale 1ns / 1ps
`define DEBUG
`define OP_mtc 1
`define OP_mfc 2
`define OP_eret 3
`define Except_Undefined 1 //cause
`define Except_Overflow 2
`define Except_OutOfRange 3
module cp0 (
	input wire clk,  // main clock
	// debug
	`ifdef DEBUG
	input wire [4:0] debug_addr_cp0,  // debug address
	output reg [31:0] debug_data_cp0,  // debug data
	`endif
	// operations (read in ID stage and write in EXE stage)
	input wire [2:0] cp_oper,  // CP0 operation type
	input wire [4:0] addr_r,  // read address
	output reg [31:0] data_r,  // read data
	input wire [4:0] addr_w,  // write address
	input wire [31:0] data_w,  // write data
	// control signal
	input wire rst,  // synchronous reset
	input wire cause[31:0],            // internal exception input
	input wire interruptSignal[2:0],  // external interrupt input
	input wire [31:0] ret_addr,  // target instruction address to store when interrupt occurred
	output reg epc_ctrl,  // force jump enable signal when interrupt authorised or ERET occurred
	output wire [31:0] epc  // target instruction address to jump to
	);
    reg [32:0] cpr [0:31];
    wire [31:0] status = cpr[12];
    reg exception;
    always@(posedge clk or posedge rst)begin
        if(rst) begin
            for(i=0;i<32;i=i+1)
                cpr[i]<=0;
            epc_ctrl <= 0;
            exception <= 0;
        end
        else begin
            if(cause != 0) begin
                cpr[13] <= cause; 
                exception <= 1;
            end               
            else begin
                exception <= 0;
            end               
            
            if(exception == 1) begin
                
            end
            else begin
                if(cp_oper == `OP_mtc) begin
                    cpr[addr_w] <=data_w;
                end else if(cp_oper == `OP_mfc) begin
                    data_r <= cpr[addr_r];
                end else if(cp_oper == `OP_eret)begin

                end 
            end                                                                                                                                        )
            
        end
    end

    assign epc[31:0] = cpr[14][31:0];
endmodule
