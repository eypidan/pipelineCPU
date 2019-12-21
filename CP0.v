`timescale 1ns / 1ps
`define DEBUG

`define OP_none 0
`define OP_mtc 1
`define OP_mfc 2
`define OP_eret 3

`define Except_Undefined 1 //cause
`define Except_Overflow 2
`define Except_OutOfRange 4

`define   EHB_RIGSTER 3
`define CAUSE_RIGSTER 13
`define   EPC_RIGSTER 14
`define STATUS_RIGSTER 12

module cp0 (
	input wire clk,  // main clock
	// debug
	`ifdef DEBUG
	input wire [4:0] debug_addr_cp0,  // debug address
	output reg [31:0] debug_data_cp0,  // debug data
    output wire [2:0] debug_cp0_cause,
    output wire [2:0] debug_cp0_cp_oper,
    output wire [2:0] debug_cp0_interruptSignal,
    output wire [31:0] debug_cp0_jumpAddressExcept,
    output wire [31:0] debug_cp0_ehb_reg,
    output wire [31:0] debug_cp0_epc_reg,
    output wire [31:0] debug_cp0_cause_reg,
    output wire [31:0] debug_cp0_status_reg,
    output wire debug_exception,
    output wire debug_interrupt,
    output wire [2:0] debug_cp0_ring,
	`endif
	// operations (read in ID stage and write in EXE stage)
    input wire cpu_en,
	input wire [2:0] cp_oper,  // CP0 operation type
	input wire [4:0] addr_r,  // read address
	output reg [31:0] data_readFromCP0,  // read data
	input wire [4:0] addr_w,  // write address
	input wire [31:0] data_writeToCP0,  // write data
    input wire [31:0] ex_instruction,
	// control signal
	input wire rst,  // synchronous reset
	input wire [2:0]cause,            // internal exception input
	input wire [2:0]interruptSignal,  // external interrupt input
	input wire [31:0] except_ret_addr,  // target instruction address to store when interrupt occurred
	output reg epc_ctrl,  // force jump enable signal when interrupt authorised or ERET occurred
	output reg [31:0] jumpAddressExcept,  // target instruction address to jump to
    output reg exceptClear,
    output reg eret_clearSignal
	);

    wire [31:0] status = cpr[`STATUS_RIGSTER];
    integer i;
    reg [32:0] cpr [0:31];
    
    reg exception,interrupt;

    // mipsRing represent the status of cp0,
    // mipsRing = 0 user mode, mipsRing = 1 first priority, mipsRing = 2 second priority 
    // mipsRing = 4 exception mipsRing, highest priority
    reg [2:0] mipsRing; 
    reg [2:0] previousRing;
    reg [2:0] ppriviousRing;
 
    always@(posedge clk or posedge rst)begin
        if(rst) begin
            for(i=0;i<32;i=i+1)
                cpr[i]<=0;
            epc_ctrl <= 0;
            exception <= 0;
            mipsRing <= 0;
            previousRing<=0;
            ppriviousRing <= 0;
            exceptClear<=0;
            interrupt<=0;
            cpr[`EHB_RIGSTER] <= 32'h0000_0024; // make pc = ebh
            jumpAddressExcept <= 0;
            eret_clearSignal<=0;
        end

        else begin
            
        //deal with exception
            if(cause != 0 && status[15:8] == 8'hff) begin
                cpr[`CAUSE_RIGSTER] <= cause[2:0]; 
                exception <= 1;

                epc_ctrl <= 1;
                cpr[`EPC_RIGSTER] <= except_ret_addr + 4; // if exception. the next instruction is the return address, so we need "+4"
                jumpAddressExcept <= cpr[`EHB_RIGSTER];
                mipsRing <= 4;
                previousRing <= 0;
            end               
            else begin
                if(cpu_en)begin
                    exception <= 0;
                    epc_ctrl <= 0;
                    eret_clearSignal <= 0;
                end
            end               
            
            //deal with interrupt
            if(interruptSignal > mipsRing && status[15:8] == 8'hff) begin //interruptSignal = 0,1,2,3  mipsRing = 0,1,2,3,4
                epc_ctrl <= 1;

                cpr[`EPC_RIGSTER] <= except_ret_addr + 4;    // if interrupt
                jumpAddressExcept <= cpr[`EHB_RIGSTER];
                ppriviousRing <= previousRing;
                previousRing <= mipsRing;
                mipsRing <= interruptSignal;
                interrupt<= 1;
              
            end 
            else begin
                if(exception == 0 && cpu_en) begin
                    interrupt <= 0;
                    epc_ctrl<=0;
                    eret_clearSignal <= 0;
                end
            end       

            //excute the cp0 instruction
            if(cp_oper == `OP_mtc) begin
                cpr[addr_w] <=data_writeToCP0;
            end else if(cp_oper == `OP_mfc) begin
                data_readFromCP0 <= cpr[addr_r];
            end else if(cp_oper == `OP_eret)begin
                jumpAddressExcept <= cpr[`EPC_RIGSTER];
                epc_ctrl <= 1;
                mipsRing <= previousRing;
                previousRing <= ppriviousRing;
                eret_clearSignal <= 1;
            end 
            // else begin
            //     epc_ctrl <= 0;
            // end
        
            exceptClear <= exception || interrupt; 
        end
    end

    `ifdef DEBUG
    assign debug_cp0_ring[2:0] = mipsRing[2:0];
    assign debug_cp0_cause[2:0] = cause[2:0];
    assign debug_cp0_cp_oper[2:0] = cp_oper[2:0];
    assign debug_cp0_interruptSignal[2:0] = interruptSignal[2:0];
    assign debug_cp0_jumpAddressExcept[31:0] = jumpAddressExcept[31:0];
    assign debug_exception = exception;
    assign debug_interrupt = interrupt;
    assign debug_cp0_ehb_reg[31:0] = cpr[`EHB_RIGSTER];
    assign debug_cp0_epc_reg[31:0] = cpr[`EPC_RIGSTER];
    assign debug_cp0_cause_reg[31:0] = cpr[`CAUSE_RIGSTER];
    assign debug_cp0_status_reg[31:0] = cpr[`STATUS_RIGSTER];
    `endif
    
//01000000100100010110000000000000

endmodule
