`timescale 1ns / 1ps


module data_ram_wrapper (
    input clk,
    input rst,
    input cs,
    input mem_wen,
    input [31:0] mem_addr,
    input [31:0]mem_data_w,
    output reg [31:0]mem_data_r,
    output reg stall
);  
    data_ram DATA_RAM (
        .clka(clk), // input clka
        .wea(mem_wen), // input [0 : 0] wea
        .addra(mem_addr[11:2]), // input [9 : 0] addra
        .dina(mem_data_w[31:0]), // input [31 : 0] dina
        .douta(mem_data_r[31:0]) // output [31 : 0] douta
	);
   

endmodule
