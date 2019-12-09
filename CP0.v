`timescale 1ns / 1ps
`define DEBUG
`define OP_mtc 1
`define OP_mfc 2
`define OP_eret 3

`define Except_Undefined 1 //cause
`define Except_Overflow 2
`define Except_OutOfRange 4

`define   EHB_RIGSTER 3
`define CAUSE_RIGSTER 13
`define   EPC_RIGSTER 14


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
	output reg [31:0] data_readFromCP0,  // read data
	input wire [4:0] addr_w,  // write address
	input wire [31:0] data_writeToCP0,  // write data
	// control signal
	input wire rst,  // synchronous reset
	input wire [2:0]cause,            // internal exception input
	input wire [2:0]interruptSignal,  // external interrupt input
	input wire [31:0] except_ret_addr,  // target instruction address to store when interrupt occurred
	output reg epc_ctrl,  // force jump enable signal when interrupt authorised or ERET occurred
	output reg [31:0] jumpAddressExcept,  // target instruction address to jump to
    output reg exceptClear
	);
    wire [31:0] status = cpr[12];
    integer i;
    reg [32:0] cpr [0:31];
    
    reg exception,interrupt;

    // mipsRing represent the status of cp0,
    // mipsRing = 0 user mode, mipsRing = 1 first priority, mipsRing = 2 second priority 
    // mipsRing = 3 exception mipsRing, highest priority
    reg [2:0] mipsRing; 
    reg [2:0] previousRing;

 
    always@(posedge clk or posedge rst)begin
        if(rst) begin
            for(i=0;i<32;i=i+1)
                cpr[i]<=0;
            epc_ctrl <= 0;
            exception <= 0;
            mipsRing <= 0;
            previousRing<=0;
            exceptClear<=0;
            interrupt<=0;
            cpr[`EHB_RIGSTER] <= 32'h0000_0200; // make pc = ebh
        end

        else begin
            if(cause != 0) begin
                cpr[`CAUSE_RIGSTER] <= cause[31:0]; 
                exception <= 1;
            end               
            else begin
                exception <= 0;
                epc_ctrl <= 0;
            end               
            
            if(exception == 1) begin
                epc_ctrl <= 1;
                cpr[`EPC_RIGSTER] <= except_ret_addr;
                jumpAddressExcept <= cpr[`EHB_RIGSTER];
                mipsRing <= 3;
                previousRing <= 0;
            end
            else begin
                if(interruptSignal >= mipsRing) begin //interruptSignal = 0,1,2,3  mipsRing = 0,1,2,3

                    if(mipsRing < interruptSignal )begin
                        epc_ctrl <= 1;
                        cpr[`EPC_RIGSTER] <= except_ret_addr;
                        jumpAddressExcept <= cpr[`EHB_RIGSTER];
                        mipsRing <= interruptSignal;
                        interrupt<= 1;
                    end else begin
                        interrupt <= 0;
                        epc_ctrl <= 0;
                    end

                    if(cp_oper == `OP_mtc) begin
                        cpr[addr_w] <=data_writeToCP0;
                    end else if(cp_oper == `OP_mfc) begin
                        data_readFromCP0 <= cpr[addr_r];
                    end else if(cp_oper == `OP_eret)begin
                        jumpAddressExcept <= cpr[`EPC_RIGSTER];
                        epc_ctrl <= 1;
                    end 
                end else begin
                    epc_ctrl <= 0;
                end
            end                               

            exceptClear <= exception || interrupt; 
        end
    end


endmodule
