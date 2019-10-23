`timescale 1ns / 1ps

module pipeLineCPU_ctrl(
    input wire [5:0] OPcode,
    input wire [5:0] Fun,
    input wire MIO_ready,
    input wire zero,
    output jal,
    output writeRegister,
    output whichWriteRegister,
    output [3:0]ALU_Control,
    output regRtOrImm,
    output shift,
    output zeroOrSignExtention,
    output writeToRtOrRd,
    output 
    );

	initial begin
        RegDst = 0;
        ALUSrc_B = 0;
        ALUSrc_A = 0;
        DatatoReg = 2'b00;
        RegWrite = 0;
        ALU_Control = 3'b000;
        mem_w = 0;
        Branch = 2'b00;
        Jal = 0;
        CPU_MIO = 0;
        zeroExt = 0;
        DatatoRegExtra=0;
    end
	
    always @* begin
        case(OPcode)
        6'b000000: begin 	//ALU
            if(Fun == 6'b100000)begin 	//add
                ALU_Control = 3'b010; RegDst = 1; ALUSrc_B = 0;	ALUSrc_A = 0;zeroExt = 0;DatatoRegExtra=0;
                DatatoReg = 2'b00; Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;end
            else if(Fun == 6'b100010)begin	//sub
                ALU_Control = 3'b110; RegDst = 1; ALUSrc_B = 0; ALUSrc_A = 0;zeroExt = 0;DatatoRegExtra=0;
                DatatoReg = 2'b00; Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;end
            else if(Fun == 6'b100100)begin 	//and
                ALU_Control = 3'b000; RegDst = 1; ALUSrc_B = 0; ALUSrc_A = 0;zeroExt = 0;DatatoRegExtra=0;
                DatatoReg = 2'b00; Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;end
            else if(Fun == 6'b100101)begin 	//or
                ALU_Control = 3'b001; RegDst = 1; ALUSrc_B = 0; ALUSrc_A = 0;zeroExt = 0;DatatoRegExtra=0;
                DatatoReg = 2'b00; Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;end
            else if(Fun == 6'b010110)begin 	//xor
                ALU_Control = 3'b011;RegDst = 1; ALUSrc_B = 0; ALUSrc_A = 0;zeroExt = 0;DatatoRegExtra=0;
                DatatoReg = 2'b00; Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;end
            else if(Fun == 6'b100111)begin 	//nor:~(A | B)
                ALU_Control = 3'b100; RegDst = 1; ALUSrc_B = 0; ALUSrc_A = 0;zeroExt = 0;DatatoRegExtra=0;
                DatatoReg = 2'b00; Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;end
            else if(Fun == 6'b101010)begin //slt
                ALU_Control = 3'b110; RegDst = 1; ALUSrc_B = 0; ALUSrc_A = 0;zeroExt = 0;DatatoRegExtra=1;
                DatatoReg = 2'b00; Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;end
            else if(Fun == 6'b000010)begin //srl
                ALU_Control = 3'b101; RegDst = 1; ALUSrc_B = 0;ALUSrc_A = 1;zeroExt = 0;DatatoRegExtra=0;
                DatatoReg = 2'b00; Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;end
            else if(Fun == 6'b001001)begin //eret
                ALU_Control = 3'b010; RegDst = 1; ALUSrc_B = 0;ALUSrc_A = 0;zeroExt = 0;DatatoRegExtra=0;
                DatatoReg = 2'b00; Jal = 0; Branch = 2'b11; RegWrite = 1; mem_w = 0;end
            else if(Fun == 6'b001000)begin //jr
                ALU_Control = 3'b000; RegDst = 1; ALUSrc_B = 0;ALUSrc_A = 0;zeroExt = 0;DatatoRegExtra=0;
                DatatoReg = 2'b00; Jal = 1; Branch = 2'b11; RegWrite = 0; mem_w = 0;end
            else if(Fun == 6'b000000)begin //sll
                ALU_Control = 3'b111; RegDst = 1; ALUSrc_B = 0;ALUSrc_A = 1;zeroExt = 0;DatatoRegExtra=0;
                DatatoReg = 2'b00; Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;end
            end
        6'b100011: begin //load
                        RegDst = 0; ALU_Control = 3'b010; ALUSrc_B = 1; DatatoReg = 2'b01; ALUSrc_A = 0;
                        Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
        6'b101011: begin //store
                        RegDst = 1; ALU_Control = 3'b010; ALUSrc_B = 1; DatatoReg = 2'b00;ALUSrc_A = 0; 
                        Jal = 0; Branch = 2'b00; RegWrite = 0; mem_w = 1;zeroExt = 0;DatatoRegExtra=0;end
        6'b000100: begin //beq
                        if(zero == 1)begin
                        RegDst = 1; ALU_Control = 3'b110; ALUSrc_B = 0; DatatoReg = 2'b00;ALUSrc_A = 0; 
                        Jal = 0; Branch = 2'b01; RegWrite = 0; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
                        else begin
                        RegDst = 1; ALU_Control = 3'b110; ALUSrc_B = 0; DatatoReg = 2'b00; ALUSrc_A = 0;
                        Jal = 0; Branch = 2'b00; RegWrite = 0; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
                        end
        6'b000101: begin //bne
                        if(zero == 0)begin
                            RegDst = 1; ALU_Control = 3'b110; ALUSrc_B = 0; DatatoReg = 2'b00; ALUSrc_A = 0;
                            Jal = 0; Branch = 2'b01; RegWrite = 0; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
                        else begin
                            RegDst = 1; ALU_Control = 3'b110; ALUSrc_B = 0; DatatoReg = 2'b00;ALUSrc_A = 0; 
                            Jal = 0; Branch = 2'b00; RegWrite = 0; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
                        end
        6'b001010: begin 
                    RegDst = 0; ALU_Control = 3'b110; ALUSrc_B = 1; DatatoReg = 2'b00; ALUSrc_A = 0;
                        Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
        6'b001000: begin //addi
                    RegDst = 0; ALU_Control = 3'b010; ALUSrc_B = 1; DatatoReg = 2'b00; ALUSrc_A = 0;
                        Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
        6'b001100: begin //andi
                    RegDst = 0; ALU_Control = 3'b000; ALUSrc_B = 1; DatatoReg = 2'b00; ALUSrc_A = 0;
                        Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;zeroExt = 1;DatatoRegExtra=0;end
        6'b001101: begin //ori
                    RegDst = 0; ALU_Control = 3'b001; ALUSrc_B = 1; DatatoReg = 2'b00; ALUSrc_A = 0;
                        Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;zeroExt = 1;DatatoRegExtra=0;end
        6'b001110: begin //xori
                    RegDst = 0; ALU_Control = 3'b011; ALUSrc_B = 1; DatatoReg = 2'b00; ALUSrc_A = 0;
                        Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
        6'b000010: begin //j
                    RegDst = 0; ALU_Control = 3'b000; ALUSrc_B = 0; DatatoReg = 2'b00;ALUSrc_A = 0; 
                        Jal = 0; Branch = 2'b10; RegWrite = 0; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
        6'b000011: begin //jal
                    RegDst = 0; ALU_Control = 3'b010; ALUSrc_B = 0; DatatoReg = 2'b11; ALUSrc_A = 0;
                        Jal = 1; Branch = 2'b10; RegWrite = 1; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
    6'b001111: begin //lui
                    RegDst = 0; ALU_Control = 3'b010; ALUSrc_B = 0; DatatoReg = 2'b10; ALUSrc_A = 0;
                        Jal = 0; Branch = 2'b00; RegWrite = 1; mem_w = 0;zeroExt = 0;DatatoRegExtra=0;end
                        
        default: begin
                    RegDst = 0; ALUSrc_B = 0; DatatoReg = 2'b00; RegWrite = 0;
                    ALU_Control = 3'b000; mem_w = 0; Branch = 2'b00; Jal = 0;
                    CPU_MIO = 0;ALUSrc_A = 0;zeroExt = 0;DatatoRegExtra=0; end
        endcase
    end
endmodule
