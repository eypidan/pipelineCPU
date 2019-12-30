`timescale 1ns / 1ps
`define S_IDLE 0
`define S_READ 1
`define S_WRITE 2
module data_ram_wrapper (
    input cpu_en,
    input clk,
    input rst,
    input cs,
    input mem_wen,
    input [31:0] mem_addr,
    input [31:0]mem_data_w,
    output reg [31:0]mem_data_r,
    output reg stall
);  
    reg [3:0] state;
    reg [3:0] counter;
    reg ack;
    data_ram DATA_RAM (
        .clka(clk), // input clka
        .wea(mem_wen), // input [0 : 0] wea
        .addra(mem_addr[11:2]), // input [9 : 0] addra
        .dina(mem_data_w[31:0]), // input [31 : 0] dina
        .douta(mem_data_r[31:0]) // output [31 : 0] douta
	);

   always@(posedge clk)begin
        if(rst) begin
            mem_data_r <= 0;
            stall <= 0;
            state <= `S_IDLE;
            counter <= 0;
        end 
        else begin 
            stall <= cs & (~ack);
            if(cpu_en)
                case(state)
                    `S_IDLE:begin

                    end
                    `S_READ:begin
                        counter <= counter+1;
                    end
                    `S_WRITE:begin
                
                    end
                    // default:; 
                endcase
            end
        end
   end

endmodule
