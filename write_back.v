`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:31 11/09/2019 
// Design Name: 
// Module Name:    write_back 
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
module write_back(
input clk,
input rst,
input [31:0]mem_instr,
input [31:0]mem_pc,
input [4:0] mem_dstreg_num,
input [5:0] mem_alucode,
input [31:0] mem_alu_result,
input mem_reg_we,
input mem_is_load,
input [31:0] mem_load_value,
output reg [31:0]wb_instr,
output reg [4:0] wb_dstreg_num,
output wire [31:0] wb_dstreg_value,
output reg [31:0] wb_pc,
output reg wb_reg_we
);


reg [4:0] wb_alucode;
reg [31:0] wb_alu_result;
reg wb_is_load ;
reg [31:0] wb_load_value;

always @(posedge clk )
begin
wb_reg_we <= mem_reg_we;
            wb_dstreg_num <= mem_dstreg_num;
            wb_is_load <= mem_is_load;
            wb_alucode <= mem_alucode;
            wb_alu_result <= mem_alu_result;
			wb_load_value <= mem_load_value;
			wb_instr<=mem_instr;
			wb_pc<=mem_pc;
end
assign wb_dstreg_value = wb_is_load ? wb_load_value : wb_alu_result;



endmodule
