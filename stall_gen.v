`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:28:34 11/24/2019 
// Design Name: 
// Module Name:    stall_gen 
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


module stall_gen(
input [4:0]ex_dstreg_num,
input [4:0]dec_srcreg1_num_1,
input [4:0]dec_srcreg2_num_1,
input [4:0]dec_srcreg1_num_2,
input [4:0]dec_srcreg2_num_2,
input [5:0]ex_alucode,
output stall_raw_1,
output stall_raw_2
    );
	
//only raw after load instr
assign stall_raw_1 = ((ex_dstreg_num==dec_srcreg1_num_1 || ex_dstreg_num==dec_srcreg2_num_1 ) && (ex_alucode  ==  `ALU_LB || ex_alucode  == `ALU_LH || ex_alucode  ==  `ALU_LW||ex_alucode  ==`ALU_LBU ||ex_alucode  ==`ALU_LHU )) ? 1:0;
//
assign stall_raw_2 = ((ex_dstreg_num==dec_srcreg1_num_2 || ex_dstreg_num==dec_srcreg2_num_2) && (ex_alucode  ==  `ALU_LB || ex_alucode  == `ALU_LH || ex_alucode  ==  `ALU_LW||ex_alucode  ==`ALU_LBU ||ex_alucode  ==`ALU_LHU )) ? 1:0;

endmodule
