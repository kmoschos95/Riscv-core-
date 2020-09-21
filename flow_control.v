`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:53:12 12/03/2019 
// Design Name: 
// Module Name:    flow_control 
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

module flow_control(
input clk,
input rst,
//id1
input [31:0] id_instr1,
input [6:0]	 dec_opcode_1,
input [4:0]  dec_srcreg1_num_1,
input [4:0]  dec_srcreg2_num_1,
input [4:0]  dec_dstreg_num_1,
input [31:0] dec_imm_1,
input [5:0]  dec_alucode_1,
input [1:0]  dec_aluop1_type_1,
input [1:0]  dec_aluop2_type_1,
input [31:0] out1,
input [31:0] out2,
input   dec_reg_we_1,
input   dec_is_load_1,
input   dec_is_store_1,
//id2
input [31:0] id_instr2,
input [6:0]	 dec_opcode_2,
input [4:0]  dec_srcreg1_num_2,
input [4:0]  dec_srcreg2_num_2,
input [4:0]  dec_dstreg_num_2,
input [31:0] dec_imm_2,
input [5:0]  dec_alucode_2,
input [1:0]  dec_aluop1_type_2,
input [1:0]  dec_aluop2_type_2,
input [31:0] out3,
input [31:0] out4,
input   dec_reg_we_2,
input   dec_is_load_2,
input   dec_is_store_2,
//ex in
input ex_br_taken,

//mem 
input [6:0] mem_opcode,
input mem_br_taken,
//output to ex stage
output reg [31:0] ex_instr,
output reg[6:0] ex_opcode,
output reg[4:0]  ex_srcreg1_num,
output reg[4:0]  ex_srcreg2_num,
output reg[4:0]  ex_dstreg_num,
output reg[31:0] ex_imm,
output reg[5:0]  ex_alucode,
output reg[1:0]  ex_aluop1_type,
output reg[1:0]  ex_aluop2_type,
output reg[31:0] r0_val,
output reg[31:0] r1_val,
output reg   ex_reg_we,
output reg   ex_is_load,
output reg  ex_is_store,

//output to fetch
output reg stall

    );
	reg one;
	reg two;
	reg start;


    always @(posedge clk)begin
	if (rst ) begin 
	stall =1 ;
	one =0;
	two =0 ;
	ex_instr=0;
	ex_opcode=dec_opcode_1;
	ex_srcreg1_num=dec_srcreg1_num_1;
	ex_srcreg2_num=dec_srcreg1_num_1;
	ex_dstreg_num=dec_dstreg_num_1;
	ex_imm=dec_imm_1;
	ex_alucode=dec_alucode_1;
	ex_aluop1_type=dec_aluop1_type_1;
	ex_aluop2_type=dec_aluop2_type_1;
	r0_val=out1;
	r1_val=out2;
	ex_reg_we=0;
	ex_is_load=0;
	ex_is_store=0;
	start=1;
	end
	else if (one ==0 && two==0  ) begin 
	one =1;
	two = 1;
	stall=1;
	//pipeline
	ex_instr=id_instr1;
	ex_opcode=dec_opcode_1;
	ex_srcreg1_num=dec_srcreg1_num_1;
	ex_srcreg2_num=dec_srcreg1_num_1;
	ex_dstreg_num=dec_dstreg_num_1;
	ex_imm=dec_imm_1;
	ex_alucode=dec_alucode_1;
	ex_aluop1_type=dec_aluop1_type_1;
	ex_aluop2_type=dec_aluop2_type_1;
	r0_val=out1;
	r1_val=out2;
	ex_reg_we=dec_reg_we_1;
	ex_is_load=dec_is_load_1;
	ex_is_store=dec_is_store_1;

	end
	else if (one && two &&   dec_opcode_2!=`BRANCH && ex_opcode!=`BRANCH && mem_opcode!=`BRANCH)begin
	one=0;
	stall =0;
	//pipeline
	ex_instr=id_instr2;
	ex_opcode=dec_opcode_2;
	ex_srcreg1_num=dec_srcreg1_num_2;
	ex_srcreg2_num=dec_srcreg1_num_2;
	ex_dstreg_num=dec_dstreg_num_2;
	ex_imm=dec_imm_2;
	ex_alucode=dec_alucode_2;
	ex_aluop1_type=dec_aluop1_type_2;
	ex_aluop2_type=dec_aluop2_type_2;
	r0_val=out3;
	r1_val=out4;
	ex_reg_we=dec_reg_we_2;
	ex_is_load=dec_is_load_2;
	ex_is_store=dec_is_store_2;
    end
	else if (one==0 && two  && dec_opcode_2!=`BRANCH && ex_opcode!=`BRANCH && mem_opcode!=`BRANCH)begin 
	stall=1;
	one=1;
	two =1;
	//pipeline
	ex_instr=id_instr1;
	ex_opcode=dec_opcode_1;
	ex_srcreg1_num=dec_srcreg1_num_1;
	ex_srcreg2_num=dec_srcreg1_num_1;
	ex_dstreg_num=dec_dstreg_num_1;
	ex_imm=dec_imm_1;
	ex_alucode=dec_alucode_1;
	ex_aluop1_type=dec_aluop1_type_1;
	ex_aluop2_type=dec_aluop2_type_1;
	r0_val=out1;
	r1_val=out2;
	ex_reg_we=dec_reg_we_1;
	ex_is_load=dec_is_load_1;
	ex_is_store=dec_is_store_1;
	
	end
	else if (one==0 && two && dec_opcode_2==`BRANCH)begin
	stall=0;
	one=1;
	two =1;
	//pipeline
	ex_instr=id_instr1;
	ex_opcode=dec_opcode_1;
	ex_srcreg1_num=dec_srcreg1_num_1;
	ex_srcreg2_num=dec_srcreg1_num_1;
	ex_dstreg_num=dec_dstreg_num_1;
	ex_imm=dec_imm_1;
	ex_alucode=dec_alucode_1;
	ex_aluop1_type=dec_aluop1_type_1;
	ex_aluop2_type=dec_aluop2_type_1;
	r0_val=out1;
	r1_val=out2;
	ex_reg_we=dec_reg_we_1;
	ex_is_load=dec_is_load_1;
	ex_is_store=dec_is_store_1;
	
	end
	else if (one && two && dec_opcode_2==`BRANCH)begin
	stall=0;
	one=0;
	two =1;
	//pipeline
	ex_instr=id_instr2;
	ex_opcode=dec_opcode_2;
	ex_srcreg1_num=dec_srcreg1_num_2;
    ex_srcreg2_num=dec_srcreg1_num_2;
    ex_dstreg_num=dec_dstreg_num_2;
    ex_imm=dec_imm_2;
	ex_alucode=dec_alucode_2;
	ex_aluop1_type=dec_aluop1_type_2;
	ex_aluop2_type=dec_aluop2_type_2;
    r0_val=out3;
    r1_val=out4;
	ex_reg_we=dec_reg_we_2;
	ex_is_load=dec_is_load_2;
    ex_is_store=dec_is_store_2;
		
	end
	else if (ex_opcode==`BRANCH)begin
	if(ex_br_taken) begin
		stall=1;
	one=1;
	two=1;
//pipeline
	ex_instr=id_instr1;
	ex_opcode=dec_opcode_1;
	ex_srcreg1_num=dec_srcreg1_num_1;
	ex_srcreg2_num=dec_srcreg1_num_1;
	ex_dstreg_num=dec_dstreg_num_1;
	ex_imm=dec_imm_1;
	ex_alucode=dec_alucode_1;
	ex_aluop1_type=dec_aluop1_type_1;
	ex_aluop2_type=dec_aluop2_type_1;
	r0_val=out1;
	r1_val=out2;
	ex_reg_we=dec_reg_we_1;
	ex_is_load=dec_is_load_1;
	ex_is_store=dec_is_store_1;
    end
	else begin 
	stall=1;
	one=1;
	two=1;
	//pipeline
	ex_instr=id_instr2;
	ex_opcode=dec_opcode_2;
	ex_srcreg1_num=dec_srcreg1_num_2;
	ex_srcreg2_num=dec_srcreg1_num_2;
	ex_dstreg_num=dec_dstreg_num_2;
	ex_imm=dec_imm_2;
	ex_alucode=dec_alucode_2;
	ex_aluop1_type=dec_aluop1_type_2;
	ex_aluop2_type=dec_aluop2_type_2;
	r0_val=out3;
	r1_val=out4;
	ex_reg_we=dec_reg_we_2;
	ex_is_load=dec_is_load_2;
	ex_is_store=dec_is_store_2;
	end
	end
	else if (mem_opcode==`BRANCH)begin
	if(mem_br_taken) begin
	
	stall=0;
	one=0;
	two=1;
	//pipeline
	ex_instr=id_instr1;
	ex_opcode=dec_opcode_1;
	ex_srcreg1_num=dec_srcreg1_num_1;
	ex_srcreg2_num=dec_srcreg1_num_1;
	ex_dstreg_num=dec_dstreg_num_1;
	ex_imm=dec_imm_1;
	ex_alucode=dec_alucode_1;
	ex_aluop1_type=dec_aluop1_type_1;
	ex_aluop2_type=dec_aluop2_type_1;
	r0_val=out1;
	r1_val=out2;
	ex_reg_we=dec_reg_we_1;
	ex_is_load=dec_is_load_1;
	ex_is_store=dec_is_store_1;
    end
	else begin
	stall=0;
	one=0;
	two=1;
	//pipeline
	ex_instr=id_instr2;
	ex_opcode=dec_opcode_2;
	ex_srcreg1_num=dec_srcreg1_num_2;
	ex_srcreg2_num=dec_srcreg1_num_2;
	ex_dstreg_num=dec_dstreg_num_2;
	ex_imm=dec_imm_2;
	ex_alucode=dec_alucode_2;
	ex_aluop1_type=dec_aluop1_type_2;
	ex_aluop2_type=dec_aluop2_type_2;
	r0_val=out3;
	r1_val=out4;
	ex_reg_we=dec_reg_we_2;
	ex_is_load=dec_is_load_2;
	ex_is_store=dec_is_store_2;
	
	end
	end
	end
	
	
endmodule
