`timescale 1ns / 1ps
`define DEBUG
`define S_IDLE 0
`define S_READ 1
`define S_WRITE 2

module inst_rom_wrapper (
    input cpu_en,
    input clk,
    input rst,
    input cs,
    input  [31:0] inst_addr,
    output reg [31:0]inst_data,
    output reg instRomStall
);
    wire [31:0] inst_data_wire;
    reg [3:0] state;
    reg [3:0] counter;
    reg ack;

    inst_rom INST_ROM (
		.a(inst_addr[11:2]),
		.spo(inst_data_wire[31:0])
	);

    always@(posedge clk)begin
        if(rst) begin
            mem_data_r <= 0;
            instRomStall <= 0;
            state <= `S_IDLE;
            counter <= 0;
        end 
        else begin 
            instRomStall <= cs & (~ack);
            if(cpu_en)
                case(state)
                    `S_IDLE:begin
                        state<= `S_READ;
                    end
                    `S_READ:begin
                        counter <= counter+1;
                        if(counter == 8) begin
                            counter <= 0;
                            ack <= 1;
                            inst_data <= inst_data_wire;
                            state <= `S_IDLE;
                        end
                    end
                    // default:; 
                endcase
            end
        end
   end

endmodule
