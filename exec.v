`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:47:04 10/31/2019 
// Design Name: 
// Module Name:    exec 
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


module exec(
	input clk,
	input rst,
	input [31:0] id_pc,
	input [31:0] ex_instr,
	input [31:0] ex_r0_val,
	input [31:0] ex_r1_val,
	input [31:0] ex_imm,
	input [6:0] ex_opcode,
	input [4:0] ex_srcreg1_num,
	input [4:0] ex_srcreg2_num,
	input [4:0] ex_dstreg_num,
	input [5:0] ex_alucode,
	input [1:0] ex_aluop1_type,
	input [1:0] ex_aluop2_type,
	input   ex_reg_we,
	input   ex_is_load,
	input   ex_is_store,
//output

	output	[31:0] alu_result,
	output 	[31:0] ex_store_value,
	output 	 br_taken,
	output [31:0] ex_br_addr,
	output reg [31:0] ex_PC
	);
	
	wire [31:0] alu_op1;
	wire [31:0] alu_op2;
	wire [5:0] alu_alucode;
	

always @ (posedge clk)begin 
ex_PC=id_pc;
end
	
	

assign 	 ex_store_value = ((ex_alucode == `ALU_SW) || (ex_alucode == `ALU_SH) || (ex_alucode == `ALU_SB)) ? ex_r1_val : 32'd0;

assign alu_alucode = ex_alucode;

    // wb stage????????????
   // assign ex_srcreg1_value = ex_srcreg1_num==5'd0 ? 32'd0 : ex_srcreg1_val;
    //assign ex_srcreg2_value = ex_srcreg2_num==5'd0 ? 32'd0 : ex_srcreg2_val;

    assign alu_op1 = (ex_aluop1_type == `OP_TYPE_REG) ? ex_r0_val :
                     (ex_aluop1_type == `OP_TYPE_IMM) ? ex_imm :
                     (ex_aluop1_type == `OP_TYPE_PC) ? ex_PC: 32'd0;
    assign alu_op2 = (ex_aluop2_type == `OP_TYPE_REG) ? ex_r1_val :
                     (ex_aluop2_type == `OP_TYPE_IMM) ? ex_imm :
                     (ex_aluop2_type == `OP_TYPE_PC) ? ex_PC : 32'd0;


assign ex_br_addr = (ex_alucode==`ALU_JAL) ? ex_PC+ ex_imm :
                        (ex_alucode==`ALU_JALR) ? ex_r0_val + ex_imm :
                        ((ex_alucode==`ALU_BEQ) || (ex_alucode==`ALU_BNE) || (ex_alucode==`ALU_BLT) ||
                         (ex_alucode==`ALU_BGE) || (ex_alucode==`ALU_BLTU) || (ex_alucode==`ALU_BGEU)) ? ex_PC + ex_imm : 32'd0;


alu alu (
    .alucode(alu_alucode),
    .op1(alu_op1),
    .op2(alu_op2),
    .alu_result(alu_result),
    .br_taken(br_taken)
);

endmodule
