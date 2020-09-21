`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:10:52 12/03/2019 
// Design Name: 
// Module Name:    decode2 
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




`include "define.v"
module decode2 (
	input clk,
	input rst,
    input [31:0] if_instr,
	input [31:0] pc,
	output reg[31:0] id_instr,
    output reg [4:0] dec_srcreg1_num,
    output reg [4:0] dec_srcreg2_num,
    output reg [4:0] dec_dstreg_num,
    output reg [31:0] dec_imm,
    output reg [5:0] dec_alucode,
    output reg[1:0] dec_aluop1_type,
    output reg [1:0] dec_aluop2_type,
    output reg dec_reg_we,
    output reg dec_is_load,
    output reg dec_is_store,
	output reg [31:0] id_pc,
	output [6:0] opcode
);

    // internal signal
    
    wire [2:0] funct3;
    wire [4:0] funct5;
    wire [4:0] rd;
	wire [4:0]srcreg1_num;
	wire [4:0]srcreg2_num;
	wire [4:0]dstreg_num;
	wire [31:0] imm;
    // op_type
    reg [2:0] op_type;
    reg dst_type;
	reg [5:0] alucode;
	reg [1:0] aluop1_type;
	reg [1:0] aluop2_type;
	reg reg_we;
	reg is_load;
	reg is_store;

always @(posedge clk)
begin
     id_instr <= if_instr;
	 id_pc <= pc;
	 dec_srcreg1_num <=srcreg1_num;
   dec_srcreg2_num <=srcreg2_num ;
   dec_dstreg_num <=dstreg_num;
   dec_imm <=imm ;
     dec_alucode<=alucode;
     dec_aluop1_type<=aluop1_type;
     dec_aluop2_type<=aluop2_type;
     dec_reg_we<=reg_we;
     dec_is_load<=is_load;
    dec_is_store<=is_store;
   
	 end

    // opcode
    assign opcode =if_instr[6:0];

    // funct
    assign funct3 = if_instr[14:12];
    assign funct5 = if_instr[31:27];
    
    // destination
    assign rd = if_instr[11:7];

    // multiplexer
    assign srcreg1_num = (op_type == `TYPE_U || op_type == `TYPE_J) ? 5'd0 : if_instr[19:15];
    assign srcreg2_num = (op_type == `TYPE_U || op_type == `TYPE_J || op_type == `TYPE_I) ? 5'd0 : if_instr[24:20];
    assign dstreg_num = (dst_type == `REG_RD) ? rd : 5'd0;
    assign imm = (op_type == `TYPE_U) ? {if_instr[31:12], 12'd0} :
                 (op_type == `TYPE_J) ? {{11{if_instr[31]}}, if_instr[31], if_instr[19:12], if_instr[20], if_instr[30:21], 1'd0} :
                 (op_type == `TYPE_I) ? {{20{if_instr[31]}}, if_instr[31:20]} :
                 (op_type == `TYPE_B) ? {{19{if_instr[31]}}, if_instr[31], if_instr[7], if_instr[30:25], if_instr[11:8], 1'd0} :
                 (op_type == `TYPE_S) ? {{20{if_instr[31]}}, if_instr[31:25], if_instr[11:7]} : 32'd0;





	


    always @(*) begin
        case (opcode)
            `LUI: begin
                alucode  =  `ALU_LUI;
                reg_we   =  `ENABLE;
                is_load  =  `DISABLE;
                is_store =  `DISABLE;
                aluop1_type = `OP_TYPE_NONE;
                aluop2_type = `OP_TYPE_IMM;
                op_type  =  `TYPE_U;
                dst_type =  `REG_RD;
            end
            `AUIPC: begin
                alucode  =  `ALU_ADD;
                reg_we   =  `ENABLE;
                is_load  =  `DISABLE;
                is_store =  `DISABLE;
                aluop1_type = `OP_TYPE_IMM;
                aluop2_type = `OP_TYPE_PC;
                op_type  =  `TYPE_U;
                dst_type =  `REG_RD;
            end
            `JAL: begin
                alucode  =  `ALU_JAL;
                is_load  =  `DISABLE;
                is_store =  `DISABLE;
                aluop1_type = `OP_TYPE_NONE;
                aluop2_type = `OP_TYPE_PC;
                op_type  =  `TYPE_J;
                dst_type =  `REG_RD;
                case (dstreg_num)
                    5'b00000: begin
                        reg_we = `DISABLE;
                    end
                    default: begin
                        reg_we = `ENABLE;
                    end
                endcase
            end
            `JALR: begin
                alucode  =  `ALU_JALR;
                reg_we   =  `ENABLE;
                is_load  =  `DISABLE;
                is_store =  `DISABLE;
                aluop1_type = `OP_TYPE_REG;
                aluop2_type = `OP_TYPE_PC;
                op_type  =  `TYPE_I;
                dst_type =  `REG_RD;
                case (dstreg_num)
                    5'b00000: begin
                        reg_we = `DISABLE;
                    end
                    default: begin
                        reg_we = `ENABLE;
                    end
                endcase
            end
            `BRANCH: begin                          
                case (funct3)
                    3'b000: begin  // BEQ
                        alucode  =  `ALU_BEQ;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_B;
                        dst_type =  `REG_NONE;
                    end
                    3'b001: begin  // BNE
                        alucode  =  `ALU_BNE;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_B;
                        dst_type =  `REG_NONE;
                    end
                    3'b100: begin  // BLT
                        alucode  =  `ALU_BLT;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_B;
                        dst_type =  `REG_NONE;
                    end
                    3'b101: begin  // BGE
                        alucode  =  `ALU_BGE;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_B;
                        dst_type =  `REG_NONE;
                    end
                    3'b110: begin  // BLTU
                        alucode  =  `ALU_BLTU;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_B;
                        dst_type =  `REG_NONE;
                    end
                    3'b111: begin  // BGEU
                        alucode  =  `ALU_BGEU;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_B;
                        dst_type =  `REG_NONE;
                    end
                    default: begin
                        alucode  =  `ALU_NOP;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type =  `OP_TYPE_NONE;
                        aluop2_type =  `OP_TYPE_NONE;
                        op_type  =  `TYPE_NONE;
                        dst_type =  `REG_NONE;
                    end
                endcase
            end
            `LOAD: begin                          
                case (funct3)
                    3'b000: begin  // LB
                        alucode  =  `ALU_LB;
                        reg_we   =  `ENABLE;
                        is_load  =  `ENABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b001: begin  // LH
                        alucode  =  `ALU_LH;
                        reg_we   =  `ENABLE;
                        is_load  =  `ENABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b010: begin  // LW
                        alucode  =  `ALU_LW;
                        reg_we   =  `ENABLE;
                        is_load  =  `ENABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b100: begin  // LBU
                        alucode  =  `ALU_LBU;
                        reg_we   =  `ENABLE;
                        is_load  =  `ENABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b101: begin  // LHU
                        alucode  =  `ALU_LHU;
                        reg_we   =  `ENABLE;
                        is_load  =  `ENABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    default: begin
                        alucode  =  `ALU_NOP;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type =  `OP_TYPE_NONE;
                        aluop2_type =  `OP_TYPE_NONE;
                        op_type  =  `TYPE_NONE;
                        dst_type =  `REG_NONE;
                    end
                endcase
            end
            `STORE: begin                          
                case (funct3)
                    3'b000: begin  // SB
                        alucode  =  `ALU_SB;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `ENABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_S;
                        dst_type =  `REG_NONE;
                    end
                    3'b001: begin  // SH
                        alucode  =  `ALU_SH;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `ENABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_S;
                        dst_type =  `REG_NONE;
                    end
                    3'b010: begin  // SW
                        alucode  =  `ALU_SW;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `ENABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_S;
                        dst_type =  `REG_NONE;
                    end
                    default: begin
                        alucode  =  `ALU_NOP;
                        reg_we   =  `DISABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type =  `OP_TYPE_NONE;
                        aluop2_type =  `OP_TYPE_NONE;
                        op_type  =  `TYPE_NONE;
                        dst_type =  `REG_NONE;
                    end
                endcase
            end                             
            `OPIMM: begin                          
                case (funct3)
                    3'b000: begin  // ADDI
                        alucode  =  `ALU_ADD;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b010: begin  // SLTI
                        alucode  =  `ALU_SLT;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b011: begin  // SLTIU
                        alucode  =  `ALU_SLTU;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b100: begin  // XORI
                        alucode  =  `ALU_XOR;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b110: begin  // ORI
                        alucode  =  `ALU_OR;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b111: begin  // ANDI
                        alucode  =  `ALU_AND;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b001: begin  // SLLI
                        alucode  =  `ALU_SLL;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_IMM;
                        op_type  =  `TYPE_I;
                        dst_type =  `REG_RD;
                    end
                    3'b101: begin
                        case (funct5[3])
                            1'b0: begin  // SRLI
                                alucode  =  `ALU_SRL;
                                reg_we   =  `ENABLE;
                                is_load  =  `DISABLE;
                                is_store =  `DISABLE;
                                aluop1_type = `OP_TYPE_REG;
                                aluop2_type = `OP_TYPE_IMM;
                                op_type  =  `TYPE_I;
                                dst_type =  `REG_RD;
                            end
                            1'b1: begin  // SRAI
                                alucode  =  `ALU_SRA;
                                reg_we   =  `ENABLE;
                                is_load  =  `DISABLE;
                                is_store =  `DISABLE;
                                aluop1_type = `OP_TYPE_REG;
                                aluop2_type = `OP_TYPE_IMM;
                                op_type  =  `TYPE_I;
                                dst_type =  `REG_RD;
                            end
                        endcase
                    end
                endcase
            end
            `OP: begin                          
                case (funct3)
                    3'b000: begin
                        case (funct5[3])
                            1'b0: begin  // ADD
                                alucode  =  `ALU_ADD;
                                reg_we   =  `ENABLE;
                                is_load  =  `DISABLE;
                                is_store =  `DISABLE;
                                aluop1_type = `OP_TYPE_REG;
                                aluop2_type = `OP_TYPE_REG;
                                op_type  =  `TYPE_R;
                                dst_type =  `REG_RD;
                            end
                            1'b1: begin  // SUB
                                alucode  =  `ALU_SUB;
                                reg_we   =  `ENABLE;
                                is_load  =  `DISABLE;
                                is_store =  `DISABLE;
                                aluop1_type = `OP_TYPE_REG;
                                aluop2_type = `OP_TYPE_REG;
                                op_type  =  `TYPE_R;
                                dst_type =  `REG_RD;
                            end
                        endcase
                    end
                    3'b001: begin  // SLL
                        alucode  =  `ALU_SLL;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_R;
                        dst_type =  `REG_RD;
                    end
                    3'b010: begin  // SLT
                        alucode  =  `ALU_SLT;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_R;
                        dst_type =  `REG_RD;
                    end                                
                    3'b011: begin  // SLTU
                        alucode  =  `ALU_SLTU;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_R;
                        dst_type =  `REG_RD;
                    end
                    3'b100: begin  // XOR
                        alucode  =  `ALU_XOR;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_R;
                        dst_type =  `REG_RD;
                    end
                    3'b101: begin
                        case (funct5[3])
                            1'b0: begin  // SRL
                                alucode  =  `ALU_SRL;
                                reg_we   =  `ENABLE;
                                is_load  =  `DISABLE;
                                is_store =  `DISABLE;
                                aluop1_type = `OP_TYPE_REG;
                                aluop2_type = `OP_TYPE_REG;
                                op_type  =  `TYPE_R;
                                dst_type =  `REG_RD;
                            end
                            1'b1: begin  // SRA
                                alucode  =  `ALU_SRA;
                                reg_we   =  `ENABLE;
                                is_load  =  `DISABLE;
                                is_store =  `DISABLE;
                                aluop1_type = `OP_TYPE_REG;
                                aluop2_type = `OP_TYPE_REG;
                                op_type  =  `TYPE_R;
                                dst_type =  `REG_RD;
                            end
                        endcase
                    end
                    3'b110: begin  // OR
                        alucode  =  `ALU_OR;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_R;
                        dst_type =  `REG_RD;
                    end
                    3'b111: begin  // AND
                        alucode  =  `ALU_AND;
                        reg_we   =  `ENABLE;
                        is_load  =  `DISABLE;
                        is_store =  `DISABLE;
                        aluop1_type = `OP_TYPE_REG;
                        aluop2_type = `OP_TYPE_REG;
                        op_type  =  `TYPE_R;
                        dst_type =  `REG_RD;
                    end
                endcase
            end
            default: begin
                alucode  =  `ALU_NOP;
                reg_we   =  `DISABLE;
                is_load  =  `DISABLE;
                is_store =  `DISABLE;
                aluop1_type =  `OP_TYPE_NONE;
                aluop2_type =  `OP_TYPE_NONE;
                op_type  =  `TYPE_NONE;
                dst_type =  `REG_NONE;
            end
        endcase
    end

endmodule
