`timescale 1ns / 1ps


module inst_rom_wrapper (
    input clk,
    input rst,
    input cs,
    input  [31:0] inst_addr,
    output reg [31:0]inst_data,
    output reg stall
);
   
    inst_rom INST_ROM (
		.a(inst_addr[11:2]),
		.spo(inst_data[31:0])
	);
endmodule
